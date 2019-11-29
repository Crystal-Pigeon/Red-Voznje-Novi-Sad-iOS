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
    
    private var settingsViewModel = SettingsViewModel()
    
    init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.containerNode.automaticallyManagesSubnodes = true
        self.title = "Settings".localized()
        settingsViewModel.observer = self
        settingsViewModel.getLanguageAndTheme()
        appearance()
        layout()
    }
    
    override func viewDidLoad() {
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
        self.containerNode.backgroundColor = Theme.current.color(.settingsBackgroundColor)
        self.languageTextNode.attributedText = self.node.attributed(text: "Language".localized(), color: Theme.current.color(.settingsMainColor), font: Fonts.muliRegular15)
        self.themeTextNode.attributedText = self.node.attributed(text: "Theme".localized(), color: Theme.current.color(.settingsMainColor), font: Fonts.muliRegular15)
        self.supportTextNode.attributedText = self.node.attributed(text: "Support".localized(), color: Theme.current.color(.settingsMainColor), font: Fonts.muliRegular15)
        
        self.currentLanguageTextNode.attributedText = self.node.attributed(text: settingsViewModel.currentLanguage.localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular15)
        self.currentThemeNode.attributedText = self.node.attributed(text: settingsViewModel.currentTheme.localized(), color: Theme.current.color(.settingsExplenationColor), font: Fonts.muliRegular15)
        
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

extension SettingsViewController {
    @objc private func openSupportPage() {
        guard let navigationController = self.navigationController else { return }
        navigationController.pushViewController(SupportViewController(), animated: true)
    }
    @objc private func openLanguagePicker() {
        self.settingsViewModel.openLanguagePicker()
    }
    @objc private func openThemePicker() {
        self.settingsViewModel.openThemePicker()
    }
    @objc private func didClickDone() {
        if settingsViewModel.isLanguagesSelected {
            if (settingsViewModel.languageSelected == nil) {
                settingsViewModel.didSelectRow(row: 0)
            }
            settingsViewModel.changeLanguage()
        }
        else {
            if (settingsViewModel.themeSelected == nil) {
                settingsViewModel.didSelectRow(row: 0)
            }
            settingsViewModel.changeTheme()
        }
    }
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        settingsViewModel.isLanguagesSelected ? settingsViewModel.languages.count : settingsViewModel.themes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        settingsViewModel.isLanguagesSelected ? settingsViewModel.languages[row].localized() : settingsViewModel.themes[row].localized()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settingsViewModel.didSelectRow(row: row)
    }
}

extension SettingsViewController: SettingsObserver {
    func openPicker(title: String) {
        self.showPicker(with: title, delegate: self, dataSource: self)
    }
    func refreshLanguage(){
        self.title = "Settings".localized()
        self.appearance()
    }
    func refreshTheme(theme: String) {
        if theme == "Light" {
            Theme.current = LightTheme()
        } else {
            Theme.current = DarkTheme()
        }
        self.appearance()
        self.navigationController?.navigationBar.tintColor = Theme.current.color(.navigationTintColor)
        self.navigationController?.navigationBar.barTintColor = Theme.current.color(.navigationBackgroundColor)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Theme.current.color(.navigationTintColor),
            .font: Fonts.muliSemiBold20
        ]
    }
}

