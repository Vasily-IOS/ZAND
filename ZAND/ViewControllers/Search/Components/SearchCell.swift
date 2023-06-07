//
//  SearchCell.swift
//  ZAND
//
//  Created by Василий on 06.06.2023.
//

import UIKit

final class SearchCell: BaseTableCell {
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setSelf()
        addLine()
    }
}

extension SearchCell {
    
    // MARK: - Instance methods
    
    private func setSelf() {
        contentView.backgroundColor = .mainGray
        selectionStyle = .none
    }
}
