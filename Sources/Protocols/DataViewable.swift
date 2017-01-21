//
//  DataScrollable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/2/16.
//
//

import Foundation

protocol DataViewable {
    var contentInset: UIEdgeInsets { get set }
    
    func reloadData()
    func registerNib(_ nibName: String, cellIdentifier: String, bundleIdentifier: String?)
    func setContentOffset(_ contentOffset: CGPoint, animated: Bool)
}

extension DataViewable {
    
    func scrollToTop(_ animated: Bool = true) {
        setContentOffset(CGPoint(x: 0, y: -(contentInset.top)), animated: animated)
    }
}

extension UITableView: DataViewable {}
extension UICollectionView: DataViewable {}
