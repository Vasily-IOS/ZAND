//
//  SaloonPhotoCollection.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit

final class SaloonPhotoCollection: BaseUIView {
    
    // MARK: - Model
    
    var model: SaloonMockModel? = nil {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - UI
    
    private (set) lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(SaloonPhotoCell.self, forCellWithReuseIdentifier: "test")
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
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "like_icon"), for: .normal)
        return likeButton
    }()
    
    private let categoryLabel = UILabel(.systemFont(ofSize: 12), .textGray)
    private let ratingLabel = UILabel(.systemFont(ofSize: 12))
    private let starImage = UIImageView(image: UIImage(named: "star_icon"))
    private let gradeLabel = UILabel(.systemFont(ofSize: 12), nil, Strings.grades)
    private let gradeCountLabel = UILabel(.systemFont(ofSize: 12))
    private let heartImage = UIImageView(image: UIImage(named: "fav_icon"))
    private let bottomButton = BottomButton(buttonText: .book)
    
    // MARK: - Initializers
    
    init(model: SaloonMockModel) {
        super.init(frame: .zero)
        setInfo(from: model)
    }
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        subscribeDelegate()
        setBackgroundColor()
        setViews()
        
        bottomButton.addTarget(self, action: #selector(bookAction), for: .touchUpInside)
    }
    
    private func setInfo(from model: SaloonMockModel) {
        self.model = model
        self.pageControl.numberOfPages = model.photos.count
        self.nameLabel.text = model.name
        self.categoryLabel.text = model.category.name
        self.ratingLabel.text = "\(model.rating)"
        self.gradeCountLabel.text = "\(model.scores)"
    }
    
    @objc
    private func bookAction() {
        AppRouter.shared.present(type: .booking)
    }
}

extension SaloonPhotoCollection {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([collectionView, pageControl, nameLabel, categoryLabel, ratingLabel,
                     starImage, gradeLabel, gradeCountLabel, likeButton, heartImage, bottomButton])
        
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
        
        starImage.snp.makeConstraints { make in
            make.left.equalTo(ratingLabel.snp.right).offset(1)
            make.centerY.equalTo(ratingLabel)
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.left.equalTo(starImage.snp.right).offset(15)
            make.centerY.equalTo(starImage)
        }
        
        gradeCountLabel.snp.makeConstraints { make in
            make.left.equalTo(gradeLabel.snp.right).offset(2)
            make.centerY.equalTo(starImage)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(29)
            make.right.equalTo(self).inset(16)
        }
        
        heartImage.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.right.equalTo(likeButton.snp.right).offset(-110)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(27)
            make.width.equalTo(280)
            make.height.equalTo(44)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).inset(35)
        }
    }
    
    private func subscribeDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
}

extension SaloonPhotoCollection: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath) as! SaloonPhotoCell
        cell.configure(image: model?.photos[indexPath.item] ?? UIImage())
        return cell
    }
}

extension SaloonPhotoCollection: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

extension SaloonPhotoCollection: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
}
