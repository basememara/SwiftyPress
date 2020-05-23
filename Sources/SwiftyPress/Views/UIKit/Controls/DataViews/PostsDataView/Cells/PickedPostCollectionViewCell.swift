//
//  PickedPostCollectionViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamCore

public final class PickedPostCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = ThemedHeadline().apply {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.numberOfLines = 2
    }
    
    private let summaryLabel = ThemedSubhead().apply {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.numberOfLines = 3
    }
    
    private let featuredImage = ThemedImageView(imageNamed: .placeholder).apply {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var favoriteButton = ThemedImageButton().apply {
        $0.setImage(UIImage(named: .favoriteEmpty), for: .normal)
        $0.setImage(UIImage(named: .favoriteFilled), for: .selected)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside) // Must be in lazy init
    }
    
    private var model: PostsDataViewModel?
    private weak var delegate: PostsDataViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) { nil }
}

// MARK: - Setup

private extension PickedPostCollectionViewCell {
    
    func prepare() {
        let favoriteView = UIView().apply {
            $0.backgroundColor = .clear
            $0.addSubview(favoriteButton)
        }
        
        let stackView = UIStackView(arrangedSubviews: [
            featuredImage,
            UIStackView(arrangedSubviews: [
                titleLabel.apply {
                    $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
                },
                summaryLabel,
                favoriteView
            ]).apply {
                $0.axis = .vertical
                $0.spacing = 5
            }
        ]).apply {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        let view = ThemedView().apply {
            $0.addSubview(stackView)
        }
        
        addSubview(view)
        
        view.edges(to: self)
        stackView.edges(to: view, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
        
        featuredImage.aspectRatioSize()
        
        favoriteView.heightAnchor.constraint(equalTo: favoriteButton.heightAnchor).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        favoriteButton.center()
    }
}

// MARK: - Interactions

private extension PickedPostCollectionViewCell {
    
    @objc func didTapFavoriteButton() {
        favoriteButton.isSelected.toggle()
        guard let model = model else { return }
        delegate?.postsDataView(toggleFavorite: model)
    }
}

// MARK: - Delegates

extension PickedPostCollectionViewCell: PostsDataViewCell {
    
    public func load(_ model: PostsDataViewModel) {
        self.model = model
        
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        featuredImage.setImage(from: model.imageURL)
        favoriteButton.isSelected =  model.favorite
    }
    
    public func load(_ model: PostsDataViewModel, delegate: PostsDataViewDelegate?) {
        self.delegate = delegate
        load(model)
    }
}
