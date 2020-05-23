//
//  PostCollectionViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-20.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

public final class LatestPostCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = ThemedHeadline().apply {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 3
    }
    
    private let summaryLabel = ThemedSubhead().apply {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.numberOfLines = 0
    }
    
    private let featuredImage = UIImageView(imageNamed: .placeholder).apply {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) { nil }
}

// MARK: - Setup

private extension LatestPostCollectionViewCell {
    
    func prepare() {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel.apply {
                $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
            },
            summaryLabel
        ]).apply {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        let view = ThemedView().apply {
            $0.addSubview(featuredImage)
            $0.addSubview(stackView)
        }
        
        addSubview(view)
        view.edges(to: self)
        
        featuredImage.translatesAutoresizingMaskIntoConstraints = false
        featuredImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        featuredImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        featuredImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        featuredImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4, constant: 0).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: featuredImage.bottomAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8).isActive = true
    }
}

// MARK: - Delegates

extension LatestPostCollectionViewCell: PostsDataViewCell {
    
    public func load(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        featuredImage.setImage(from: model.imageURL)
    }
}
