//
//  NSAttributedString+Extension.swift
//  BusNS
//
//  Created by Mariana Samardzic on 1.4.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import UIKit

extension NSAttributedString {
    convenience init(_ text: String, color: UIColor = .black, font: UIFont, alignment: NSTextAlignment = NSTextAlignment.left, isUnderlined: Bool = false) {
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
        
        self.init(string: text, attributes: attrs)
    }
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}


