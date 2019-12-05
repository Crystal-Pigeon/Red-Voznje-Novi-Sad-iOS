//
//  SupportViewController.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/25/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

class SupportViewController: ASViewController<ASDisplayNode> {
    
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
    
    init() {
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
        
        let homeScreenTitleStack = self.createHorizontalStack(number: "1.", title: "Home screen")
        let addLinesScreenTitleStack = self.createHorizontalStack(number: "2.", title: "Add lines screen")
        let settingsScreenTitleStack = self.createHorizontalStack(number: "3.", title: "Settings screen")
        let rearrangeScreenTitleStack = self.createHorizontalStack(number: "4.", title: "Rearrange favorites screen")
        let languageTitleStack = self.createHorizontalStack(number: "3.1", title: "Language")
        let themeTitleStack = self.createHorizontalStack(number: "3.2", title: "Theme")

        let homeScreenStack = self.createStackWithDescription(title: homeScreenTitleStack, description: homeScreenText)
        let addLinesScreeneStack = self.createStackWithDescription(title: addLinesScreenTitleStack, description: addLinesScreenText)
        let rearrangeScreenStack = self.createStackWithDescription(title: rearrangeScreenTitleStack, description: rearrangeScreenText)
        let languageStack = self.createStackWithDescription(title: languageTitleStack, description: languageText, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        let themeStack = self.createStackWithDescription(title: themeTitleStack, description: themeText, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))

        let settingsStack = self.createStackWithDescription(title: settingsScreenTitleStack, description: "On the settings screen you can change:")
        let helpStack = self.createStackWithTitle(title: "Help", description: helpDescriptionStack)
        let contactStack = self.createStackWithTitle(title: "Contact", description: contactDescriptionStack)
        let updateAppStack = self.createStackWithTitleAndDescription(title: "Update", description: updateAppText)
        let linesAvailabilityStack = self.createStackWithTitleAndDescription(title: "Availability", description: linesAvailabilityText)
        
        containerNode.layoutSpecBlock = { node, constrainedSize in
            self.scrollNode.layoutSpecBlock = { constrainedSize, size in
                settingsScreenStack.children = [
                    settingsStack,
                    ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: languageStack),
                    ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: themeStack)
                ]
                settingsScreenStack.spacing = 5
                
                helpDescriptionStack.children = [homeScreenStack, addLinesScreeneStack, settingsScreenStack,rearrangeScreenStack]//, updateAppStack, linesAvailabilityStack]
                helpDescriptionStack.spacing = 20
                
                contactDescriptionStack.children = [self.emailImageNode, self.emailButtonNode]
                contactDescriptionStack.verticalAlignment = .bottom
                contactDescriptionStack.spacing = 4

                helpStack.spacing = 10
                contactStack.spacing = 10

                supportStack.children = [helpStack, updateAppStack, linesAvailabilityStack, contactStack]
                supportStack.spacing = 20
                
                mainStack.children = [supportStack, self.copyrightsTextNode]
                mainStack.spacing = 20
                mainStack.verticalAlignment = .center
                
                return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: mainStack)
            }
            return ASWrapperLayoutSpec(layoutElement: self.scrollNode)
        }
    }
    
    private func appearance() {
        self.containerNode.backgroundColor = Theme.current.color(.supportBackgroundColor)
        self.scrollNode.backgroundColor = Theme.current.color(.supportBackgroundColor)
        self.emailImageNode.image = UIImage(named: "email_icon")
        self.emailImageNode.style.preferredSize = CGSize(width: 21, height: 15)
        self.emailImageNode.alpha = 0.7
        self.emailImageNode.contentMode = .scaleAspectFill
        self.emailButtonNode.setAttributedTitle(self.node.attributed(text: "contact@crystalpigeon.com", color: Theme.current.color(.supportContactMailColor), font: Fonts.muliLight15), for: .normal)
        self.emailButtonNode.addTarget(self, action: #selector(self.sendEmail), forControlEvents: .touchUpInside)
        self.copyrightsTextNode.attributedText = self.node.attributed(text: "Copyrights ® Crystal Pigeon, 2019", color: Theme.current.color(.supportCopyrightsColor), font: Fonts.muliRegular13)
    }
    
    private func createStackWithTitle(title: String, description: ASStackLayoutSpec) -> ASStackLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        let titleTextNode = ASTextNode()
        titleTextNode.attributedText = self.node.attributed(text: title.localized(), color: Theme.current.color(.supportTextColor), font: Fonts.muliSemiBold20)
        stack.children = [titleTextNode, description]
        stack.horizontalAlignment = .left
        return stack
    }
    
    private func createStackWithTitleAndDescription(title: String, description: String) -> ASStackLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        let titleTextNode = ASTextNode()
        let descriptionTextNode = ASTextNode()
        titleTextNode.attributedText = self.node.attributed(text: title.localized(), color: Theme.current.color(.supportTextColor), font: Fonts.muliSemiBold20)
        descriptionTextNode.attributedText = self.node.attributed(text: description.localized(),  color: Theme.current.color(.supportTextColor), font: Fonts.muliLight15, alignment: .left)
        stack.children = [titleTextNode, descriptionTextNode]
        stack.horizontalAlignment = .left
        stack.spacing = 10
        return stack
    }
    
    private func createStackWithDescription(title: ASStackLayoutSpec, description: String, insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> ASStackLayoutSpec {
        let mainStack = ASStackLayoutSpec.vertical()
        let descriptionTextNode = ASTextNode()
        descriptionTextNode.attributedText = self.node.attributed(text: description.localized(), color: Theme.current.color(.supportTextColor), font: Fonts.muliLight15, alignment: .left)
        mainStack.children = [title, ASInsetLayoutSpec(insets: insets, child: descriptionTextNode)]
        mainStack.spacing = 5
        mainStack.horizontalAlignment = .left
        return mainStack
    }
    
    private func createHorizontalStack(number: String, title: String) -> ASStackLayoutSpec {
        let stack = ASStackLayoutSpec.horizontal()
        let numberTextNode = ASTextNode()
        let titleTextNode = ASTextNode()
        numberTextNode.attributedText = self.node.attributed(text: number, color: Theme.current.color(.supportTextColor), font: Fonts.muliLight15)
        titleTextNode.attributedText = self.node.attributed(text: title.localized(), color: Theme.current.color(.supportTextColor), font: Fonts.muliLight15)
        stack.children = [numberTextNode, titleTextNode]
        stack.spacing = 3
        stack.horizontalAlignment = .left
        return stack
    }
}
