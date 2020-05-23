//
//  EmptyPlaceholderView.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2020-04-23.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

public class EmptyPlaceholderView: UIView {
    
    private lazy var image = UIImageView(imageNamed: .emptyPlaceholder).apply {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var label = ThemedHeadline().apply {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textAlignment = .center
        $0.numberOfLines = 3
    }
    
    public init(text: String) {
        super.init(frame: .zero)
        self.label.text = text
        self.prepare()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) { nil }
}

private extension EmptyPlaceholderView {
    
    func prepare() {
        // Configure controls
        backgroundColor = .clear
        
        // Compose layout
        let stackView = UIStackView(arrangedSubviews: [
            UIView().apply {
                $0.backgroundColor = .clear
                $0.addSubview(image)
            },
            label
        ]).apply {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        let contentView = UIView().apply {
            $0.addSubview(stackView)
        }
        
        addSubview(contentView)
        contentView.edges(to: self)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor).isActive = true
        stackView.center()
        
        if let superview = image.superview {
            image.translatesAutoresizingMaskIntoConstraints = false
            image.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            image.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
            image.widthAnchor.constraint(equalToConstant: 100).isActive = true
            image.aspectRatioSize()
        }
    }
}

#endif
