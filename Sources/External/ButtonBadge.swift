//
//  Badge.swift
//  Extensions for Rounded UILabel and UIButton, Badged UIBarButtonItem.
//  https://gist.github.com/yonat/75a0f432d791165b1fd6
//
//  Usage:
//      let label = UILabel(badgeText: "Rounded Label");
//      let button = UIButton(type: .System); button.rounded = true
//      let barButton = UIBarButtonItem(badge: "42", title: "How Many Roads", target: self, action: "answer")
//
//  Created by Yonat Sharon on 06.04.2015.
//  Copyright (c) 2015 Yonat Sharon. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(badgeText: String, color: UIColor = .red, fontSize: CGFloat = UIFont.smallSystemFontSize) {
        self.init()
        text = " \(badgeText) "
        textColor = .white
        backgroundColor = color

        font = .systemFont(ofSize: fontSize)
        layer.cornerRadius = fontSize * CGFloat(0.6)
        clipsToBounds = true

        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .height, multiplier: 1, constant: 0))
    }
}

extension UIButton {
    /// show background as rounded rect, like mail addressees
    var rounded: Bool {
        get { return layer.cornerRadius > 0 }
        set { roundWithTitleSize(newValue ? titleSize : 0) }
    }

    /// removes other title attributes
    var titleSize: CGFloat {
        get {
            let titleFont = attributedTitle(for: .normal)?.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: nil) as? UIFont
            return titleFont?.pointSize ?? UIFont.buttonFontSize
        }
        set {
            // TODO: use current attributedTitleForState(.Normal) if defined
            if UIFont.buttonFontSize == newValue || 0 == newValue {
                setTitle(currentTitle, for: .normal)
            }
            else {
                let attrTitle = NSAttributedString(string: currentTitle ?? "", attributes:
                    [NSAttributedStringKey.font: UIFont.systemFont(ofSize: newValue), NSAttributedStringKey.foregroundColor: currentTitleColor]
                )
                setAttributedTitle(attrTitle, for: .normal)
            }

            if rounded {
                roundWithTitleSize(newValue)
            }
        }
    }

    func roundWithTitleSize(_ size: CGFloat) {
        let padding = size / 4
        layer.cornerRadius = padding + size * 1.2 / 2
        let sidePadding = padding * 1.5
        contentEdgeInsets = UIEdgeInsets(top: padding, left: sidePadding, bottom: padding, right: sidePadding)

        if size.isZero {
            backgroundColor = .clear
            setTitleColor(tintColor, for: .normal)
        }
        else {
            backgroundColor = tintColor
            let currentTitleColor = titleColor(for: .normal)
            if currentTitleColor == nil || currentTitleColor == tintColor {
                setTitleColor(.white, for: .normal)
            }
        }
    }

    override open func tintColorDidChange() {
        super.tintColorDidChange()
        if rounded {
            backgroundColor = tintColor
        }
    }
}

extension UIBarButtonItem {
    convenience init(badge: String?, button: UIButton, target: AnyObject?, action: Selector, color: UIColor = .red) {
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        
        let badgeLabel = UILabel(badgeText: badge ?? "", color: color)
        button.addSubview(badgeLabel)
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .top, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .trailing, multiplier: 1, constant: 0))
        if nil == badge {
            badgeLabel.isHidden = true
        }
        badgeLabel.tag = UIBarButtonItem.badgeTag

        self.init(customView: button)
    }
    
    convenience init(badge: String?, image: UIImage, target: AnyObject?, action: Selector, color: UIColor = .red) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        button.setBackgroundImage(image, for: .normal)

        self.init(badge: badge, button: button, target: target, action: action, color: color)
    }
    
    convenience init(badge: String?, title: String, target: AnyObject?, action: Selector, color: UIColor = .red) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: UIFont.buttonFontSize)

        self.init(badge: badge, button: button, target: target, action: action, color: color)
    }

    var badgeLabel: UILabel? {
        return customView?.viewWithTag(UIBarButtonItem.badgeTag) as? UILabel
    }

    var badgedButton: UIButton? {
        return customView as? UIButton
    }

    var badgeString: String? {
        get { return badgeLabel?.text?.trimmingCharacters(in: .whitespaces) }
        set {
            if let badgeLabel = badgeLabel {
                badgeLabel.text = nil == newValue ? nil : " \(newValue!) "
                badgeLabel.sizeToFit()
                badgeLabel.isHidden = nil == newValue
            }
        }
    }

    var badgedTitle: String? {
        get { return badgedButton?.title(for: .normal) }
        set { badgedButton?.setTitle(newValue, for: .normal); badgedButton?.sizeToFit() }
    }

    fileprivate static let badgeTag = 7373
}
