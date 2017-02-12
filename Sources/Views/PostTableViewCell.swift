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

    public func bind(_ model: Postable) -> Self {
        configure()
    
        itemTitle.text = model.title.htmlDecoded
        itemContent.text = model.previewContent
        itemImage.setURL(model.media?.link)
        
        return self
    }
    
    func configure() {
        // Optimize
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // Style
        itemImage.layer.shadowColor = AppGlobal.userDefaults[.darkMode]
            ? UIColor.white.cgColor : UIColor.gray.cgColor
        itemImage.layer.shadowOffset = .zero
        itemImage.layer.shadowRadius = 1
        itemImage.layer.shadowOpacity = 1
        itemImage.layer.masksToBounds = false
        
        itemTitle.textColor = UIColor(rgb: AppGlobal.userDefaults[.titleColor])
    }
}
