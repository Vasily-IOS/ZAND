//
//  ProfileView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

protocol ProfileViewDelegate: AnyObject {
    func showTelegramBot()
}

final class ProfileView: BaseUIView {

    // MARK: - Properties

    weak var delegate: ProfileViewDelegate?

    let userNameView = UserNameView()

    lazy var collectionView: UICollectionView = {
        var layout = createLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: ProfileCell.self)
        collectionView.register(cellType: FavouritesCell.self)
        collectionView.register(view: ReuseHeaderView.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    lazy var emptyLabel: UILabel = {
        var emptyLabel = UILabel()
        emptyLabel.font = .systemFont(ofSize: 24, weight: .regular)
        emptyLabel.textColor = .textGray
        emptyLabel.text = AssetString.empty
        return emptyLabel
    }()

    private lazy var callUsButton: BottomButton = {
        let callUsButton = BottomButton(buttonText: .callUs)
        callUsButton.addTarget(self, action: #selector(callUsAction), for: .touchUpInside)
        return callUsButton
    }()

    private let layout: DefaultProfileLayout

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .mainGray
        return scrollView
    }()

    // MARK: - Initializers
    
    init(layout: DefaultProfileLayout) {
        self.layout = layout

        super.init(frame: .zero)
    }
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
    }
    
    // MARK: - Action
    
    @objc
    private func callUsAction() {
        delegate?.showTelegramBot()
    }
}

extension ProfileView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubview(scrollView)
        scrollView.addSubviews([userNameView, collectionView, callUsButton, emptyLabel])

        scrollView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }

        userNameView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(110)
            make.width.equalTo(scrollView)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(userNameView.snp.bottom).offset(50)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.height.equalTo(400)
        }

        callUsButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(45)
            make.width.equalTo(280)
            make.height.equalTo(44)
            make.centerX.equalTo(self)
            make.bottom.equalTo(scrollView.snp.bottom).inset(40)
        }

        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.top).offset(270)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, _  in
            switch ProfileSection.init(rawValue: section) {
            case .profileFields:
                return self.layout.createSection(type: .profileFields)
            case .favourites:
                return self.layout.createSection(type: .favourites)
            default:
                return nil
            }
        }
        return layout
    }
}
