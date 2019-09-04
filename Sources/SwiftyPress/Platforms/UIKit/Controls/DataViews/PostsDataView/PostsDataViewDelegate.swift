//
//  PostsDataViewDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import UIKit
import ZamzamCore
import ZamzamUI

public protocol PostsDataViewDelegate: class {
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable)
    func postsDataView(toggleFavorite model: PostsDataViewModel)
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int
    func postsDataViewDidReloadData()
    
    @available(iOS 11.0, *)
    func postsDataView(leadingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration?
    
    @available(iOS 11.0, *)
    func postsDataView(trailingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration?
    
    func postsDataViewWillBeginDragging(_ scrollView: UIScrollView)
    func postsDataViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}

// Optional conformance
public extension PostsDataViewDelegate {
    func postsDataView(toggleFavorite model: PostsDataViewModel) {}
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int { return 1 }
    func postsDataViewDidReloadData() {}
    
    @available(iOS 11.0, *)
    func postsDataView(leadingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? { return UISwipeActionsConfiguration() }
    
    @available(iOS 11.0, *)
    func postsDataView(trailingSwipeActionsForModel model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? { return UISwipeActionsConfiguration() }
    
    func postsDataViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func postsDataViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
}
