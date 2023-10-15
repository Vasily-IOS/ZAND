//
//  BaseTableCell.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit

class BaseTableCell: UITableViewCell {

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    
    func setup() {
        contentView.backgroundColor = .white
        selectionStyle = .none
        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        contentView.layer.cornerRadius = 15
    }
}
