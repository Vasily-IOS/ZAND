//
//  SearchView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

protocol SearchViewDelegate: AnyObject {
    func dismiss(value: SaloonMockModel)
}

final class SearchView: BaseUIView {
   
    // MARK: - Properties
    
    weak var delegate: SearchViewDelegate?
    
    var model: [SaloonMockModel]? {
        didSet {
            if let model = model {
                filteredModel = model
            }
        }
    }
    
    var filteredModel: [SaloonMockModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UI
    
    private let searchBar: UISearchBar = {
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

    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.registerCell(type: SearchCell.self)
        tableView.backgroundColor = .mainGray
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setBackgroundColor()
        setViews()
        subscribeDelegates()
        setGestureRecognizer()
    }
    
    // MARK: - Action
    
    @objc
    private func searchingIsOverAction() {
        searchBar.text = StringsAsset.where_wanna_go
        searchBar.resignFirstResponder()
    }
}

extension SearchView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([searchBar, tableView])
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
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
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
    
    private func subscribeDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    private func setGestureRecognizer() {
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(searchingIsOverAction))
//        view.addGestureRecognizer(recognizer)
    }
    
    private func changeSearchTextColor() {
        searchBar.searchTextField.textColor = .black
    }
}

extension SearchView: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: SearchCell.self, for: indexPath) as! SearchCell
        cell.configure(model: filteredModel[indexPath.row])
        return cell
    }
}

extension SearchView: UITableViewDelegate {

    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = filteredModel[indexPath.row].name
        searchBar.text = text
        changeSearchTextColor()
        delegate?.dismiss(value: filteredModel[indexPath.row])
    }
}

extension SearchView: UISearchBarDelegate {

    // MARK: - UISearchBarDelegate methods

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredModel = []
        if searchText.isEmpty {
            if let model = model {
                filteredModel = model
            }
        }
        model?.forEach {
            if $0.name.uppercased().contains(searchText.uppercased()) {
                filteredModel.append($0)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == StringsAsset.where_wanna_go {
            searchBar.text = nil
        }
        changeSearchTextColor()
    }
}
