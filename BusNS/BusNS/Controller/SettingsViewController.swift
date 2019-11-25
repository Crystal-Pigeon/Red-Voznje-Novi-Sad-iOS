//
//  SettingsViewController.swift
//  BusNS
//
//  Created by Mariana Samardzic on 25/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//
import AsyncDisplayKit

class SettingsViewController: ASViewController<ASDisplayNode> {
    
    //MARK: UI Properties
    private let containerNode: ASDisplayNode
    
    private let languageTextNode = ASTextNode()
    private let languageButton = ASButtonNode()
    private let themeTextNode = ASTextNode()
    private let themeButton = ASButtonNode()
    private let supportTextNode = ASTextNode()
    private let supportImage = ASImageNode()
    private let languageExplenation = ASTextNode()
    private let themeExplenation = ASTextNode()
    private let supportExplenation = ASTextNode()
    private let supportButton = ASButtonNode()
    
    init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.containerNode.backgroundColor = Theme.current.color(.settingsBackgroundColor)
        self.title = "Settings".localized()
        appearance()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: Layout
extension SettingsViewController {
    
    private func layout() {
        let languageBackgroundSpec = self.createMainHorizontalStack(textNode: self.languageTextNode, button: self.languageButton,explenationNode:  self.languageExplenation)
        let themeBackgroundSpec = self.createMainHorizontalStack(textNode: self.themeTextNode, button: self.themeButton, explenationNode:  self.themeExplenation)
        
        let supportBackgroundSpec = self.createMainHorizontalStack(textNode: self.supportTextNode, button: self.supportImage, explenationNode: self.supportExplenation)
        let overlaySpec = ASOverlayLayoutSpec(child: supportBackgroundSpec, overlay: self.supportButton)
        
        containerNode.layoutSpecBlock = { node, constrainedSize in
            let mainStack = ASStackLayoutSpec.vertical()
            mainStack.children = [languageBackgroundSpec, themeBackgroundSpec, overlaySpec]
            mainStack.spacing = 13
            
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0), child: mainStack)
        }
    }
    
    private func appearance() {
        self.languageTextNode.attributedText = self.node.attributed(text: "Language".localized(), color: Theme.current.color(.settingsMainColor), font: Fonts.muliRegular15)
        self.languageButton.setAttributedTitle(NSAttributedString(string: "English".localized(), attributes: [NSAttributedString.Key.font: Fonts.muliRegular15, NSAttributedString.Key.foregroundColor: Theme.current.color(.settingsExplenationColor)]), for: .normal)
        
        self.themeTextNode.attributedText = self.node.attributed(text: "Theme".localized(), color: Theme.current.color(.settingsMainColor), font: Fonts.muliRegular15)
        self.themeButton.setAttributedTitle(NSAttributedString(string: "Dark Theme".localized(), attributes: [NSAttributedString.Key.font: Fonts.muliRegular15, NSAttributedString.Key.foregroundColor: Theme.current.color(.settingsExplenationColor)]), for: .normal)
        
        self.supportTextNode.attributedText = self.node.attributed(text: "Support".localized(), color: Theme.current.color(.settingsMainColor), font: Fonts.muliRegular15)
        self.supportImage.style.preferredSize = CGSize(width: 8, height: 14)
        self.supportImage.image = UIImage(named: "right_arrow_light")
        self.supportImage.contentMode = .scaleAspectFit
        self.supportButton.addTarget(self, action: #selector(openSupportPage), forControlEvents: .touchUpInside)
        
        self.languageExplenation.attributedText = self.node.attributed(text: "Change the language in the application".localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular10, alignment: .left)
        self.themeExplenation.attributedText = self.node.attributed(text: "Change the theme in the application".localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular10, alignment: .left)
        self.supportExplenation.attributedText = self.node.attributed(text: "Open the support window".localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular10, alignment: .left)
        
        
    }
    
    @objc private func openSupportPage() {
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(SupportViewController(), animated: true)
    }
    
    private func createMainHorizontalStack(textNode: ASTextNode, button: ASDisplayNode, explenationNode: ASTextNode) -> ASStackLayoutSpec {
        let stack = ASStackLayoutSpec.horizontal()
        stack.children = [textNode, button]
        stack.justifyContent = .spaceBetween
        stack.alignItems = .center
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 15, bottom: 9, right: 15), child: stack)
        let backgroundNode = ASDisplayNode()
        backgroundNode.backgroundColor = UIColor.white
        backgroundNode.borderColor = Theme.current.color(.settingsLineColor).cgColor
        backgroundNode.borderWidth = 1
        let horizontalStack = ASBackgroundLayoutSpec(child: insets, background: backgroundNode)
        let verticalStack = ASStackLayoutSpec.vertical()
        let explenationInsets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: explenationNode)
        verticalStack.children = [horizontalStack, explenationInsets]
        verticalStack.spacing = 5
        return verticalStack
    }
    
}

