//
//  PostCollectionViewCell.swift
//  SwiftyPress
//
//  Created by Basem Emara on 3/30/16.
//
//

import UIKit

public class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet public weak var itemStackView: UIStackView!
    @IBOutlet public weak var itemImage: UIImageView!
    @IBOutlet public weak var itemTitle: UILabel!

    public func bind(model: Postable) -> Self {
        configure()
        
        itemImage.setURL(model.imageURL)
        itemTitle.text = model.title.decodeHTML()
        
        return self
    }
    
    func configure() {
        // Optimize
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Style
        if AppGlobal.userDefaults[.collectionCellCornerRadius] > 0 {
            contentView.layer.cornerRadius = CGFloat(AppGlobal.userDefaults[.collectionCellCornerRadius])
            contentView.layer.masksToBounds = true
            layer.backgroundColor = UIColor.clearColor().CGColor
        }

        if AppGlobal.userDefaults[.collectionCellShadowRadius] > 0 {
            layer.shadowColor = AppGlobal.userDefaults[.darkMode]
                ? UIColor.whiteColor().CGColor : UIColor.grayColor().CGColor
            layer.shadowOffset = CGSizeZero
            layer.shadowRadius = CGFloat(AppGlobal.userDefaults[.collectionCellShadowRadius])
            layer.shadowOpacity = 1
        }
        
        if !AppGlobal.userDefaults[.darkMode] {
            itemTitle.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
        }
    }
}
