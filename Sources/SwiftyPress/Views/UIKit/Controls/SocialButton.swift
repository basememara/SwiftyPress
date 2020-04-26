//
//  SocialButton.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2020-04-26.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit

/// A button that renders the social network icon.
public class SocialButton: UIButton {

    public convenience init(social: Social, target: Any?, action: Selector, size: CGFloat = 32) {
        self.init(type: .custom)
        
        self.setImage(UIImage(named: social.rawValue), for: .normal)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        guard let index = social.index() else { return }
        self.addTarget(target, action: action, for: .touchUpInside)
        self.tag = index
    }
}
#endif
