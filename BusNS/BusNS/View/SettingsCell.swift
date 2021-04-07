//
//  SettingsCell.swift
//  BusNS
//
//  Created by Mariana Samardzic on 15.3.21..
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class SettingsCell: ASCellNode {
    
    // MARK: - Properties
    private let title: String
    private let settingsDescription: String
    private let selectedValue: String?
    
    // MARK: - UI Components
    private let backgroundNode = ASDisplayNode()
    private let textNode = ASTextNode()
    private let explenationNode = ASTextNode()
    private let rightDisplayNode = ASImageNode()
    private let rightTextNode = ASTextNode()
    public let buttonNode = ASButtonNode()
    
    // MARK: - Init
    init(title: String, settingsDescription: String, selectedValue: String?) {
        self.title = title
        self.settingsDescription = settingsDescription
        self.selectedValue = selectedValue
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.setupUI()
        return self.createOverlaySpec()
    }
    
    private func setupUI() {
        self.textNode.attributedText = attributed(text: self.title.localized(), color: Theme.current.color(.settingsMainColor), font: .muliRegular15)
        self.explenationNode.attributedText = attributed(text: self.settingsDescription.localized(), color: Theme.current.color(.settingsExplenationColor), font: .muliRegular12, alignment: .left)
        
        if selectedValue == nil {
            if Theme.current.mode == .dark {
                self.rightDisplayNode.image = .rightArrowDark
            } else {
                self.rightDisplayNode.image = .rightArrowLight
            }
            self.rightDisplayNode.style.preferredSize = CGSize(width: 8, height: 14)
            self.rightDisplayNode.contentMode = .scaleAspectFit
        } else {
            self.rightTextNode.attributedText = attributed(text: self.selectedValue!.localized(), color: Theme.current.color(.settingsExplenationColor), font: .muliRegular15)
        }
        self.backgroundNode.backgroundColor =  Theme.current.color(.settingsBackgroundColor)
    }
    
    private func createOverlaySpec() -> ASOverlayLayoutSpec {
        let stack = ASStackLayoutSpec.horizontal()
        if self.selectedValue == nil {
            stack.children = [textNode, rightDisplayNode]
        } else {
            stack.children = [textNode, rightTextNode]
        }
        stack.justifyContent = .spaceBetween
        stack.alignItems = .center
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 15, bottom: 9, right: 15), child: stack)
        
        let horizontalStack = ASBackgroundLayoutSpec(child: insets, background: backgroundNode)
        let verticalStack = ASStackLayoutSpec.vertical()
        let explenationInsets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: explenationNode)
        verticalStack.children = [horizontalStack, explenationInsets]
        verticalStack.spacing = 5
        return ASOverlayLayoutSpec(child: verticalStack, overlay: buttonNode)
    }
}
