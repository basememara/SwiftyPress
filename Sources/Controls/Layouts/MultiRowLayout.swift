//
//  MultiRowLayout.swift
//  Snap page and center collection view with multi-row cell
//  https://stackoverflow.com/a/32167976/235334
//
//  Created by Basem Emara on 2018-10-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

open class MultiRowLayout: UICollectionViewFlowLayout {
    private var rowsCount: CGFloat = 0
    
    public convenience init(rowsCount: CGFloat, spacing: CGFloat? = nil, inset: CGFloat? = nil) {
        self.init()
        
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 0
        self.rowsCount = rowsCount
        
        if let spacing = spacing {
            self.minimumLineSpacing = spacing
        }
        
        if let inset = inset {
            self.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
    }
    
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        self.itemSize = calculateItemSize(from: collectionView.bounds.size)
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView,
            !newBounds.size.equalTo(collectionView.bounds.size) else {
                return false
        }
        
        itemSize = calculateItemSize(from: collectionView.bounds.size)
        return true
    }
}

private extension MultiRowLayout {
    
    func calculateItemSize(from containerSize: CGSize) -> CGSize {
        return CGSize(
            width: containerSize.width - minimumLineSpacing * 2 - sectionInset.left,
            height: containerSize.height / rowsCount
        )
    }
}

extension MultiRowLayout: ScrollableFlowLayout {
    
    open func willBeginDragging() {
        
    }
    
    open func willEndDragging(withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = collectionView else { return }
        let bounds = collectionView.bounds
        let xTarget = targetContentOffset.pointee.x
        
        // This is the max contentOffset.x to allow. With this as contentOffset.x, the right edge
        // of the last column of cells is at the right edge of the collection view's frame.
        let xMax = collectionView.contentSize.width - collectionView.bounds.width
        
        // Velocity is measured in points per millisecond.
        let snapToMostVisibleColumnVelocityThreshold: CGFloat = 0.3
        
        if abs(velocity.x) <= snapToMostVisibleColumnVelocityThreshold {
            let xCenter = collectionView.bounds.midX
            let poses = layoutAttributesForElements(in: bounds) ?? []
            // Find the column whose center is closest to the collection view's visible rect's center.
            let x = poses.min { abs($0.center.x - xCenter) < abs($1.center.x - xCenter) }?.frame.origin.x ?? 0
            targetContentOffset.pointee.x = x - sectionInset.left
        } else if velocity.x > 0 {
            let poses = layoutAttributesForElements(in: CGRect(x: xTarget, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
            // Find the leftmost column beyond the current position.
            let xCurrent = collectionView.contentOffset.x
            let x = poses.filter { $0.frame.origin.x > xCurrent }.min { $0.center.x < $1.center.x }?.frame.origin.x ?? xMax
            targetContentOffset.pointee.x = min(x - sectionInset.left, xMax)
        } else {
            let poses = layoutAttributesForElements(in: CGRect(x: xTarget - bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
            // Find the rightmost column.
            let x = poses.max { $0.center.x < $1.center.x }?.frame.origin.x ?? 0
            targetContentOffset.pointee.x = max(x - sectionInset.left, 0)
        }
    }
}
