//
//  ProfileView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

enum ProfileSelect: Int {
    case appointments
    case settings
    case logOut
}

final class ProfileView: BaseUIView {
    
    // MARK: - Closures
    
    var alertHandler: (() -> ())?
    
    private let viewOnMapClosure = { (coordinates: String) in
        AppRouter.shared.push(.selectableMap(coordinates))
    }
    
    // MARK: - Properties
    
    var layout: DefaultProfileLayoutProtocol?
    private let profileMenuModel = ProfileMenuModel.model
    private let saloonMockModel = SaloonMockModel.saloons
    
    // MARK: - UI
    
    private let userNameView = UserNameView()
    private let callUsButton = BottomButton(buttonText: .callUs)
    
    private lazy var collectionView: UICollectionView = {
        var layout = createLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProfileCell.self,
                                forCellWithReuseIdentifier: String(describing: ProfileCell.self))
        collectionView.register(FavouritesCell.self,
                                forCellWithReuseIdentifier: String(describing: FavouritesCell.self))
        collectionView.register(ReuseHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: ReuseHeader.self))
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init(layout: DefaultProfileLayoutProtocol) {
        self.layout = layout
        super.init(frame: .zero)
    }
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setBackgroundColor()
        subscribeDelegates()
        addTargets()
    }
    
    // MARK: - Action
    
    @objc
    private func callUsAction() {
        print("Свяжитесь с нами")
    }
}

extension ProfileView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([userNameView, collectionView, callUsButton])
        
        userNameView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.top.equalTo(self).offset(109)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(userNameView.snp.bottom).offset(50)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        callUsButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(45)
            make.width.equalTo(280)
            make.height.equalTo(44)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).inset(120)
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
    
    private func subscribeDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            switch ProfileSection.init(rawValue: section) {
            case .profileFields:
                return self.layout?.createSection(type: .profileFields)
            case .favourites:
                return self.layout?.createSection(type: .favourites)
            default:
                return nil
            }
        }
        return layout
    }
    
    private func addTargets() {
        callUsButton.addTarget(self, action: #selector(callUsAction), for: .touchUpInside)
    }
}

extension ProfileView: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ProfileSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch ProfileSection.init(rawValue: section) {
        case .profileFields:
            return profileMenuModel.count
        case .favourites:
            return saloonMockModel.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch ProfileSection.init(rawValue: indexPath.section) {
        case .profileFields:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileCell.self),
                                                          for: indexPath) as! ProfileCell
            cell.configure(model: profileMenuModel[indexPath.row])
            return cell
        case .favourites:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavouritesCell.self),
                                                          for: indexPath) as! FavouritesCell
            cell.configure(model: saloonMockModel[indexPath.row])
            cell.viewOnMapHandler = viewOnMapClosure
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension ProfileView: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch ProfileSection.init(rawValue: indexPath.section) {
        case .profileFields:
            switch ProfileSelect.init(rawValue: indexPath.row) {
            case .appointments:
                AppRouter.shared.push(.appointments)
            case .settings:
                AppRouter.shared.push(.settings)
            case .logOut:
                alertHandler?()
            default:
                break
            }
        case .favourites:
            AppRouter.shared.push(.saloonDetail(saloonMockModel[indexPath.row]))
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: String(describing: ReuseHeader.self),
                                                                         for: indexPath) as! ReuseHeader
        headerView.state = .favourites
        return headerView
    }
}
