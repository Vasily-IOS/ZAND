//
//  AppointmentsView.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit
import SnapKit

protocol AppointmentsDelegate: AnyObject {
    func changeModel(by type: AppointmentType)
}

final class AppointemtsView: BaseUIView {

    // MARK: - Properties

    weak var delegate: AppointmentsDelegate?
    
    // MARK: - UI
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(type: AppoitmentsCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .mainGray
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var segmentControl: UISegmentedControl = {
        let items = [AssetString.feature, AssetString.was]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .mainGreen
        segmentControl.layer.borderWidth = 2
        segmentControl.layer.borderColor = UIColor.mainGreen.cgColor
        segmentControl.tintColor = .mainGray

        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unSelected = [NSAttributedString.Key.foregroundColor: UIColor.mainGreen]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(unSelected, for: .normal)
        return segmentControl
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        addTarget()
    }

    // MARK: - Action
    
    @objc
    private func changeModel(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.changeModel(by: .upcoming)
        case 1:
            delegate?.changeModel(by: .past)
        default:
            break
        }
    }
}

extension AppointemtsView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([segmentControl, tableView])
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.bottom.equalTo(self)
        }
    }

    private func addTarget() {
        segmentControl.addTarget(self,
                                 action: #selector(changeModel(_:)),
                                 for: .valueChanged)
    }
}
