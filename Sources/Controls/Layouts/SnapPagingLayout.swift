//
//  SnapPagingLayout.swift
//  Snap page and center collection view cell
//  https://medium.com/@shaibalassiano/tutorial-horizontal-uicollectionview-with-paging-9421b479ee94
//
//  Created by Basem Emara on 2018-10-03.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit

open class SnapPagingLayout: UICollectionViewFlowLayout {
    private var centerPosition = true
    private var peekWidth: CGFloat = 0
    private var indexOfCellBeforeDragging = 0
    
    public convenience init(centerPosition: Bool = true, peekWidth: CGFloat = 40, spacing: CGFloat? = nil, inset: CGFloat? = nil) {
        self.init()
        
        self.scrollDirection = .horizontal
        self.centerPosition = centerPosition
        self.peekWidth = peekWidth
        
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

private extension SnapPagingLayout {
    
    func calculateItemSize(from containerSize: CGSize) -> CGSize {
        return CGSize(
            width: containerSize.width - peekWidth * 2,
            height: containerSize.height
        )
    }
    
    func indexOfMajorCell() -> Int {
        guard let collectionView = collectionView else { return 0 }
        
        let proportionalOffset = collectionView.contentOffset.x
            / (itemSize.width + minimumLineSpacing)
        
        return Int(round(proportionalOffset))
    }
}

extension SnapPagingLayout: ScrollableFlowLayout {
    
    open func willBeginDragging() {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    open func willEndDragging(withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = collectionView else { return }
        
        // Stop scrollView sliding
        targetContentOffset.pointee = collectionView.contentOffset
        
        // Calculate where scrollView should snap to
        let indexOfMajorCell = self.indexOfMajorCell()
        
        guard let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0),
            dataSourceCount > 0 else {
                return
        }
        
        // Calculate conditions
        let swipeVelocityThreshold: CGFloat = 0.5 // After some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging
            && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        guard didUseSwipeToSkipCell else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            
            // Better way to scroll to a cell
            guard centerPosition else {
                guard let x = layoutAttributesForItem(at: indexPath)?.frame.origin.x else {
                    // Does not consider inset
                    return collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                }
                
                return collectionView.setContentOffset(
                    CGPoint(x: x - sectionInset.left, y: 0),
                    animated: true
                )
            }
            
            return collectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: true
            )
        }
        
        let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
        var toValue = CGFloat(snapToIndex) * (itemSize.width + minimumLineSpacing)
        
        if centerPosition {
            // Back up a bit to center
            toValue = (toValue - peekWidth + sectionInset.left)
        }
        
        // Damping equal 1 => no oscillations => decay animation
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: velocity.x,
            options: .allowUserInteraction,
            animations: {
                collectionView.contentOffset = CGPoint(x: toValue, y: 0)
                collectionView.layoutIfNeeded()
        },
            completion: nil
        )
    }
}
