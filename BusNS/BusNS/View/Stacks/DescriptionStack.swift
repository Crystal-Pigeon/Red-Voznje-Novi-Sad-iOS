//
//  DescriptionStack.swift
//  BusNS
//
//  Created by Mariana Samardzic on 12.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class DescriptionStack: Stack {
    
    let mainStack = ASStackLayoutSpec.vertical()
    let descriptionTextNode = ASTextNode()
    
    let title: ASStackLayoutSpec
    let description: String
    let insets: UIEdgeInsets
    
    init(title: ASStackLayoutSpec, description: String, insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.title = title
        self.description = description
        self.insets = insets
    }
    
    func setColor() {
        descriptionTextNode.attributedText = attributed(text: description.localized(), color: Theme.current.color(.supportTextColor), font: .muliLight15, alignment: .left)
    }
    
    func getStack() -> ASStackLayoutSpec {
        self.setColor()
        mainStack.children = [title, ASInsetLayoutSpec(insets: insets, child: descriptionTextNode)]
        mainStack.spacing = 5
        mainStack.horizontalAlignment = .left
        return mainStack
    }
}
