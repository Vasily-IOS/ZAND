//
//  ThirdViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import RealmSwift

final class ProfileViewController: BaseViewController<ProfileView> {
    
    // MARK: - Properties

    var presenter: ProfilePresenterOutput?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    var profileMenuModel: [ProfileMenuModel] {
        return presenter?.getMenuModel() ?? []
    }

    var saloonModel: [Saloon] = [] {
        didSet {
            contentView.emptyLabel.isHidden = !saloonModel.isEmpty
        }
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()

        showNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.updateProfile()
    }

    deinit {
        print("ProfileViewController died")
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        contentView.delegate = self
    }
}

extension ProfileViewController {
    
    // MARK: - Instance methods
    
    private func showLogOutAlert() {
        let alertController = UIAlertController(
            title: AssetString.exitMessage.rawValue,
            message: nil,
            preferredStyle: .alert)
        let noAction = UIAlertAction(title: AssetString.no.rawValue, style: .cancel)
        let yesAction = UIAlertAction(
            title: AssetString.yes.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.presenter?.signOut()
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }

    private func showDeleteProfileAlert() {
        let alertController = UIAlertController(
            title: AssetString.areYouSure.rawValue,
            message: nil,
            preferredStyle: .alert)
        let noAction = UIAlertAction(title: AssetString.no.rawValue, style: .cancel)
        let yesAction = UIAlertAction(
            title: AssetString.yes.rawValue,
            style: .default) { [weak self] _ in
                self?.presenter?.deleteProfile()
            }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }

    private func reloadData() {
        DispatchQueue.main.async {
            UIView.transition(
                with: self.contentView.collectionView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: { self.contentView.collectionView.reloadData() }
            )
        }
    }
}

extension ProfileViewController: ProfileViewDelegate {

    // MARK: - ProfileViewDelegate methods

    func showTelegramBot() {
        guard let botURL = URL.init(string: AssetURL.telegram_bot.rawValue) else {
            return
        }

        if UIApplication.shared.canOpenURL(botURL) {
            UIApplication.shared.open(botURL)
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource {

    // MARK: - UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ProfileSection.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch ProfileSection.init(rawValue: section) {
        case .profileFields:
            return profileMenuModel.count
        case .favourites:
            return saloonModel.count
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch ProfileSection.init(rawValue: indexPath.section) {
        case .profileFields:
            let cell = collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: ProfileCell.self)
            cell.configure(model: profileMenuModel[indexPath.row])
            return cell
        case .favourites:
            let cell = collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: FavouritesCell.self)
            cell.configure(model: saloonModel[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate {

    // MARK: - UICollectionViewDelegate methods

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch ProfileSection.init(rawValue: indexPath.section) {
        case .profileFields:
            switch indexPath.row {
            case 0:
                AppRouter.shared.presentRecordNavigation(type: .appointments)
            case 1:
                showLogOutAlert()
            case 2:
                showDeleteProfileAlert()
            default:
                break
            }
        case .favourites:
            AppRouter.shared.push(.saloonDetail(saloonModel[indexPath.row]))
        default:
            break
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableView(
            for: indexPath,
            viewType: ReuseHeaderView.self,
            kind: .header)
        headerView.state = .favourites
        return headerView
    }
}

extension ProfileViewController: ProfileViewInput {

    // MARK: - ProfileViewInput methods

    func updateProfile(model: UserDataBaseModel) {
        contentView.userNameView.configure(model: model)
    }

    func updateWithSaloons(model: [Saloon]) {
        saloonModel = model
        reloadData()
    }
}

extension ProfileViewController: HideBackButtonTitle, ShowNavigationBar {}
