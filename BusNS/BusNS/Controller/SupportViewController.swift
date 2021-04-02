//
//  SupportViewController.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/25/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class SupportViewController: ASDKViewController<ASDisplayNode> {
    
    //MARK: UI Properties
    private let containerNode: ASDisplayNode
    private let scrollNode = ASScrollNode()
    private let emailImageNode = ASImageNode()
    private let emailButtonNode = ASButtonNode()
    private let copyrightsTextNode = ASTextNode()
    private let homeScreenText = "Home screen text"
    private let addLinesScreenText = "Add lines screen text"
    private let rearrangeScreenText = "Rearrange screen text"
    private let updateAppText = "Update app text"
    private let languageText = "Language text"
    private let themeText = "Theme text"
    private let linesAvailabilityText = "Lines availability text"
    
    var stacks:[Stack] = []
    
    override init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.title = "Support".localized()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.containerNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesContentSize = true
        self.layout()
        self.appearance()
        self.scrollNode.view.showsVerticalScrollIndicator = false
    }
    
    override func updateColor() {
        for stack in self.stacks {
            stack.setColor()
        }
        self.colorAppearance()
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

//MARK: Layout
extension SupportViewController {
    private func layout() {
        let helpDescriptionStack = ASStackLayoutSpec.vertical()
        let contactDescriptionStack = ASStackLayoutSpec.horizontal()
        let settingsScreenStack = ASStackLayoutSpec.vertical()
        let supportStack = ASStackLayoutSpec.vertical()
        let mainStack = ASStackLayoutSpec.vertical()
        
        // horizontal stacks
        let homeScreenTitleStack = HorizontalStack(number: "1.", title: "Home screen")
        let addLinesScreenTitleStack = HorizontalStack(number: "2.", title: "Add lines screen")
        let settingsScreenTitleStack = HorizontalStack(number: "3.", title: "Settings screen")
        let rearrangeScreenTitleStack = HorizontalStack(number: "4.", title: "Rearrange favorites screen")
        let languageTitleStack = HorizontalStack(number: "3.1", title: "Language")
        let themeTitleStack = HorizontalStack(number: "3.2", title: "Theme")
        self.stacks = [homeScreenTitleStack, addLinesScreenTitleStack, settingsScreenTitleStack, rearrangeScreenTitleStack, languageTitleStack, themeTitleStack]

        // descripiton stacks
        let homeScreenStack = DescriptionStack(title: homeScreenTitleStack.getStack(), description: homeScreenText)
        let addLinesScreeneStack = DescriptionStack(title: addLinesScreenTitleStack.getStack(), description: addLinesScreenText)
        let rearrangeScreenStack = DescriptionStack(title: rearrangeScreenTitleStack.getStack(), description: rearrangeScreenText)
        let languageStack = DescriptionStack(title: languageTitleStack.getStack(), description: languageText, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        let themeStack = DescriptionStack(title: themeTitleStack.getStack(), description: themeText, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        let settingsStack = DescriptionStack(title: settingsScreenTitleStack.getStack(), description: "On the settings screen you can change:")
        self.stacks.append(contentsOf: [homeScreenStack, addLinesScreeneStack, rearrangeScreenStack, languageStack, themeStack, settingsStack])
        
        // title stacks
        let helpStack = TitleStack(title: "Help", description: helpDescriptionStack)
        let contactStack = TitleStack(title: "Contact", description: contactDescriptionStack)
        self.stacks.append(contentsOf: [helpStack, contactStack])
        
        // title and description stacks
        let updateAppStack = StackWithTitleAndDescription(title: "Update", description: updateAppText)
        let linesAvailabilityStack = StackWithTitleAndDescription(title: "Availability", description: linesAvailabilityText)
        self.stacks.append(contentsOf: [updateAppStack, linesAvailabilityStack])
        
        containerNode.layoutSpecBlock = { node, constrainedSize in
            self.scrollNode.layoutSpecBlock = { constrainedSize, size in
                settingsScreenStack.children = [
                    settingsStack.getStack(),
                    ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: languageStack.getStack()),
                    ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: themeStack.getStack())
                ]
                settingsScreenStack.spacing = 5
                
                helpDescriptionStack.children = [homeScreenStack.getStack(), addLinesScreeneStack.getStack(), settingsScreenStack,rearrangeScreenStack.getStack()]//, updateAppStack, linesAvailabilityStack]
                helpDescriptionStack.spacing = 20
                
                contactDescriptionStack.children = [self.emailImageNode, self.emailButtonNode]
                contactDescriptionStack.verticalAlignment = .bottom
                contactDescriptionStack.spacing = 4

                supportStack.children = [helpStack.getStack(), updateAppStack.getStack(), linesAvailabilityStack.getStack(), contactStack.getStack()]
                supportStack.spacing = 20
                
                mainStack.children = [supportStack, self.copyrightsTextNode]
                mainStack.spacing = 20
                mainStack.verticalAlignment = .center
                
                return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: mainStack)
            }
            return ASWrapperLayoutSpec(layoutElement: self.scrollNode)
        }
    }
    
    private func colorAppearance() {
        self.containerNode.backgroundColor = Theme.current.color(.supportBackgroundColor)
        self.scrollNode.backgroundColor = Theme.current.color(.supportBackgroundColor)
        self.emailButtonNode.setAttributedTitle(self.node.attributed(text: "contact@crystalpigeon.com", color: Theme.current.color(.supportContactMailColor), font: .muliLight15), for: .normal)
        self.copyrightsTextNode.attributedText = self.node.attributed(text: "Copyrights ® Crystal Pigeon, 2019", color: Theme.current.color(.supportCopyrightsColor), font: .muliRegular13)
    }
    
    private func appearance() {
        self.colorAppearance()
        self.emailImageNode.image = .email
        self.emailImageNode.style.preferredSize = CGSize(width: 21, height: 15)
        self.emailImageNode.alpha = 0.7
        self.emailImageNode.contentMode = .scaleAspectFill
        self.emailButtonNode.addTarget(self, action: #selector(self.sendEmail), forControlEvents: .touchUpInside)
    }
}
