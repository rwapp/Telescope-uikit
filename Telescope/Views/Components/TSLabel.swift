//
//  TSLabel.swift
//  Telescope
//
//  Created by Rob Whitaker on 02/05/2022.
//

import UIKit

class TSLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }

    func setupLabel() {
        numberOfLines = 0
        adjustsFontForContentSizeCategory = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
