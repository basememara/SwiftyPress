//
//  ThemeInterfaces.swift
//  SwiftyPress iOS
//
//  Created by Basem Emara on 2018-09-23.
//

import UIKit

public protocol ThemeStore {
    func apply(for application: UIApplication)
}

public protocol ThemeWorkerType: ThemeStore {
    
}
