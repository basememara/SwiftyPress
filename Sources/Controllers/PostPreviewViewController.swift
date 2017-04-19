//
//  PostPreviewViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2/11/17.
//
//

import UIKit
import ZamzamKit

class PostPreviewViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    weak var delegate: UIViewController?
    let service = PostService()
    
    var model: Post! {
        didSet {
            // Adjust preview size
            let width = UIScreen.main.bounds.width / 2.0
            var height = 200.0
        
            if let media = model.media, !media.link.isEmpty && media.width > 0 && media.height > 0 {
                height = Double((Float(media.height) * Float(width) / Float(media.width)) + 200.0)
            }
            
            preferredContentSize = CGSize(width: 0.0, height: height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = model.title.htmlDecoded
        contentLabel.text = model.previewContent
        featuredImageView.setURL(model.media?.link)
    }

    override var previewActionItems : [UIPreviewActionItem] {
        let isFavorite = service.isFavorite(model.id)
        let title = isFavorite ? "Unfavorite" : "Favorite"
        let style: UIPreviewActionStyle = isFavorite ? .destructive : .default
        
        return [
            UIPreviewAction(title: title.localized, style: style) { _ in
                self.service.toggleFavorite(self.model.id)
            },
            UIPreviewAction(title: "Share".localized, style: .default) { [weak self] _ in
                guard let model = self?.model, let link = URL(string: model.link),
                    let delegateView = self?.delegate?.view
                        else { return }
                
                self?.delegate?.present(
                    activities: [model.title.htmlDecoded, link],
                    sourceView: delegateView
                )
            }
        ]
    }
}
