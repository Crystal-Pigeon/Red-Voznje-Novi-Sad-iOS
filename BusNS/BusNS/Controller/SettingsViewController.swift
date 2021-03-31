//
//  SettingsViewController.swift
//  BusNS
//
//  Created by Mariana Samardzic on 25/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//
import AsyncDisplayKit

class SettingsViewController: ASDKViewController<ASDisplayNode> {
    
    // MARK: - UI Properties
    private let containerNode: ASDisplayNode
    private var tableNode = ASTableNode()
    
    // MARK: - Properties
    private var settingsViewModel = SettingsViewModel()
    
    // MARK: - Init
    override init() {
        self.containerNode = ASDisplayNode()
        super.init(node: containerNode)
        self.title = "Settings".localized()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.containerNode.automaticallyManagesSubnodes = true
        self.settingsViewModel.observer = self
        self.settingsViewModel.getLanguageAndTheme()
        self.layout()
        self.colorAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(didClickDone), name: NSNotification.Name(rawValue: "didClickDone"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didClickDone"), object: nil)
    }
    
    override func updateColor() {
        self.colorAppearance()
        self.tableNode.reloadData()
    }
    
    // MARK: - Setup
    private func layout() {
        self.tableNode = initTableNode()
        self.containerNode.layoutSpecBlock = { node, constrainedSize in
            self.tableNode.style.preferredLayoutSize = ASLayoutSize(width: ASDimensionMake(constrainedSize.max.width), height: ASDimensionMake(constrainedSize.max.height))
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0), child: self.tableNode)
        }
    }
    
    private func initTableNode() -> ASTableNode {
        let tableNode = ASTableNode(style: .grouped)
        tableNode.backgroundColor = .clear
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.isScrollEnabled = false
        tableNode.view.separatorColor = UIColor.clear
        tableNode.allowsSelection = false
        return tableNode
    }
    
    private func colorAppearance() {
        self.containerNode.backgroundColor = Theme.current.color(.backgroundColor)
    }
}

// MARK: - Table View
extension SettingsViewController: ASTableDataSource, ASTableDelegate {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 3
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        if indexPath.section == 0 {
            let cell = SettingsCell(title: "Language", settingsDescription: "Change the language in the application", selectedValue: settingsViewModel.currentLanguage)
            cell.backgroundColor = .clear
            cell.buttonNode.addTarget(self, action: #selector(openLanguagePicker), forControlEvents: .touchUpInside)
            return cell
        } else if indexPath.section == 1 {
            let cell = SettingsCell(title: "Theme", settingsDescription: "Change the theme in the application", selectedValue: settingsViewModel.currentTheme)
            cell.backgroundColor = .clear
            cell.buttonNode.addTarget(self, action: #selector(openThemePicker), forControlEvents: .touchUpInside)
            return cell
        } else {
            let cell = SettingsCell(title: "Support", settingsDescription: "Open the support window", selectedValue: nil)
            cell.backgroundColor = .clear
            cell.buttonNode.addTarget(self, action: #selector(openSupportPage), forControlEvents: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 13
    }
}

//MARK: - Button Actions
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
}

// MARK: - Picker View
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        settingsViewModel.isLanguagesOpened ? settingsViewModel.languages.count : settingsViewModel.themes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        settingsViewModel.isLanguagesOpened ? settingsViewModel.languages[row].localized() : settingsViewModel.themes[row].localized()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settingsViewModel.didSelectRow(row: row)
    }
}

// MARK: - Settings Observer
extension SettingsViewController: SettingsObserver {
    func openPicker(title: String, selectedRow: Int = 0) {
        self.showPicker(with: title, delegate: self, dataSource: self, selectedRow: selectedRow)
    }
    
    func refreshLanguage(){
        self.title = "Settings".localized()
        self.updateColor()
    }
    
    func refreshTheme() {
        self.navigationController?.navigationBar.tintColor = Theme.current.color(.navigationTintColor)
        self.navigationController?.navigationBar.barTintColor = Theme.current.color(.navigationBackgroundColor)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Theme.current.color(.navigationTintColor),
            .font: Fonts.muliSemiBold20
        ]
        self.updateColor()
    }
    
    @objc private func didClickDone() {
        if settingsViewModel.isLanguagesOpened {
            if settingsViewModel.languageSelected == nil {
                settingsViewModel.didSelectRow(row: 0)
            }
            settingsViewModel.changeLanguage()
        }
        else {
            if settingsViewModel.themeSelected == nil {
                settingsViewModel.didSelectRow(row: 0)
            }
            settingsViewModel.changeTheme()
        }
    }
}
