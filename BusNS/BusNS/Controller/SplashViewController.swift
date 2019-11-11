//
//  ViewController.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class SplashViewController: ASViewController<ASDisplayNode> {

    private let contentNode: ASDisplayNode
    
    init() {
        self.contentNode = ASDisplayNode()
        super.init(node: contentNode)
        self.contentNode.backgroundColor = Theme.current.color(.backgroundColor)
        self.contentNode.automaticallyManagesSubnodes = true
        self.title = "Bus NS"
//        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: Appearance
    private func layout() {
         contentNode.layoutSpecBlock = { node, constrainedSize in
            let imageNode = ASImageNode()
            imageNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMake(constrainedSize.max.width / 2), ASDimensionMake((constrainedSize.max.width) * (1/1)))
            imageNode.image = UIImage(named: "logo-white")
            imageNode.contentMode = .scaleAspectFit
            
            let stack = ASStackLayoutSpec.vertical()
            stack.child = imageNode
            stack.verticalAlignment = .center
            stack.horizontalAlignment = .middle
            
            return stack
        }
    }
}

