//
//  SearchViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import CoreLocation

final class SearchViewController: BaseViewController<SearchView> {

    // MARK: - Nested types

    enum Section {
        case single
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, SaloonModel>

    // MARK: - Properties

    var dataSource: DataSource?

    var indexArray: [IndexPath] = []

    var completionWithState: ((MapState) -> ())?
    
    var completionWithModel: ((SaloonModel) -> ())?
    
    var presenter: SearchPresenter?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
        subscribeNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if indexArray.isEmpty {
            completionWithState?(presenter?.mapState ?? .none)
        } else {
            print("Array is not empty^ call back from cell delegate!")
        }
    }
    
    deinit {
        print("SearchViewController died")
    }
    
    // MARK: - Instance methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    private func subscribeDelegate() {
        contentView.delegate = self
        contentView.tableView.delegate = self
        contentView.searchBar.delegate = self
    }

    private func setupDataSource(model: [SaloonModel]) {
        dataSource = DataSource(tableView: contentView.tableView) {
            tableView, indexPath, item in
            let cell = tableView.dequeueCell(withType: SearchCell.self, for: indexPath)
            cell.configure(model: item)
            return cell
        }
    }

    private func applySnapShot(model: [SaloonModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, SaloonModel>()
        snapShot.appendSections([.single])
        snapShot.appendItems(model)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }

    private func dismiss(value: SaloonModel) {
        completionWithModel?(value)
        AppRouter.shared.dismiss()
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
}

extension SearchViewController: UITableViewDelegate {

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexArray.append(indexPath)
        dismiss(value: (presenter?.modelUI ?? [])[indexPath.item] as! SaloonModel)
        completionWithState?(.saloonZoom)
    }
}

extension SearchViewController: UISearchBarDelegate {

    // MARK: - UISearchBarDelegate methods

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(text: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == AssetString.where_wanna_go.rawValue {
            contentView.searchBar.text = nil
        }
        contentView.searchBar.searchTextField.textColor = .black
    }
}

extension SearchViewController: SearchViewInput {
    
    // MARK: - SearchViewProtocol methods
    
    func updateUI(with model: [Saloon]) {
        guard let model = model as? [SaloonModel] else { return }

        setupDataSource(model: model)
        applySnapShot(model: model)
        contentView.updateEmptyLabel(isShow: !model.isEmpty)
    }

    func updateSegment(index: Int) {
        contentView.updateSegment(index: index)
    }
}

extension SearchViewController: SearchViewDelegate {

    // MARK: - SearchViewDelegate methods

    func changeSegmentIndex() {
        if presenter?.mapState == .noZoomed {
            presenter?.mapState = .zoomed
        } else {
            presenter?.mapState = .noZoomed
        }
    }

    func dismiss() {
        AppRouter.shared.dismiss()
    }
}

extension SearchViewController: HideNavigationBar {}
