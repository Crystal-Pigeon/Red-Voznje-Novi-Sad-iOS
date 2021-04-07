//
//  StackWithTitleAndDescription.swift
//  BusNS
//
//  Created by Mariana Samardzic on 12.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class StackWithTitleAndDescription: Stack {
    
    let stack = ASStackLayoutSpec.vertical()
    let titleTextNode = ASTextNode()
    let descriptionTextNode = ASTextNode()
    
    let title: String
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    func setColor() {
        titleTextNode.attributedText = attributed(text: title.localized(), color: Theme.current.color(.supportTextColor), font: .muliSemiBold20)
        descriptionTextNode.attributedText = attributed(text: description.localized(),  color: Theme.current.color(.supportTextColor), font: .muliLight15, alignment: .left)
    }
    
    func getStack() -> ASStackLayoutSpec {
        self.setColor()
        stack.children = [titleTextNode, descriptionTextNode]
        stack.horizontalAlignment = .left
        stack.spacing = 10
        return stack
    }
}
