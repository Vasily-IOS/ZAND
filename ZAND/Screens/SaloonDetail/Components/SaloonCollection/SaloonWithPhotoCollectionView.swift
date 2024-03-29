//
//  SaloonPhotoCollection.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import Lottie

final class SaloonWithPhotoCollectionView: BaseUIView {

    // MARK: - Closure

    var openBookingHandler: (() -> Void)?
    
    var favouriteHandler:((Int) -> Void)?
    
    // MARK: - Properties

    var inFavourite: Bool = false {
        didSet {
            heartButton.setImage(
                inFavourite ? AssetImage.fillHeart_icon.image : AssetImage.heart_icon.image, for: .normal
            )

            if inFavourite {
                animationView.isHidden = false
                heartButton.isUserInteractionEnabled = false
                animationView.play()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.heartButton.isUserInteractionEnabled = true
                    self.animationView.isHidden = true
                }
            }
        }
    }


    var id: Int = 0

    var photos: [String] = []

    lazy var animationView: LottieAnimationView = {
        var animationView = LottieAnimationView(name: Config.animation_fav)
        animationView.isHidden = true
        return animationView
    }()

    private (set) lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellType: SaloonPhotoCell.self)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .mainGray
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        var pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .mainGreen
        pageControl.pageIndicatorTintColor = .lightGreen
        return pageControl
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    private let categoryLabel = UILabel(.systemFont(ofSize: 12), .textGray)

    private let ratingLabel = UILabel(.systemFont(ofSize: 12))

    private let gradeLabel = UILabel(.systemFont(ofSize: 12), nil, AssetString.grades.rawValue)

    private let gradeCountLabel = UILabel(.systemFont(ofSize: 12))

    private let heartButton = UIButton()

    private let distanceLabel = UILabel(.systemFont(ofSize: 14), .textGray)

    private let bottomButton = BottomButton(buttonText: .book)

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        subscribeDelegate()
        setViews()
        addTarget()
    }

    func configure(model: Saloon) {
        if model.saloonCodable.companyPhotos.count == 1 {
            pageControl.isHidden = true
        } else {
            pageControl.numberOfPages = model.saloonCodable.photos.count
        }
        photos = model.saloonCodable.companyPhotos
        nameLabel.text = model.saloonCodable.title
        categoryLabel.text = model.saloonCodable.shortDescription
        id = model.saloonCodable.id

        if model.distance != nil {
            distanceLabel.text = "до цели" + " " + (model.distanceString ?? "")
        }
    }
    
    // MARK: - Action

    @objc
    private func favouriteAction() {
        favouriteHandler?(id)
    }
    
    @objc
    private func bookAction() {
        openBookingHandler?()
    }
}

extension SaloonWithPhotoCollectionView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([collectionView, pageControl, nameLabel, categoryLabel, ratingLabel,
                    gradeLabel, gradeCountLabel, heartButton, bottomButton, distanceLabel])
        
        collectionView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(255)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.centerX.equalTo(self)
            make.height.equalTo(6)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.top.equalTo(collectionView.snp.bottom).offset(25)
            make.width.equalTo(220)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.left.equalTo(self).offset(16)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
        }
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(25)
            make.right.equalTo(self).inset(16)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(27)
            make.width.equalTo(280)
            make.height.equalTo(44)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).inset(35)
        }

        heartButton.addSubview(animationView)

        animationView.snp.makeConstraints { make in
            make.bottom.equalTo(heartButton)
            make.centerX.equalTo(heartButton)
        }

        distanceLabel.snp.makeConstraints { make in
            make.right.equalTo(heartButton.snp.right)
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
        }
    }
    
    private func subscribeDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func addTarget() {
        heartButton.addTarget(self, action: #selector(favouriteAction), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(bookAction), for: .touchUpInside)
    }
}

extension SaloonWithPhotoCollectionView: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource methods
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photos.isEmpty ? 1 : photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SaloonPhotoCell.self)
        photos.isEmpty ? cell.configureEmpty() : cell.configure(image: photos[indexPath.item])

        return cell
    }
}

extension SaloonWithPhotoCollectionView: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: collectionView.frame.size.width,
            height: collectionView.frame.size.height
        )
    }
}

extension SaloonWithPhotoCollectionView: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(
            origin: self.collectionView.contentOffset,
            size: self.collectionView.bounds.size
        )
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
}
