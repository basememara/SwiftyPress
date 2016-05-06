//
//  DataScrollable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/2/16.
//
//

import Foundation

public protocol DataViewable {
    func reloadData()
    func registerNib(nibName: String, cellIdentifier: String, bundleIdentifier: String?)
}

extension UITableView: DataViewable {}
extension UICollectionView: DataViewable {}