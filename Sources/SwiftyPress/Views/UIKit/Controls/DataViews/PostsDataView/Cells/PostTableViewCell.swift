//
//  PostTableViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamUI

public final class PostTableViewCell: UITableViewCell {
    
    private let titleLabel = ThemedHeadline().apply {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 2
    }
    
    private let summaryLabel = ThemedSubhead().apply {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.numberOfLines = 2
    }
    
    private let dateLabel = ThemedCaption().apply {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.numberOfLines = 1
    }
    
    private let featuredImage = RoundedImageView(imageNamed: .placeholder)
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) { nil }
}

// MARK: - Setup

private extension PostTableViewCell {
    
    func prepare() {
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel.apply {
                    $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
                },
                summaryLabel,
                dateLabel.apply {
                    $0.setContentHuggingPriority(.defaultLow, for: .vertical)
                }
            ]).apply {
                $0.axis = .vertical
                $0.spacing = 10
            },
            UIView().apply {
                $0.addSubview(featuredImage)
            }
        ]).apply {
            $0.axis = .horizontal
            $0.spacing = 20
        }
        
        let view = ThemedView().apply {
            $0.addSubview(stackView)
        }
        
        addSubview(view)
        
        view.edges(to: self)
        stackView.edges(to: view, padding: 24, safeArea: true)
        
        featuredImage.aspectRatioSize()
        featuredImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        if let superview = featuredImage.superview {
            featuredImage.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            featuredImage.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            featuredImage.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        }
    }
}

// MARK: - Delegates

extension PostTableViewCell: PostsDataViewCell {
    
    public func load(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        dateLabel.text = model.date
        featuredImage.setImage(from: model.imageURL)
    }
}
