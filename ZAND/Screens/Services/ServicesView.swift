//
//  ServicesView.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit
import SnapKit

final class ServicesView: BaseUIView {

    // MARK: - Properties

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.text = AssetString.findInServices
        UISearchBar.appearance().setImage(
            AssetImage.search_icon,
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

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(type: CategoryCell.self)
        tableView.registerCell(type: ServiceCell.self)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .mainGray
        return tableView
    }()

    // MARK: - Instance methods

    @objc
    private func cancelEditingAction() {
        endEditing(true)
        searchBar.text = AssetString.findInServices
        searchBar.searchTextField.textColor = .lightGray
    }

    override func setup() {
        super.setup()

        setViews()
        setGesture()
    }

    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([searchBar, tableView])

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
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

    private func setGesture() {
//        addGestureRecognizer(UITapGestureRecognizer(
//            target: self,
//            action: #selector(cancelEditingAction))
//        )
    }
}