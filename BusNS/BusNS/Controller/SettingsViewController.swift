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
    private let themeTextNode = ASTextNode()
    private let supportTextNode = ASTextNode()
    
    private let currentThemeNode = ASTextNode()
    private let currentLanguageTextNode = ASTextNode()
    private let supportImage = ASImageNode()
    
    private let languageExplenation = ASTextNode()
    private let themeExplenation = ASTextNode()
    private let supportExplenation = ASTextNode()
    
    private let languageButton = ASButtonNode()
    private let themeButton = ASButtonNode()
    private let supportButton = ASButtonNode()
    
    private let languages = ["English".localized(), "Serbian".localized()]
    private let themes = ["Dark".localized(), "Light".localized()]
    private var currentLanguage = "English".localized()
    private var currentTheme = "Dark".localized()
    private var isLanguagesSelected = true
    private var isSelected = false
    
    init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.containerNode.backgroundColor = Theme.current.color(.settingsBackgroundColor)
        self.title = "Settings".localized()
        appearance()
        layout()
        NotificationCenter.default.addObserver(self, selector: #selector(didClickDone), name: NSNotification.Name(rawValue: "didClickDone"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: Layout
extension SettingsViewController {
    
    private func layout() {
        let languageOverlay = createOverlaySpec(textNode: languageTextNode, rightDisplayNode: currentLanguageTextNode, explenationNode: languageExplenation, button: languageButton)
        let themeOverlay = createOverlaySpec(textNode: themeTextNode, rightDisplayNode: currentThemeNode, explenationNode: themeExplenation, button: themeButton)
        let supportOverlay = createOverlaySpec(textNode: supportTextNode, rightDisplayNode: supportImage, explenationNode: supportExplenation, button: supportButton)
        
        containerNode.layoutSpecBlock = { node, constrainedSize in
            let mainStack = ASStackLayoutSpec.vertical()
            mainStack.children = [languageOverlay, themeOverlay, supportOverlay]
            mainStack.spacing = 13
            
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0), child: mainStack)
        }
    }
    
    private func appearance() {
        self.languageTextNode.attributedText = self.node.attributed(text: "Language".localized(), color: Theme.current.color(.settingsMainColor), font: Fonts.muliRegular15)
        self.themeTextNode.attributedText = self.node.attributed(text: "Theme".localized(), color: Theme.current.color(.settingsMainColor), font: Fonts.muliRegular15)
        self.supportTextNode.attributedText = self.node.attributed(text: "Support".localized(), color: Theme.current.color(.settingsMainColor), font: Fonts.muliRegular15)
        self.currentLanguageTextNode.attributedText = self.node.attributed(text: "English".localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular15)
        self.currentThemeNode.attributedText = self.node.attributed(text: "Dark".localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular15)
        self.languageExplenation.attributedText = self.node.attributed(text: "Change the language in the application".localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular10, alignment: .left)
        self.themeExplenation.attributedText = self.node.attributed(text: "Change the theme in the application".localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular10, alignment: .left)
        self.supportExplenation.attributedText = self.node.attributed(text: "Open the support window".localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular10, alignment: .left)
        
        self.languageButton.addTarget(self, action: #selector(openLanguagePicker), forControlEvents: .touchUpInside)
        self.themeButton.addTarget(self, action: #selector(openThemePicker), forControlEvents: .touchUpInside)
        self.supportButton.addTarget(self, action: #selector(openSupportPage), forControlEvents: .touchUpInside)
        
        
        self.supportImage.style.preferredSize = CGSize(width: 8, height: 14)
        self.supportImage.image = UIImage(named: "right_arrow_light")
        self.supportImage.contentMode = .scaleAspectFit
        
    }
    
    @objc private func openSupportPage() {
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(SupportViewController(), animated: true)
    }
    @objc private func openLanguagePicker() {
        self.isLanguagesSelected = true
        self.isSelected = false
        self.showPicker(with: "Choose language".localized(), delegate: self, dataSource: self)
    }
    @objc private func openThemePicker() {
        self.isLanguagesSelected = false
        self.isSelected = false
        self.showPicker(with: "Choose theme".localized(), delegate: self, dataSource: self)
    }
    @objc private func didClickDone() {
        if isLanguagesSelected {
            if isSelected {
                self.currentLanguageTextNode.attributedText = self.node.attributed(text: currentLanguage, color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular15)
            }
            else {
                self.currentLanguageTextNode.attributedText = self.node.attributed(text: languages[0], color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular15)
            }
        } else {
            if isSelected{
                self.currentThemeNode.attributedText = self.node.attributed(text: currentTheme, color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular15)
            } else {
                self.currentThemeNode.attributedText = self.node.attributed(text: themes[0], color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular15)
            }
        }
    }
    
    
    private func createOverlaySpec(textNode: ASTextNode, rightDisplayNode: ASDisplayNode, explenationNode: ASTextNode, button: ASButtonNode) -> ASOverlayLayoutSpec {
        let stack = ASStackLayoutSpec.horizontal()
        stack.children = [textNode, rightDisplayNode]
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
        return ASOverlayLayoutSpec(child: verticalStack, overlay: button)
    }
    
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isLanguagesSelected {
            return languages[row]
        } else {
            return themes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.isSelected = true
        if isLanguagesSelected {
            currentLanguage = languages[row]
        } else {
            currentTheme = themes[row]
        }
    }
}


