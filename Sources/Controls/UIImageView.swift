//
//  UIImageView.swift
//  SwiftyPress iOS
//
//  Created by Basem Emara on 2018-10-22.
//

import UIKit
import Kingfisher

public extension UIImageView {
    
    /// Set an image asynchrously with a URL and placeholder using caching.
    ///
    /// - Parameters:
    ///   - url: The URL of the image.
    ///   - placeholder: The placeholder image when retrieving the image at the URL.
    func setImage(
        from url: String?,
        placeholder: String? = "placeholder",
        referenceSize: CGSize? = nil,
        tintColor: UIColor? = nil,
        contentMode: ResizingContentMode? = nil)
    {
        let placeholder = placeholder != nil ? UIImage(named: placeholder!) : nil
        setImage(from: url, placeholder: placeholder, referenceSize: referenceSize, tintColor: tintColor, contentMode: contentMode)
    }
    
    /// Set an image asynchrously with a URL and placeholder using caching.
    ///
    /// - Parameters:
    ///   - url: The URL of the image.
    ///   - placeholder: The placeholder image when retrieving the image at the URL.
    func setImage(
        from url: String?,
        placeholder: UIImage?,
        referenceSize: CGSize? = nil,
        tintColor: UIColor? = nil,
        contentMode: ResizingContentMode? = nil)
    {
        guard let url = url, !url.isEmpty, let urlResource = URL(string: url) else {
            image = placeholder
            return
        }
        
        // Build options if applicable
        var options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
        var processor: ImageProcessor? = nil
        
        if let referenceSize = referenceSize {
            let resizeProcessor = ResizingImageProcessor(referenceSize: referenceSize, mode: {
                // Convert from Kingfisher enum to prevent leaking dependency through function signature
                guard let contentMode = contentMode else { return .none }
                switch contentMode {
                case .none: return .none
                case .aspectFit: return .aspectFit
                case .aspectFill: return .aspectFill
                }
            }())
            processor = processor?.append(another: resizeProcessor) ?? resizeProcessor
        }
        
        if let processor = processor {
            options.append(.processor(processor))
        }
        
        kf.setImage(with: urlResource, placeholder: placeholder, options: options) {
            guard case .success = $0 else { return }
            guard let tintColor = tintColor else { return }
            self.tintColor = tintColor
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    /// Specify how a size adjusts itself to fit a target size.
    ///
    /// - none: Not scale the content.
    /// - aspectFit: Scale the content to fit the size of the view by maintaining the aspect ratio.
    /// - aspectFill: Scale the content to fill the size of the view
    enum ResizingContentMode {
        case none
        case aspectFit
        case aspectFill
    }
}
