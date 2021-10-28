//
//  HelpSectionNode.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class HelpSectionNode: ASDisplayNode {
    
    let titleNode = ASTextNode()
    let textNode = ASTextNode()
    let title: String
    let text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        self.titleNode.attributedText = NSAttributedString(self.title, color: .primaryText, font: .muliSemiBold20)
        self.titleNode.style.flexGrow = 100
        self.titleNode.style.flexShrink = 100
        self.textNode.attributedText = NSAttributedString(self.text, color: .primaryText, font: .muliRegular15, alignment: .justified)
        self.textNode.style.flexGrow = 100
        self.textNode.style.flexShrink = 100
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.titleNode, self.textNode]
        stack.spacing = 12
        return stack
    }
}

class EmailSectionNode: ASDisplayNode {
    
    let titleNode = ASTextNode()
    let emailNode = ASButtonNode()
    let title: String
    let text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        self.titleNode.attributedText = NSAttributedString(self.title, color: .primaryText, font: .muliSemiBold20)
        self.titleNode.style.flexGrow = 100
        self.titleNode.style.flexShrink = 100
        self.emailNode.setAttributedTitle(NSAttributedString(self.text, color: .primary, font: .muliRegular15, alignment: .justified), for: .normal)
        self.emailNode.addTarget(self, action: #selector(sendEmail), forControlEvents: .touchUpInside)
        self.emailNode.contentHorizontalAlignment = .left
        self.emailNode.style.flexGrow = 100
        self.emailNode.style.flexShrink = 100
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [self.titleNode, self.emailNode]
        stack.spacing = 12
        return stack
    }
    
    @objc private func sendEmail() {
        let email = "contact@crystalpigeon.com"
        guard let url = URL(string: "mailto:\(email)") else {return}
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
