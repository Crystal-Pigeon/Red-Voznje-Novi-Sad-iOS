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
    private let homeScreenText = "When you open the app for the first time you will be presented with the home screen that doesn’t have any lines. If you want to add new lines to the home screen you need to click on the + button that will lead you to the add lines screen. In case you’ve opened the app before, the lines you’ve chosen the previous time you used it will be presented on the home screen for the current day of the week. The ability to change the schedule depending on the day of the week can be done by clicking on the desired day or by scrolling left-right. For every line displayed on the home screen it is shown the schedule for the previous, current and next hour, and in the absence of any of the three, the next three hours are added. By clicking on a collapsed card, it expands and shows the schedule for the whole day, while clicking again the card is collapsed to the nearest 3 hours. If. you desire to remove on of the lines, you can do so by long pressing the schedule to activate an option that offers you to delete the line from the home screen."
    private let addLinesScreenText = "When you open the add lines screen you will be shown urban lines. Switching between urban and suburban lines can be done by clicking on the tabs or by scrolling left-right. By clicking on one of the lines, it is being selected and added to the main screen, while clicking on already selected line it is being unselected and removed from the home screen."
    private let rearrangeScreenText = "This screen contains all the lines you've previously added to your home screen as your favorites, and on which you can rearrange them as you see fit."
    private let updateAppText = "The app is updated every time the driving season changes."
    private let languageText = "Clicking on language opens a dialog that allows you to select the language in which the content will be displayed."
    private let themeText = "Clicking on theme opens a dialog that allows you to choose whether the application will be displayed with a dark or light theme."
    
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
        let updateAppTitleStack = self.createHorizontalStack(number: "5.", title: "Application update")
        let languageTitleStack = self.createHorizontalStack(number: "3.1", title: "Language")
        let themeTitleStack = self.createHorizontalStack(number: "3.2", title: "Theme")

        let homeScreenStack = self.createStackWithDescription(title: homeScreenTitleStack, description: homeScreenText)
        let addLinesScreeneStack = self.createStackWithDescription(title: addLinesScreenTitleStack, description: addLinesScreenText)
        let rearrangeScreenStack = self.createStackWithDescription(title: rearrangeScreenTitleStack, description: rearrangeScreenText)
        let updateAppStack = self.createStackWithDescription(title: updateAppTitleStack, description: updateAppText)
        let languageStack = self.createStackWithDescription(title: languageTitleStack, description: languageText, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        let themeStack = self.createStackWithDescription(title: themeTitleStack, description: themeText, insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        

        let settingsStack = self.createStackWithDescription(title: settingsScreenTitleStack, description: "On the settings screen you can change:")
        let helpStack = self.createStackWithTitle(title: "Help", description: helpDescriptionStack)
        let contactStack = self.createStackWithTitle(title: "Contact", description: contactDescriptionStack)
        
        containerNode.layoutSpecBlock = { node, constrainedSize in
            self.scrollNode.layoutSpecBlock = { constrainedSize, size in
                settingsScreenStack.children = [
                    settingsStack,
                    ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: languageStack),
                    ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: themeStack)
                ]
                settingsScreenStack.spacing = 5
                
                helpDescriptionStack.children = [homeScreenStack, addLinesScreeneStack, settingsScreenStack,rearrangeScreenStack, updateAppStack]
                helpDescriptionStack.spacing = 20
                
                contactDescriptionStack.children = [self.emailImageNode, self.emailButtonNode]
                contactDescriptionStack.horizontalAlignment = .middle
                contactDescriptionStack.alignItems = .center
                contactDescriptionStack.spacing = 5

                helpStack.spacing = 20
                contactStack.spacing = 20

                supportStack.children = [helpStack, contactStack]
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
        self.emailImageNode.style.preferredSize = CGSize(width: 19, height: 14)
        self.emailImageNode.contentMode = .scaleAspectFit
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
