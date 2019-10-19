//
//  DefaultTheme.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2019-08-19.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamUI

struct SwiftyTheme: Theme {
    let tint: UIColor = .blue
    let secondaryTint: UIColor = .orange
    
    let backgroundColor: UIColor = .white
    let secondaryBackgroundColor: UIColor = .init(rgb: (242, 242, 247))
    let tertiaryBackgroundColor: UIColor = .init(rgb: (229, 229, 234))
    let quaternaryBackgroundColor: UIColor = .init(rgb: (209, 209, 214))
    
    let separatorColor: UIColor = .lightGray
    let opaqueColor: UIColor = .darkGray
    
    let labelColor: UIColor = .black
    let secondaryLabelColor: UIColor = .init(rgb: (28, 28, 30))
    let tertiaryLabelColor: UIColor = .init(rgb: (44, 44, 46))
    let quaternaryLabelColor: UIColor = .init(rgb: (58, 58, 60))
    let placeholderLabelColor: UIColor = .lightGray
    
    let buttonCornerRadius: CGFloat = 3
    
    let positiveColor: UIColor = .green
    let negativeColor: UIColor = .red
    
    let isDarkStyle: Bool = false
}
