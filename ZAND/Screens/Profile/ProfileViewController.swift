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

    var saloonDBmodel: [SaloonDataBaseModel] {
        return presenter?.getDBmodel() ?? []
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

        presenter?.checkLogIn()
        contentView.collectionView.reloadData()

        contentView.emptyLabel.isHidden = !saloonDBmodel.isEmpty
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
            title: AssetString.exitMessage,
            message: nil,
            preferredStyle: .alert)
        let noAction = UIAlertAction(title: AssetString.no, style: .cancel)
        let yesAction = UIAlertAction(title: AssetString.yes, style: .default) { [weak self] _ in
            self?.presenter?.signOut()
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }

    private func showDeleteProfileAlert() {
        let alertController = UIAlertController(
            title: AssetString.areYouSure,
            message: nil,
            preferredStyle: .alert)
        let noAction = UIAlertAction(title: AssetString.no, style: .cancel)
        let yesAction = UIAlertAction(
            title: AssetString.yes,
            style: .default) { [weak self] _ in
            let alertConrol = UIAlertController(
                title: AssetString.managerWillPhone,
                message: nil,
                preferredStyle: .alert)
            let action = UIAlertAction(
                title: AssetString.ok, style: .cancel)
            alertConrol.addAction(action)
            self?.present(alertConrol, animated: true)
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
}

extension ProfileViewController: ProfileViewDelegate {

    // MARK: - ProfileViewDelegate methods

    func showTelegramBot() {
        guard let botURL = URL.init(string: AssetURL.telegram_bot) else {
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

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch ProfileSection.init(rawValue: section) {
        case .profileFields:
            return profileMenuModel.count
        case .favourites:
            return saloonDBmodel.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            cell.configure(model: saloonDBmodel[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate {

    // MARK: - UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        switch ProfileSection.init(rawValue: indexPath.section) {
        case .profileFields:
            switch indexPath.row {
            case 0:
                AppRouter.shared.presentWithNav(type: .appointments)
            case 1:
                showLogOutAlert()
            case 2:
                showDeleteProfileAlert()
            default:
                break
            }
        case .favourites:
            AppRouter.shared.push(.saloonDetail(.dataBase(saloonDBmodel[indexPath.row])))
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

    func updateWithLoggedData(model: UserDataBaseModel) {
        contentView.userNameView.configure(model: model)
    }
}

extension ProfileViewController: HideBackButtonTitle, ShowNavigationBar {}
