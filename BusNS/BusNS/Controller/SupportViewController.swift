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
    
    init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesContentSize = true
        self.containerNode.backgroundColor = Theme.current.color(.supportBackgroundColor)
        self.scrollNode.backgroundColor = Theme.current.color(.supportBackgroundColor)
        self.title = "Support".localized()
        layout()
        appearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.scrollNode.view.showsVerticalScrollIndicator = false
    }
    
    @objc func sendEmail() {
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
        let homeScreenTitleStack = self.createHorizontalStack(number: "1.", title: "Home screen")
        let addLinesScreenTitleStack = self.createHorizontalStack(number: "2.", title: "Add lines screen")
        let settingsScreenTitleStack = self.createHorizontalStack(number: "3.", title: "Settings screen")
        let updateAppTitleStack = self.createHorizontalStack(number: "4.", title: "Application update")
        let languageTitleStack = self.createHorizontalStack(number: "3.1", title: "Language")
        let themeTitleStack = self.createHorizontalStack(number: "3.2", title: "Theme")

        let homeScreenStack = self.createStackWithDescription(title: homeScreenTitleStack, description: "When you open the app for the first time you will be presented with the home screen that doesn’t have any lines. If you want to add new lines to the home screen you need to click on the + button that will lead you to the add lines screen. In case you’ve opened the app before, the lines you’ve chosen the previous time you used it will be presented on the home screen for the current day of the week. The ability to change the schedule depending on the day of the week can be done by clicking on the desired day or by scrolling left-right. For every line displayed on the home screen it is shown the schedule for the previous, current and next hour, and in the absence of any of the three, the next three hours are added. By clicking on a collected card, it expands and shows the schedule for the whole day, while clicking again the card is collected to the nearest 3 hours. If. you desire to remove on of the lines, you can do so by long pressing the schedule to activate an option that offers you to delete the line from the home screen.")
        let addLinesScreeneStack = self.createStackWithDescription(title: addLinesScreenTitleStack, description: "When you open the add lines screen you will be shown urban lines. Switching between urban and suburban lines can be done by clicking on the tabs or by scrolling left-right. By clicking on one of the lines, it is being selected and added to the main screen, while clicking on already selected line it is being unselected and removed from the home screen.")
        let updateAppStack = self.createStackWithDescription(title: updateAppTitleStack, description: "The app is updated every time the driving season changes.")
        let languageStack = self.createStackWithDescription(title: languageTitleStack, description: "Clicking on a language opens a dialog that allows you to select the language in which the content will be displayed.", insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        let themeStack = self.createStackWithDescription(title: themeTitleStack, description: "Turning this option on and off allows you to choose whether the application will be displayed with a dark or light theme.", insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        
        containerNode.layoutSpecBlock = { node, constrainedSize in
            self.scrollNode.layoutSpecBlock = { constrainedSize, size in
                self.emailButtonNode.addTarget(self, action: #selector(self.sendEmail), forControlEvents: .touchUpInside)
            
                let settingsScreenStack = ASStackLayoutSpec.vertical()
                settingsScreenStack.children = [self.createStackWithDescription(title: settingsScreenTitleStack, description: "On the settings screen you can change:"), ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: languageStack), ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0), child: themeStack)]
                settingsScreenStack.spacing = 5

                let helpDescriptionStack = ASStackLayoutSpec.vertical()
                helpDescriptionStack.children = [homeScreenStack, addLinesScreeneStack, settingsScreenStack, updateAppStack]
                helpDescriptionStack.spacing = 20

                let contactDescriptionStack = ASStackLayoutSpec.horizontal()
                contactDescriptionStack.children = [self.emailImageNode, self.emailButtonNode]
                contactDescriptionStack.horizontalAlignment = .middle
                contactDescriptionStack.alignItems = .center
                contactDescriptionStack.spacing = 5

                let helpStack = self.createStackWithTitle(title: "Help", description: helpDescriptionStack)
                helpStack.spacing = 20
                
                let contactStack = self.createStackWithTitle(title: "Contact", description: contactDescriptionStack)
                contactStack.spacing = 20

                let supportStack = ASStackLayoutSpec.vertical()
                supportStack.children = [helpStack, contactStack]
                supportStack.spacing = 20
                
                let mainStack = ASStackLayoutSpec.vertical()
                mainStack.children = [supportStack, self.copyrightsTextNode]
                mainStack.spacing = 20
                mainStack.verticalAlignment = .center
                
                return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: mainStack)
            }
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: self.scrollNode)
        }
    }
    
    private func appearance() {
        self.emailImageNode.image = UIImage(named: "email_icon")
        self.emailImageNode.style.preferredSize = CGSize(width: 19, height: 14)
        self.emailImageNode.contentMode = .scaleAspectFit
        self.emailButtonNode.setAttributedTitle(self.node.attributed(text: "contact@crystalpigeon.com", color: Theme.current.color(.supportContactMailColor), font: Fonts.muliLight15), for: .normal)
        
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
