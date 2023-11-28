//
//  SearchView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

protocol SearchViewDelegate: AnyObject {
    func changeSegmentIndex()
    func dismiss()
}

final class SearchView: BaseUIView {
   
    // MARK: - Properties
    
    weak var delegate: SearchViewDelegate?

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: AssetString.where_wanna_go.rawValue,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        UISearchBar.appearance().setImage(
            AssetImage.search_icon.image,
            for: .search,
            state: .normal)
        searchBar.layer.cornerRadius = 15
        searchBar.backgroundColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchBarStyle = .prominent
        searchBar.searchTextField.textColor = .black
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.registerCell(type: SearchCell.self)
        tableView.backgroundColor = .mainGray
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let searchLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.text = AssetString.search.rawValue
        searchLabel.font = .systemFont(ofSize: 22, weight: .regular)
        return searchLabel
    }()

    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle(AssetString.cancel.rawValue, for: .normal)
        cancelButton.setTitleColor(.textGray, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 22)
        return cancelButton
    }()

    private let segmentControl: UISegmentedControl = {
        let items = [AssetString.near.rawValue, AssetString.all.rawValue]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .mainGreen
        segmentControl.tintColor = .mainGray

        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]
        let unSelected = [NSAttributedString.Key.foregroundColor: UIColor.mainGreen]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(unSelected, for: .normal)
        return segmentControl
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = AssetString.noSalons.rawValue
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .textGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        setTargets()
    }

    func updateSegment(index: Int) {
        segmentControl.selectedSegmentIndex = index
    }

    func updateEmptyLabel(isShow: Bool) {
        emptyLabel.isHidden = isShow
    }
    
    // MARK: - Action

    @objc
    private func segmentDidChanged() {
        delegate?.changeSegmentIndex()
    }

    @objc
    private func cancelTapAction() {
        delegate?.dismiss()
    }
}

extension SearchView {
    
    // MARK: - Instance methods

    func endEditing() {
        searchBar.text = AssetString.where_wanna_go.rawValue
        searchBar.searchTextField.textColor = .lightGray
        endEditing(true)
    }
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews(
            [searchLabel, cancelButton, searchBar, segmentControl, tableView, emptyLabel]
        )

        searchLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(searchLabel)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(20)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.height.equalTo(48)
        }

        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
        }

        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(54)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
    }

    private func setTargets() {
        cancelButton.addTarget(
            self,
            action: #selector(cancelTapAction),
            for: .touchUpInside
        )
        segmentControl.addTarget(
            self,
            action: #selector(segmentDidChanged),
            for: .valueChanged
        )
    }
}
