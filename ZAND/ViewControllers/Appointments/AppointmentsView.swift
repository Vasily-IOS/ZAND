//
//  AppointmentsView.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit
import SnapKit

final class AppointemtsView: BaseUIView {
    
    // MARK: - Properties
    
    // MARK: - Models
    
    private var serviceDeliveredModel: [AppointmentsModel] = []
    private var serviceIsNotDeliveredModel: [AppointmentsModel] = []

    private var rootModel: [AppointmentsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UI
    
    private lazy var segmentControl: UISegmentedControl = {
        let items = [Strings.feature, Strings.was]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .mainGreen
        segmentControl.layer.borderWidth = 2
        segmentControl.layer.borderColor = UIColor.mainGreen.cgColor
        segmentControl.backgroundColor = .mainGray
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        return segmentControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(type: AppoitmentsCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .mainGray
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Initializers
    
     init(model: [AppointmentsModel]) {
        super.init(frame: .zero)
        sortModels(baseModel: model)
    }

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setBackgroundColor()
        subscribeDelegate()
        addTarget()
    }
    
    private func sortModels(baseModel: [AppointmentsModel]) {
        serviceIsNotDeliveredModel = baseModel.filter({ $0.isServiceIsDelivered == false })
        serviceDeliveredModel = baseModel.filter({ $0.isServiceIsDelivered == true })
        rootModel = serviceIsNotDeliveredModel
    }
    
    // MARK: - Action
    
    @objc
    private func changeModel(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            rootModel = serviceIsNotDeliveredModel
        case 1:
            rootModel = serviceDeliveredModel
        default:
            break
        }
    }
}

extension AppointemtsView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([segmentControl, tableView])
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(self).offset(130)
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
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
    
    private func subscribeDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addTarget() {
        segmentControl.addTarget(self, action: #selector(changeModel(_:)), for: .valueChanged)
    }
}

extension AppointemtsView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rootModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: AppoitmentsCell.self, for: indexPath) as! AppoitmentsCell
        cell.configure(model: rootModel[indexPath.section])
        return cell
    }
}

extension AppointemtsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: .zero)
    }
}
