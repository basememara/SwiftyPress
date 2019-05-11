//
//  ScrollableFlowLayout.swift
//  SwiftyPress iOS
//
//  Created by Basem Emara on 2018-10-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

public protocol ScrollableFlowLayout {
    func willBeginDragging()
    func willEndDragging(withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}
