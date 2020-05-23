//
//  SimplePostTableViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

public final class SimplePostTableViewCell: UITableViewCell {
    
    private let titleLabel = ThemedHeadline().apply {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 2
    }
    
    private let detailLabel = ThemedCaption().apply {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.numberOfLines = 1
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) { nil }
}

// MARK: - Setup

private extension SimplePostTableViewCell {
    
    func prepare() {
        accessoryType = .disclosureIndicator
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel.apply {
                $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
            },
            detailLabel
        ]).apply {
            $0.axis = .vertical
            $0.spacing = 6
        }
        
        let view = ThemedView().apply {
            $0.addSubview(stackView)
        }
        
        addSubview(view)
        view.edges(to: self)
        
        stackView.edges(
            to: view,
            insets: UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 36),
            safeArea: true
        )
    }
}

// MARK: - Delegates

extension SimplePostTableViewCell: PostsDataViewCell {
    
    public func load(_ model: PostsDataViewModel) {
        titleLabel.text = model.title
        detailLabel.text = model.date
    }
}
