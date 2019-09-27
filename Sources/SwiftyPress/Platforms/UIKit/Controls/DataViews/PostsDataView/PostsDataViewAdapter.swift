//
//  PostDataViewAdapter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import UIKit
import ZamzamCore
import ZamzamUI

open class PostsDataViewAdapter: NSObject {
    private let dataView: DataViewable
    private weak var delegate: PostsDataViewDelegate?
    public private(set) var viewModels: [PostsDataViewModel]?
    
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
        
        guard let model = viewModels?[indexPath.row] else { return }
        
        delegate?.postsDataView(
            didSelect: model,
            at: indexPath,
            from: tableView
        )
    }
    
    @available(iOS 11.0, *)
    open func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let model = viewModels?[indexPath.row] else { return nil }
        return delegate?.postsDataView(leadingSwipeActionsFor: model, at: indexPath, from: tableView)
    }
    
    @available(iOS 11.0, *)
    open func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let model = viewModels?[indexPath.row] else { return nil }
        return delegate?.postsDataView(trailingSwipeActionsFor: model, at: indexPath, from: tableView)
    }
    
    @available(iOS 13.0, *)
    open func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let model = viewModels?[indexPath.row] else { return nil }
        return delegate?.postsDataView(contextMenuConfigurationFor: model, at: indexPath, point: point, from: tableView)
    }
    
    @available(iOS 13.0, *)
    open func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion { [weak self] in
            guard let id = configuration.identifier as? Int,
                let model = self?.viewModels?.first(where: { $0.id == id }) else {
                    return
            }

            self?.delegate?.postsDataView(didPerformPreviewActionFor: model, from: tableView)
        }
    }
}

extension PostsDataViewAdapter: UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.postsDataViewNumberOfSections(in: tableView) ?? 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        guard let model = viewModels?[indexPath.row] else { return cell }
        (cell as? PostsDataViewCell)?.bind(model, delegate: delegate)
        return cell
    }
}

// MARK: - UICollectionView delegates

extension PostsDataViewAdapter: UICollectionViewDelegate {
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) //Handle cell highlight
        
        guard let model = viewModels?[indexPath.row] else { return }
        
        delegate?.postsDataView(
            didSelect: model,
            at: indexPath,
            from: collectionView
        )
    }
    
    @available(iOS 13.0, *)
    open func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let model = viewModels?[indexPath.row] else { return nil }
        return delegate?.postsDataView(contextMenuConfigurationFor: model, at: indexPath, point: point, from: collectionView)
    }
    
    @available(iOS 13.0, *)
    open func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion { [weak self] in
            guard let id = configuration.identifier as? Int,
                let model = self?.viewModels?.first(where: { $0.id == id }) else {
                    return
            }

            self?.delegate?.postsDataView(didPerformPreviewActionFor: model, from: collectionView)
        }
    }
}

extension PostsDataViewAdapter: UICollectionViewDataSource {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegate?.postsDataViewNumberOfSections(in: collectionView) ?? 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView[indexPath]
        guard let model = viewModels?[indexPath.row] else { return cell }
        (cell as? PostsDataViewCell)?.bind(model, delegate: delegate)
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
