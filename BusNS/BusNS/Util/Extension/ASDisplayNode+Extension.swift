//
//  ASDisplayNode+Extension.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

extension ASDisplayNode {
    
    @objc func attributedText(with text: String, color: UIColor, uiFont: UIFont, alignment: NSTextAlignment = NSTextAlignment.center, isUnderlined: Bool = false) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        
        if isUnderlined == true {
            let attrs =  [NSAttributedString.Key.font: uiFont, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
            let title = NSAttributedString(string: text, attributes: attrs)
            return title
        } else {
             let attrs =  [NSAttributedString.Key.font: uiFont, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.paragraphStyle: style]
            let title = NSAttributedString(string: text, attributes: attrs)
            return title
        }
    }
}
