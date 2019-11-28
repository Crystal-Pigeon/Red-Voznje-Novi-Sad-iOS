//
//  SettingsViewModel.swift
//  BusNS
//
//  Created by Mariana Samardzic on 26/11/2019.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
protocol SettingsObserver {
    func openPicker(title: String)
    func refreshLanguage()
    func refreshTheme(theme: String)
}

class SettingsViewModel {
    public var observer: SettingsObserver?
    
    public let languages = ["English", "Serbian"]
    public let themes = ["Dark", "Light"]
    public private(set) var currentLanguage = ""
    public private(set) var currentTheme = ""
    public private(set) var isLanguagesSelected = true
    public private(set) var languageSelected: String?
    public private(set) var themeSelected: String?
    
    init(){}
    
    public func getLanguageAndTheme(){
        let languageShort = StorageManager.retrieve(StorageKeys.language, from: .caches, as: String.self)
        if languageShort == "en" {
            currentLanguage = "English"
        } else {
            currentLanguage = "Serbian"
        }
        currentTheme = StorageManager.retrieve(StorageKeys.theme, from: .caches, as: String.self)
    }
    
    public func openLanguagePicker(){
        self.isLanguagesSelected = true
        self.languageSelected = nil
        guard let delegate = observer else { return }
        delegate.openPicker(title: "Choose language".localized())
    }
    public func openThemePicker(){
        self.isLanguagesSelected = false
        self.themeSelected = nil
        guard let delegate = observer else { return }
        delegate.openPicker(title: "Choose theme".localized())
    }
    public func didSelectRow(row: Int) {
        if isLanguagesSelected {
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
        if currentTheme == "Light" {
            StorageManager.store("Light", to: .caches, as: StorageKeys.theme)
        } else {
            StorageManager.store("Dark", to: .caches, as: StorageKeys.theme)
        }
        guard let delegate = observer else { return }
        delegate.refreshTheme(theme: currentTheme)
    }
}
