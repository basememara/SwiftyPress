//
//  UIImageView.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-10-22.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import Nuke

public extension UIImageView {
    
    /// Returns an image view initialized with the specified image.
    ///
    /// - Parameters:
    ///   - named: The name of the image.
    ///   - bundle: The bundle containing the image file or asset catalog. Specify nil to search the app's main bundle.
    convenience init(imageNamed name: UIImage.ImageName, inBundle bundle: Bundle? = nil) {
        self.init(image: UIImage(named: name, inBundle: bundle))
    }
}

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
        contentMode: ResizingContentMode? = nil
    ) {
        let placeholder = placeholder != nil ? UIImage(named: placeholder ?? "") : nil
        setImage(from: url, placeholder: placeholder, referenceSize: referenceSize, contentMode: contentMode)
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
        contentMode: ResizingContentMode? = nil
    ) {
        guard let url = url, !url.isEmpty, let urlResource = URL(string: url) else {
            image = placeholder
            return
        }
        
        // Build options if applicable
        let options = ImageLoadingOptions(
            placeholder: placeholder,
            transition: .fadeIn(duration: 0.33),
            contentModes: {
                switch contentMode {
                case .aspectFit:
                    return .init(success: .scaleAspectFit, failure: .scaleAspectFit, placeholder: .scaleAspectFill)
                case .aspectFill:
                    return .init(success: .scaleAspectFill, failure: .scaleAspectFit, placeholder: .scaleAspectFill)
                default:
                    return nil
                }
            }()
        )
        
        var processors = [ImageProcessing]()
        
        if let referenceSize = referenceSize {
            processors.append(ImageProcessors.Resize(size: referenceSize))
        }
        
        let request = ImageRequest(
            url: urlResource,
            processors: processors
        )
        
        Nuke.loadImage(with: request, options: options, into: self)
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
#endif
