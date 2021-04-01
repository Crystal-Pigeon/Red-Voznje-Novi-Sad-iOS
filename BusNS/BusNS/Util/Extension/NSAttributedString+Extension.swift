//
//  NSAttributedString+Extension.swift
//  BusNS
//
//  Created by Mariana Samardzic on 1.4.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

            return ceil(boundingBox.height)
        }
}
