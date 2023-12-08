//
//  ServicesViewController.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit

final class ServicesViewController: BaseViewController<ServicesView> {

    // MARK: - Properties

    var presenter: ServicesPresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
        hideBackButtonTitle()
        subscribeNotifications()
        setupRecognizer()
    }

    deinit {
        print("ServicesViewController died")
    }

    // MARK: - Instance methods

    @objc
    private func handleNavigationBarTouches(_ recognizer: UIGestureRecognizer) {
        if contentView.searchBar.text?.isEmpty == true {
            contentView.endEditing()
        }
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        contentView.tableView.contentSize.height += keyboardSize.height
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        guard let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        contentView.tableView.contentSize.height -= (keyboardSize.height)
    }

    private func subscribeDelegates() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.searchBar.delegate = self
    }

    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }

    private func setupRecognizer() {
        navigationController?.navigationBar.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(handleNavigationBarTouches)
            )
        )
    }
}

extension ServicesViewController: UITableViewDataSource {

    // MARK: - UITableViewDataSource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.model.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter?.model[section]

        if section?.isOpened == true {
            return (section?.services.count ?? 0) + 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueCell(withType: CategoryCell.self, for: indexPath)
            if let categories = presenter?.model[indexPath.section] {
                cell.configure(model: categories)
            }
            return cell
        } else {
            let cell = tableView.dequeueCell(withType: ServiceCell.self, for: indexPath)
            cell.configure(model: presenter?.model[indexPath.section].services[indexPath.row - 1])
            return cell
        }
    }
}

extension ServicesViewController: UITableViewDelegate {

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            presenter?.model[indexPath.section].isOpened = !(presenter?.model[indexPath.section].isOpened)!
            contentView.endEditing(true)
            reloadData()
        } else {
            guard let viewModel = presenter?.viewModel else { return }
            viewModel.bookService = presenter?.model[indexPath.section].services[indexPath.row - 1]

            switch viewModel.bookingType {
            case .service:
                AppRouter.shared.pushCreateRecord(.staff(viewModel: viewModel))
            case .staff:
                AppRouter.shared.pushCreateRecord(.timeTable(viewModel: viewModel))
            case .default:
                break
            }
        }
    }
}

extension ServicesViewController: UISearchBarDelegate {

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(text: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == AssetString.findInServices.rawValue {
            contentView.searchBar.text = nil
        }
        contentView.searchBar.searchTextField.textColor = .black
    }
}

extension ServicesViewController: ServicesViewInput {

    // MARK: - ServicesViewInput methods

    func reloadData() {
        DispatchQueue.main.async {
            UIView.transition(
                with: self.contentView.tableView,
                duration: 0.1,
                options: .transitionCrossDissolve,
                animations: { self.contentView.tableView.reloadData() }
            )
        }
    }

    func showIndicator(_ isShow: Bool) {
        contentView.showActivity(isShow)
    }
}

extension ServicesViewController: HideBackButtonTitle {}
