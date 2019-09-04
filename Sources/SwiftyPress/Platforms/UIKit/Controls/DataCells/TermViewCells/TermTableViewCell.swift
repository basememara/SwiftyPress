//
//  TagTableViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-26.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

open class TermTableViewCell: UITableViewCell, TermsDataViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
}

extension TermTableViewCell {
    
    open func bind(_ model: TermsDataViewModel) {
        nameLabel.text = model.name
        countLabel.text = "(\(model.count))"
    }
}
