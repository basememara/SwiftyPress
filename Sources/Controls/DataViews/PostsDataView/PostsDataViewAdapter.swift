//
//  PostDataViewAdapter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamKit

open class PostsDataViewAdapter: NSObject {
    private let dataView: DataViewable
    private weak var delegate: PostsDataViewDelegate?
    public private(set) var viewModels = [PostsDataViewModel]()
    
    public init(for dataView: DataViewable, delegate: PostsDataViewDelegate? = nil) {
        self.dataView = dataView
        self.delegate = delegate
        
        super.init()
        
        // Set data view delegates
        if let tableView = dataView as? UITableView {
            tableView.delegate = self
            tableView.dataSource = self
        } else if let collectionView = dataView as? UICollectionView {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
}

extension PostsDataViewAdapter {
    
    open func reloadData(with viewModels: [PostsDataViewModel]) {
        self.viewModels = viewModels
        dataView.reloadData()
        delegate?.postsDataViewDidReloadData()
    }
}

// MARK: - UITableView delegates

extension PostsDataViewAdapter: UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //Handle cell highlight
        
        delegate?.postsDataView(
            didSelect: viewModels[indexPath.row],
            at: indexPath,
            from: tableView
        )
    }
    
    @available(iOSApplicationExtension 11.0, *)
    open func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return delegate?.postsDataView(leadingSwipeActionsForModel: viewModels[indexPath.row], at: indexPath, from: tableView)
    }
    
    @available(iOSApplicationExtension 11.0, *)
    open func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return delegate?.postsDataView(trailingSwipeActionsForModel: viewModels[indexPath.row], at: indexPath, from: tableView)
    }
}

extension PostsDataViewAdapter: UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.postsDataViewNumberOfSections(in: tableView) ?? 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        (cell as? PostsDataViewCell)?.bind(viewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionView delegates

extension PostsDataViewAdapter: UICollectionViewDelegate {
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) //Handle cell highlight
        
        delegate?.postsDataView(
            didSelect: viewModels[indexPath.row],
            at: indexPath,
            from: collectionView
        )
    }
}

extension PostsDataViewAdapter: UICollectionViewDataSource {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegate?.postsDataViewNumberOfSections(in: collectionView) ?? 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView[indexPath]
        (cell as? PostsDataViewCell)?.bind(viewModels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionView delegates

extension PostsDataViewAdapter {
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.postsDataViewWillBeginDragging(scrollView)
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.postsDataViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
