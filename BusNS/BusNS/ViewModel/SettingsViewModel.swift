//
//  SettingsViewModel.swift
//  BusNS
//
//  Created by Mariana Samardzic on 26/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
protocol SettingsObserver {
    func openPicker(title: String, selectedRow: Int)
    func refreshLanguage()
    func refreshTheme()
}

class SettingsViewModel {
    public var observer: SettingsObserver?
    
    public let languages = ["English", "Serbian"]
    public let themes = [ThemeMode.light.description, ThemeMode.dark.description]
    public private(set) var currentLanguage = ""
    public private(set) var currentTheme = ""
    public private(set) var isLanguagesOpened = true
    public private(set) var languageSelected: String?
    public private(set) var themeSelected: String?
    
    init(){}
    
    public func getLanguageAndTheme(){
        if !StorageManager.fileExists(StorageKeys.language, in: .caches) {
            currentLanguage = languages[0]
        } else {
            let languageShort = StorageManager.retrieve(StorageKeys.language, from: .caches, as: String.self)
            if languageShort == "en" {
                currentLanguage = "English"
            } else {
                currentLanguage = "Serbian"
            }
        }
        
        if !StorageManager.fileExists(StorageKeys.theme, in: .caches) {
            currentTheme = Theme.current.mode.description
        } else {
            currentTheme = StorageManager.retrieve(StorageKeys.theme, from: .caches, as: String.self)
        }
    }
    
    public func openLanguagePicker(){
        self.isLanguagesOpened = true
        self.languageSelected = currentLanguage
        guard let delegate = observer else { return }
        let selectedRow = self.languages.firstIndex(of: currentLanguage) ?? 0
        delegate.openPicker(title: "Choose language".localized(), selectedRow: selectedRow)
    }
    
    public func openThemePicker(){
        self.isLanguagesOpened = false
        self.themeSelected = currentTheme
        guard let delegate = observer else { return }
        let selectedRow = self.themes.firstIndex(of: currentTheme) ?? 0
        delegate.openPicker(title: "Choose theme".localized(), selectedRow: selectedRow)
    }
    
    public func didSelectRow(row: Int) {
        if isLanguagesOpened {
            languageSelected = languages[row]
        } else {
            themeSelected = themes[row]
        }
    }
    
    public func changeLanguage() {
        guard let language = languageSelected else { return }
        currentLanguage = language
        if currentLanguage == "English" {
            StorageManager.store("en", to: .caches, as: StorageKeys.language)
        } else {
            StorageManager.store("sr", to: .caches, as: StorageKeys.language)
        }
        guard let delegate = observer else { return }
        delegate.refreshLanguage()
    }
    
    public func changeTheme() {
        guard let theme = themeSelected else { return }
        currentTheme = theme
        
        if currentTheme == ThemeMode.light.description {
            StorageManager.store(ThemeMode.light.description, to: .caches, as: StorageKeys.theme)
            Theme.current = LightTheme()
        } else {
            StorageManager.store(ThemeMode.dark.description, to: .caches, as: StorageKeys.theme)
            Theme.current = DarkTheme()
        }
        guard let delegate = observer else { return }
        delegate.refreshTheme()
    }
}
