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
    convenience init(badgeText: String, color: UIColor = .redColor(), fontSize: CGFloat = UIFont.smallSystemFontSize()) {
        self.init()
        text = " \(badgeText) "
        textColor = .whiteColor()
        backgroundColor = color

        font = .systemFontOfSize(fontSize)
        layer.cornerRadius = fontSize * CGFloat(0.6)
        clipsToBounds = true

        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .Height, multiplier: 1, constant: 0))
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
            let titleFont = attributedTitleForState(.Normal)?.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as? UIFont
            return titleFont?.pointSize ?? UIFont.buttonFontSize()
        }
        set {
            // TODO: use current attributedTitleForState(.Normal) if defined
            if UIFont.buttonFontSize() == newValue || 0 == newValue {
                setTitle(currentTitle, forState: .Normal)
            }
            else {
                let attrTitle = NSAttributedString(string: currentTitle ?? "", attributes:
                    [NSFontAttributeName: UIFont.systemFontOfSize(newValue), NSForegroundColorAttributeName: currentTitleColor]
                )
                setAttributedTitle(attrTitle, forState: .Normal)
            }

            if rounded {
                roundWithTitleSize(newValue)
            }
        }
    }

    func roundWithTitleSize(size: CGFloat) {
        let padding = size / 4
        layer.cornerRadius = padding + size * 1.2 / 2
        let sidePadding = padding * 1.5
        contentEdgeInsets = UIEdgeInsets(top: padding, left: sidePadding, bottom: padding, right: sidePadding)

        if size.isZero {
            backgroundColor = .clearColor()
            setTitleColor(tintColor, forState: .Normal)
        }
        else {
            backgroundColor = tintColor
            let currentTitleColor = titleColorForState(.Normal)
            if currentTitleColor == nil || currentTitleColor == tintColor {
                setTitleColor(.whiteColor(), forState: .Normal)
            }
        }
    }

    override public func tintColorDidChange() {
        super.tintColorDidChange()
        if rounded {
            backgroundColor = tintColor
        }
    }
}

extension UIBarButtonItem {
    convenience init(badge: String?, button: UIButton, target: AnyObject?, action: Selector) {
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        button.sizeToFit()
        
        let badgeLabel = UILabel(badgeText: badge ?? "")
        button.addSubview(badgeLabel)
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .Top, relatedBy: .Equal, toItem: button, attribute: .Top, multiplier: 1, constant: 0))
        button.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: button, attribute: .Trailing, multiplier: 1, constant: 0))
        if nil == badge {
            badgeLabel.hidden = true
        }
        badgeLabel.tag = UIBarButtonItem.badgeTag

        self.init(customView: button)
    }
    
    convenience init(badge: String?, image: UIImage, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        button.setBackgroundImage(image, forState: .Normal)

        self.init(badge: badge, button: button, target: target, action: action)
    }
    
    convenience init(badge: String?, title: String, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .System)
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = .systemFontOfSize(UIFont.buttonFontSize())

        self.init(badge: badge, button: button, target: target, action: action)
    }

    var badgeLabel: UILabel? {
        return customView?.viewWithTag(UIBarButtonItem.badgeTag) as? UILabel
    }

    var badgedButton: UIButton? {
        return customView as? UIButton
    }

    var badgeString: String? {
        get { return badgeLabel?.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()) }
        set {
            if let badgeLabel = badgeLabel {
                badgeLabel.text = nil == newValue ? nil : " \(newValue!) "
                badgeLabel.sizeToFit()
                badgeLabel.hidden = nil == newValue
            }
        }
    }

    var badgedTitle: String? {
        get { return badgedButton?.titleForState(.Normal) }
        set { badgedButton?.setTitle(newValue, forState: .Normal); badgedButton?.sizeToFit() }
    }

    private static let badgeTag = 7373
}