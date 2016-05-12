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
    func registerNib(nibName: String, cellIdentifier: String, bundleIdentifier: String?)
    func setContentOffset(contentOffset: CGPoint, animated: Bool)
}

extension DataViewable {
    
    func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPointMake(0, -(contentInset.top)), animated: animated)
    }
}

extension UITableView: DataViewable {}
extension UICollectionView: DataViewable {}