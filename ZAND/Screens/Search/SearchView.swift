//
//  SearchView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit
import Combine

protocol SearchViewDelegate: AnyObject {
    func dismiss()
}

final class SearchView: BaseUIView {
   
    // MARK: - Properties
    
    weak var delegate: SearchViewDelegate?

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.text = StringsAsset.where_wanna_go
        UISearchBar.appearance().setImage(ImageAsset.search_icon,
                                          for: .search,
                                          state: .normal)
        searchBar.layer.cornerRadius = 15
        searchBar.backgroundColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchBarStyle = .prominent
        searchBar.searchTextField.textColor = .lightGray
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.registerCell(type: SearchCell.self)
        tableView.backgroundColor = .mainGray
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let searchLabel: UILabel = {
        let searchLabel = UILabel()
        searchLabel.text = StringsAsset.search
        searchLabel.font = .systemFont(ofSize: 22, weight: .regular)
        return searchLabel
    }()

    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle(StringsAsset.cancel, for: .normal)
        cancelButton.setTitleColor(.textGray, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 22)
        return cancelButton
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        setTargets()
    }
    
    // MARK: - Action

    @objc
    private func cancelTapAction() {
        delegate?.dismiss()
    }
}

extension SearchView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([searchLabel, cancelButton, searchBar, tableView])
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
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.bottom.equalTo(self).inset(16)
        }
    }

    private func setSearchPlaceholderText() {
        searchBar.text = StringsAsset.where_wanna_go
        searchBar.searchTextField.textColor = .lightGray
    }

    private func setTargets() {
        gesture(.tap())
            .sink { [weak self] _ in
                self?.endEditing(true)
                self?.setSearchPlaceholderText()
            }.store(in: &cancellables)

        cancelButton.addTarget(self, action: #selector(cancelTapAction),
                               for: .touchUpInside)
    }
}
