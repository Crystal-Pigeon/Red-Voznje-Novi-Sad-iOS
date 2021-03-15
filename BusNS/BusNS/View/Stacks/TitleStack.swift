//
//  TitleStack.swift
//  BusNS
//
//  Created by Mariana Samardzic on 12.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class TitleStack: Stack {
    
    let stack = ASStackLayoutSpec.vertical()
    let titleTextNode = ASTextNode()
    
    let title: String
    let description: ASStackLayoutSpec
    
    init(title: String, description: ASStackLayoutSpec) {
        self.title = title
        self.description = description
    }
    
    func setColor() {
        self.titleTextNode.attributedText = attributed(text: title.localized(), color: Theme.current.color(.supportTextColor), font: Fonts.muliSemiBold20)
    }
    
    func getStack() -> ASStackLayoutSpec {
        self.setColor()
        stack.children = [titleTextNode, description]
        stack.horizontalAlignment = .left
        stack.spacing = 10
        return stack
    }
}
