//
//  ASDisplayNode+Extension.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

extension ASDisplayNode {
    
    @objc func attributed(text: String, color: UIColor, font: UIFont, alignment: NSTextAlignment = NSTextAlignment.center, isUnderlined: Bool = false) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        
        var attrs : [NSAttributedString.Key : Any] =  [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: style
        ]
        if isUnderlined {
            attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        return NSAttributedString(string: text, attributes: attrs)
    }
}

func attributed(text: String, color: UIColor, font: UIFont, alignment: NSTextAlignment = NSTextAlignment.center, isUnderlined: Bool = false) -> NSAttributedString {
    let style = NSMutableParagraphStyle()
    style.alignment = alignment
    
    var attrs : [NSAttributedString.Key : Any] =  [
        .font: font,
        .foregroundColor: color,
        .paragraphStyle: style
    ]
    if isUnderlined {
        attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue
    }
    return NSAttributedString(string: text, attributes: attrs)
}
