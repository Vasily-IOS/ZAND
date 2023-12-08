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
        let items = [AssetString.feature.rawValue, AssetString.was.rawValue]
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
        let emptyLabel = UILabel()
        emptyLabel.text = AssetString.noAppointments.rawValue
        emptyLabel.font = .systemFont(ofSize: 24, weight: .regular)
        emptyLabel.textColor = .textGray
        return emptyLabel
    }()

    private let activityIndicatorView = UIActivityIndicatorView()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        addTarget()
    }

    @objc
    private func changeModel(_ sender: UISegmentedControl) {
        delegate?.changeModel(by: sender.selectedSegmentIndex == 0 ? .waitingServices : .servicesProvided)
    }

    func showActivity(_ isShow: Bool) {
        if isShow {
            addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            [segmentControl, tableView].forEach({ $0.isHidden = true })

            activityIndicatorView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        } else {
            [segmentControl, tableView].forEach({ $0.isHidden = false })
            activityIndicatorView.removeFromSuperview()
            activityIndicatorView.stopAnimating()
        }
    }

    func isShowEmptyLabel(_ isShow: Bool) {
        emptyLabel.isHidden = !isShow
    }
}

extension AppointemtsView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([segmentControl, tableView, emptyLabel])
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            make.bottom.equalTo(self)
        }

        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
        }
    }

    private func addTarget() {
        segmentControl.addTarget(
            self,
            action: #selector(changeModel(_:)),
            for: .valueChanged
        )
    }
}
