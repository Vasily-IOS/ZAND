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
    func dismiss(value: SaloonMockModel)
    func dismiss()
}

final class SearchView: BaseUIView {
   
    // MARK: - Properties
    
    weak var delegate: SearchViewDelegate?
    
    var model: [SaloonMockModel] = [] {
        didSet {
            filteredModel = model
        }
    }
    
    var filteredModel: [SaloonMockModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI

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
        setViews()
        subscribeDelegates()
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
    
    private func subscribeDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
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

        cancelButton.addTarget(self, action: #selector(cancelTapAction), for: .touchUpInside)
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
        endEditing(true)
        delegate?.dismiss(value: filteredModel[indexPath.row])
    }
}

extension SearchView: UISearchBarDelegate {

    // MARK: - UISearchBarDelegate methods

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredModel = []
        if searchText.isEmpty {
            filteredModel = model
        }
        model.forEach {
            if $0.name.uppercased().contains(searchText.uppercased()) {
                filteredModel.append($0)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == StringsAsset.where_wanna_go {
            searchBar.text = nil
        }
        searchBar.searchTextField.textColor = .black
    }
}
