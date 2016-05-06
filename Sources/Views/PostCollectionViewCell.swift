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
        contentView.layer.cornerRadius = 2
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clearColor().CGColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOffset = CGSizeZero
        layer.shadowRadius = 1
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
            cornerRadius:contentView.layer.cornerRadius).CGPath
    }
}
