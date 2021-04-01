//
//  LineCellNode.swift
//  BusNS
//
//  Created by Mariana Samardzic on 1.4.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class LineCellNode: ASCellNode {
    
    private let line: String
    private let color: UIColor
    let textNode = ASTextNode()
    
    public init(line: String, color: UIColor) {
        self.line = line
        self.color = color
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        textNode.attributedText = self.attributed(text: line, color: color, font: Fonts.muliRegular15, alignment: .left)
        let stack = ASStackLayoutSpec.vertical()
        stack.child = self.textNode
        stack.verticalAlignment = .center
        stack.horizontalAlignment = .left
        let insents = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), child: stack)
        return insents
    }
}
