//
//  HelpViewController.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit
import UIKit

class HelpViewController: ScrollViewController {
    
    private let copyrightsTextNode = ASTextNode()
    private let homeSection = HelpSectionNode(title: "Help".localized(), text: "Home screen text".localized() + "Add lines screen text".localized() + "Rearrange screen text".localized())
    private let availabilitySection = HelpSectionNode(title: "Availability".localized(), text: "Lines availability text".localized())
    private let updateSection = HelpSectionNode(title: "Update".localized(), text: "Update app text".localized())
    private let languageSection = HelpSectionNode(title: "Theme and language".localized(), text: "Theme text".localized())
    private let emailSection = EmailSectionNode(title: "Contact".localized(), text: "contact@crystalpigeon.com")
    private let changeLangNode = ASTextNode()
    private let button = ASButtonNode()
}

//MARK: - Setup
extension HelpViewController {
    override func setupData() {
        super.setupData()
        self.title = "Support".localized()
        self.copyrightsTextNode.attributedText = NSAttributedString("Copyrights ® Crystal Pigeon, 2019", color: .secondaryText, font: .muliRegular15, alignment: .center)
        self.copyrightsTextNode.style.flexShrink = 10
        self.copyrightsTextNode.style.flexGrow = 10
        self.button.addTarget(self, action: #selector(openSettigns), forControlEvents: .touchUpInside)
    }
    
    override func setupUI() {
        super.setupUI()
        self.changeLangNode.attributedText = NSAttributedString("Change language".localized(), color: .primaryText, font: .muliRegular15, alignment: .left)
        self.button.setAttributedTitle(NSAttributedString("Here".localized(), color: .primary, font: .muliRegular15, alignment: .left), for: .normal)
    }
    
    override func setupScrollLayout() {
        super.setupScrollLayout()
        self.scrollNode.layoutSpecBlock = { [weak self] node, constrainedSize in
            guard let self = self else { return ASLayoutSpec() }
            
            let langStack = ASStackLayoutSpec.horizontal()
            langStack.children = [self.changeLangNode, self.button]
            
            let stack = ASStackLayoutSpec.vertical()
            stack.spacing = 20
            stack.children = [self.homeSection, self.updateSection, self.languageSection, langStack, self.availabilitySection, self.emailSection, self.copyrightsTextNode]
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), child: stack)
        }
    }
    
    @objc private func openSettigns() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
}



