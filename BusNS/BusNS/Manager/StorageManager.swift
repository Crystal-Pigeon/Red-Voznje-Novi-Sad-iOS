//
//  StorageManager.swift
//  BusNS
//
//  Created by Marko Popić on 11/7/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

public enum Directory {
    case documents
    case caches
}

public protocol StorageService {
     func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String)
     func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T
     func clear(_ directory: Directory)
     func remove(_ fileName: String, from directory: Directory)
     func fileExists(_ fileName: String, in directory: Directory) -> Bool
}

public class StorageManager: StorageService {
    
    public static let shared = StorageManager()
    
    private init() { }
    
     fileprivate func getURL(for directory: Directory) -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
    public  func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: String) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public  func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File at path \(url.path) does not exist!")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("No data at \(url.path)!")
        }
    }
    
    public  func clear(_ directory: Directory) {
        let url = getURL(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public  func remove(_ fileName: String, from directory: Directory) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public  func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    public  func cache(theme: String) {
        UserDefaults.standard.set(theme, forKey: StorageKeys.theme)
    }
    
    public  func cache(language: String) {
        UserDefaults.standard.set(language, forKey: StorageKeys.language)
    }
    
    public  var isThemeAlreadyCached: Bool {
        return UserDefaults.standard.value(forKey: StorageKeys.theme) != nil
    }
    
    public  var isLanguageAlreadyCached: Bool {
        return UserDefaults.standard.value(forKey: StorageKeys.language) != nil
    }
    
    public  func retrieveTheme() -> String {
        return UserDefaults.standard.value(forKey: StorageKeys.theme) as? String ?? ThemeMode.light.description
    }
    
    public  func retrieveLanguage() -> String {
        return UserDefaults.standard.value(forKey: StorageKeys.language) as? String ?? "en"
    }
}
