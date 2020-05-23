//
//  TagTableViewCell.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-09-26.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit

public final class TermTableViewCell: UITableViewCell {
    
    private let nameLabel = ThemedLabel().apply {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.numberOfLines = 1
    }
    
    private let countLabel = ThemedFootnote().apply {
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

private extension TermTableViewCell {
    
    func prepare() {
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            countLabel.apply {
                $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
        
        stackView.edges(
            to: view,
            insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
            safeArea: true
        )
    }
}

// MARK: - Delegates

extension TermTableViewCell: TermsDataViewCell {
    
    public func load(_ model: TermsDataViewModel) {
        nameLabel.text = model.name
        countLabel.text = "(\(model.count))"
    }
}
