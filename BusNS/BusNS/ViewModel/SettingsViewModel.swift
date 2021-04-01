//
//  SettingsViewModel.swift
//  BusNS
//
//  Created by Mariana Samardzic on 26/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

protocol SettingsObserver {
    func openPicker(title: String, selectedRow: Int)
    func refreshLanguage()
    func refreshTheme()
}

class SettingsViewModel {
    public var observer: SettingsObserver?
    
    public let languages = ["English", "Serbian"]
    public let themes = [ThemeMode.light.description, ThemeMode.dark.description, ThemeMode.auto.description]
    public private(set) var currentLanguage = ""
    public private(set) var currentTheme = ""
    public private(set) var isLanguagesOpened = true
    public private(set) var languageSelected: String?
    public private(set) var themeSelected: String?
    
    init(){}
    
    public func getLanguageAndTheme(){
        if !StorageManager.isLanguageAlreadyCached {
            currentLanguage = languages[0]
        } else {
            let languageShort = StorageManager.retrieveLanguage()
            if languageShort == "en" {
                currentLanguage = "English"
            } else {
                currentLanguage = "Serbian"
            }
        }
        
        if !StorageManager.isThemeAlreadyCached {
            currentTheme = Theme.current.mode.description
        } else {
            currentTheme = StorageManager.retrieveTheme()
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
        Analytics.logEvent("change_language_event", parameters: ["lang": language])
        
        if currentLanguage == "English" {
            StorageManager.cache(language: "en")
        } else {
            StorageManager.cache(language: "sr")
        }
        guard let delegate = observer else { return }
        delegate.refreshLanguage()
    }
    
    public func changeTheme() {
        guard let theme = themeSelected else { return }
        currentTheme = theme
        Analytics.logEvent("change_theme_event", parameters: ["theme": theme])
        
        if currentTheme == ThemeMode.light.description {
            StorageManager.cache(theme: ThemeMode.light.description)
            Theme.current = LightTheme()
        } else if currentTheme == ThemeMode.dark.description{
            StorageManager.cache(theme: ThemeMode.dark.description)
            Theme.current = DarkTheme()
        } else {
            let theme = UIApplication.shared.keyWindow?.traitCollection.userInterfaceStyle
            Theme.current = theme == .dark ? DarkTheme() : LightTheme()
            StorageManager.cache(theme: ThemeMode.auto.description)
        }
        guard let delegate = observer else { return }
        delegate.refreshTheme()
    }
}
