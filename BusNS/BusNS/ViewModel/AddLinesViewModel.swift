//
//  AddLinesViewModel.swift
//  BusNS
//
//  Created by Marko Popić on 11/11/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation

protocol AddLinesObserver {
    func refreshUI()
    func showError(message: String)
}

class AddLinesViewModel {
    public var observer: AddLinesObserver?
    private var urbanLines = [Line]()
    private var suburbanLines = [Line]()
    public private(set) var isTypeUrban = true
    public private(set) var lines = [Line]()
    
    init() {}
    
    public func changeLineType(isTypeUrban: Bool) {
        self.isTypeUrban = isTypeUrban
        lines = self.isTypeUrban ? urbanLines : suburbanLines
        guard let delegate = self.observer else { return }
        delegate.refreshUI()
    }
    
    public func fetchLines() {
        if StorageManager.fileExists(StorageKeys.urbanLines, in: .caches) {
            self.urbanLines = StorageManager.retrieve(StorageKeys.urbanLines, from: .caches, as: [Line].self)
            self.suburbanLines = StorageManager.retrieve(StorageKeys.suburbanLines, from: .caches, as: [Line].self)
            self.lines = self.urbanLines
        } else {
            self.fetchUrbanLines()
            self.fetchSuburbanLines()
        }
    }
    
    private func fetchUrbanLines() {
        LineService.shared.getUrbanLines { (lines, error) in
            guard let delegate = self.observer else { return }
            if let error = error {
                delegate.showError(message: error.message)
                return
            }
            if let lines = lines {
                self.urbanLines = lines
                StorageManager.store(self.urbanLines, to: .caches, as: StorageKeys.urbanLines)
                
                self.lines = lines
                delegate.refreshUI()
            }
        }
    }
    
    private func fetchSuburbanLines() {
        LineService.shared.getSuburbanLines { (lines, error) in
            guard let delegate = self.observer else { return }
            if let error = error {
                delegate.showError(message: error.message)
                return
            }
            if let lines = lines {
                self.suburbanLines = lines
                StorageManager.store(self.suburbanLines, to: .caches, as: StorageKeys.suburbanLines)
                
                delegate.refreshUI()
            }
        }
    }
}
