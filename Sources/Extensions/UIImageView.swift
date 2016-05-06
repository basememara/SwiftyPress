//
//  UIImageView.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/1/16.
//
//

import UIKit
import Kingfisher

public extension UIImageView {

    /**
     Set an image with a URL and placeholder using caching.

     - parameter URL:         The URL of the image.
     - parameter placeholder: The palceholder image when retrieving the image at the URL.
     */
    public func setURL(URL: String, placeholder: String? = "placeholder") {
        self.kf_setImageWithURL(NSURL(string: URL)!,
            placeholderImage: placeholder != nil ? UIImage(named: placeholder!) : nil)
    }
    
}