//
//  PostViewScrollable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/2/16.
//
//

import UIKit

protocol DataControllable: class {
    var dataView: DataViewable { get }
    var cellNibName: String { get }
    var cellReuseIdentifier: String { get }
    var cellBundleIdentifier: String { get }
    var indexPathForSelectedItem: NSIndexPath? { get }
    var activityIndicator: UIActivityIndicatorView { get }
    
    func setupDataSource()
    func setupActivityIndicator(
        viewStyle: UIActivityIndicatorViewStyle, color: UIColor) -> UIActivityIndicatorView
}

extension DataControllable where Self: UIViewController {
    
    var cellReuseIdentifier: String {
        return "Cell"
    }
    
    var cellBundleIdentifier: String {
        return AppConstants.bundleIdentifier
    }
    
    func didLoad() {
        setupInterface()
        setupDataSource()
    }
    
    func setupInterface() {
        self.dataView.registerNib(cellNibName,
            cellIdentifier: cellReuseIdentifier,
            bundleIdentifier: cellBundleIdentifier)
    }
}