//
//  PostViewScrollable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/2/16.
//
//

import UIKit

public protocol DataControllable: class {
    associatedtype ServiceType: Serviceable
    
    var service: ServiceType { get }
    var models: [ServiceType.DataType] { get set }
    var dataView: DataViewable { get }
    var cellNibName: String { get }
    var cellReuseIdentifier: String { get }
    var cellBundleIdentifier: String { get }
    var activityIndicator: UIActivityIndicatorView? { get set }
    
    func setupActivityIndicator(
        viewStyle: UIActivityIndicatorViewStyle, color: UIColor) -> UIActivityIndicatorView
}

public extension DataControllable where Self: UIViewController {
    
    var cellReuseIdentifier: String {
        return "Cell"
    }
    
    var cellBundleIdentifier: String {
        return AppConstants.bundleIdentifier
    }
    
    public func didLoad() {
        setupInterface()
        loadData()
    }
    
    public func setupInterface() {
        self.dataView.registerNib(cellNibName,
            cellIdentifier: cellReuseIdentifier,
            bundleIdentifier: cellBundleIdentifier)
        
        activityIndicator = setupActivityIndicator(
            .WhiteLarge, color: .grayColor())
    }
    
    public func loadData() {
        activityIndicator?.startAnimating()
        
        service.get { models in
            self.models = models
            self.dataView.reloadData()
            self.activityIndicator?.stopAnimating()
        }
    }
}