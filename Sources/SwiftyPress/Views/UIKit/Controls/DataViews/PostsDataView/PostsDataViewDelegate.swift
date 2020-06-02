//
//  PostsDataViewDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import Foundation
import UIKit
import ZamzamCore
import ZamzamUI

public protocol PostsDataViewDelegate: AnyObject {
    func postsDataView(didSelect model: PostsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable)
    func postsDataView(toggleFavorite model: PostsDataViewModel)
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int
    func postsDataViewDidReloadData()
    
    func postsDataView(leadingSwipeActionsFor model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration?
    
    func postsDataView(trailingSwipeActionsFor model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration?
    
    @available(iOS 13, *)
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration?
    
    @available(iOS 13, *)
    func postsDataView(didPerformPreviewActionFor model: PostsDataViewModel, from dataView: DataViewable)
    
    func postsDataViewWillBeginDragging(_ scrollView: UIScrollView)
    func postsDataViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}

// Optional conformance
public extension PostsDataViewDelegate {
    func postsDataView(toggleFavorite model: PostsDataViewModel) {}
    func postsDataViewNumberOfSections(in dataView: DataViewable) -> Int { return 1 }
    func postsDataViewDidReloadData() {}
    
    func postsDataView(leadingSwipeActionsFor model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration()
    }
    
    func postsDataView(trailingSwipeActionsFor model: PostsDataViewModel, at indexPath: IndexPath, from tableView: UITableView) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration()
    }
    
    @available(iOS 13, *)
    func postsDataView(contextMenuConfigurationFor model: PostsDataViewModel, at indexPath: IndexPath, point: CGPoint, from dataView: DataViewable) -> UIContextMenuConfiguration? {
        nil
    }
    
    @available(iOS 13, *)
    func postsDataView(didPerformPreviewActionFor model: PostsDataViewModel, from dataView: DataViewable) {}
    
    func postsDataViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func postsDataViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
}
#endif
