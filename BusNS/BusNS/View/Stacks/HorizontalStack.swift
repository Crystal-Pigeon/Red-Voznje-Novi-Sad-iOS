//
//  HorizontalStack.swift
//  BusNS
//
//  Created by Mariana Samardzic on 12.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class HorizontalStack: Stack {
    
    let stack = ASStackLayoutSpec.horizontal()
    let numberTextNode = ASTextNode()
    let titleTextNode = ASTextNode()
    
    let number: String
    let title: String
    
    init(number: String, title: String) {
        self.number = number
        self.title = title
    }
    
    public func setColor() {
        numberTextNode.attributedText = attributed(text: number, color: Theme.current.color(.supportTextColor), font: .muliLight15)
        titleTextNode.attributedText = attributed(text: title.localized(), color: Theme.current.color(.supportTextColor), font: .muliLight15)
    }
    
    public func getStack() -> ASStackLayoutSpec {
        self.setColor()
        stack.children = [numberTextNode, titleTextNode]
        stack.spacing = 3
        stack.horizontalAlignment = .left
        return stack
    }
}
