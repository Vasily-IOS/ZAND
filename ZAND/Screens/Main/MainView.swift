//
//  MainView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit
import Lottie

protocol MainViewDelegate: AnyObject {
    func showSearch()
}

final class MainView: BaseUIView {

    // MARK: - Properties
    
    weak var delegate: MainViewDelegate?

    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        collectionView.register(cellType: OptionCell.self)
        collectionView.register(cellType: SaloonCell.self)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()

    private lazy var searchButton = SearchButton()

    private let layoutBuilder: DefaultMainLayout

    private let lostConnectionAnimation: LottieAnimationView = {
        var lostConnectionAnimation = LottieAnimationView(name: Config.animation_noInternet)
        lostConnectionAnimation.play()
        return lostConnectionAnimation
    }()

    private let lostConnectionImage = UIImageView(image: AssetImage.lostConnection_icon)

    private let emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.text = AssetString.noSalons
        emptyLabel.font = .systemFont(ofSize: 24, weight: .regular)
        emptyLabel.textColor = .textGray
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true
        return emptyLabel
    }()
    
    // MARK: - Initializers
    
    init(layoutBuilder: DefaultMainLayout) {
        self.layoutBuilder = layoutBuilder

        super.init(frame: .zero)

        searchButton.tapHandler = { [weak self] in
            self?.delegate?.showSearch()
        }
    }
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
    }

    func changeHeartAppearance(by indexPath: IndexPath) {
        if let cell = self.collectionView.cellForItem(at: indexPath) as? SaloonCell {
            cell.isInFavourite = !cell.isInFavourite
        }
    }

    func scrollToItem(at indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }

    func setLostConnectionAimation(isConnected: Bool) {
        addSubview(lostConnectionAnimation)

        lostConnectionAnimation.isHidden = isConnected
        collectionView.isUserInteractionEnabled = isConnected
        lostConnectionAnimation.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func reloadData() {
        DispatchQueue.main.async {
            UIView.transition(
                with: self.collectionView,
                duration: 0.1,
                options: .transitionCrossDissolve,
                animations: { self.collectionView.reloadData() }
            )
        }
    }

    func isLabelShows(_ isShow: Bool) {
        emptyLabel.isHidden = !isShow
    }
}

extension MainView {
    
    // MARK: - Instance methods

    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([searchButton, collectionView, emptyLabel])
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(25)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.bottom.equalTo(self)
        }

        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(195)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout
        { section, _ in
            switch MainSection.init(rawValue: section) {
            case .option:
                return self.layoutBuilder.createSection(type: .option)
            case .beautySaloon:
                return self.layoutBuilder.createSection(type: .beautySaloon)
            default:
                return nil
            }
        }
        return layout
    }
}
