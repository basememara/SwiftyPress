//
//  PostTableViewCell.swift
//  SwiftyPress
//
//  Created by Basem Emara on 3/29/16.
//
//

import UIKit

public class PostTableViewCell: UITableViewCell {

    @IBOutlet public weak var itemImage: UIImageView!
    @IBOutlet public weak var itemTitle: UILabel!
    @IBOutlet public weak var itemContent: UILabel!

    public func bind(model: Postable) -> Self {
        configure()
    
        itemImage.setURL(model.imageURL)
        itemTitle.text = model.title.decodeHTML()
        itemContent.text = model.excerpt.decodeHTML().stripHTML()
        return self
    }
    
    func configure() {
        // Optimize
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Style
        itemImage.layer.shadowColor = AppGlobal.userDefaults[.darkMode]
            ? UIColor.whiteColor().CGColor : UIColor.grayColor().CGColor
        itemImage.layer.shadowOffset = CGSizeZero
        itemImage.layer.shadowRadius = 1
        itemImage.layer.shadowOpacity = 1
        itemImage.layer.masksToBounds = false
        
        itemTitle.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
    }
}
