//
//  StaffView.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit
import SnapKit

final class StaffView: BaseUIView {

    // MARK: - Properties

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(type: StaffCell.self)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: - Instance methods

    override func setup() {
        super.setup()

        setViews()
    }

    private func setViews() {
        addSubviews([tableView])

        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
