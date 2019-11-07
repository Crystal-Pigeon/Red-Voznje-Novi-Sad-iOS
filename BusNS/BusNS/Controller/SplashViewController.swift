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
        self.contentNode.backgroundColor = Theme.current.color(.splashBackgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

