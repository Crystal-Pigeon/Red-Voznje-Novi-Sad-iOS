//
//  ASViewController+Extension.swift
//  BusNS
//
//  Created by Marko Popić on 11/12/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

extension ASDKViewController {

    @objc func showAlert(title: String, message: String, duration: Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if #available(iOS 13.0, *), Theme.current.mode != .auto {
            alert.view.overrideUserInterfaceStyle = Theme.current.mode == .dark ? .dark : .light
        }
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func showInternetAlert(title: String, message: String, okHandler: @escaping (UIAlertAction)->(Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again".localized(), style: .destructive, handler: okHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showActivityIndicator() {
        
    }
    
    @objc func removeActivityIndicator() {
        
    }
    
    @objc func showPicker(with title: String, delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource, selectedRow: Int = 0) {
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        if deviceIdiom == .pad {
            let height: NSLayoutConstraint = NSLayoutConstraint(item: actionSheet.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280)
            actionSheet.view.addConstraint(height)
            let width: NSLayoutConstraint = NSLayoutConstraint(item: actionSheet.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 500)
            actionSheet.view.addConstraint(width)
            
            let picker = UIPickerView(frame: CGRect(x: 0, y: 50, width: 500, height: 200))
            picker.dataSource = dataSource
            picker.delegate = delegate
            picker.selectRow(selectedRow, inComponent: 0, animated: false)
            actionSheet.view.addSubview(picker)
            
            actionSheet.addAction(UIAlertAction(title: "Done".localized(), style: .default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "didClickDone"), object: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
            
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view //to set the source of your alert
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
            
        }
        else {
            let picker = UIPickerView(frame: CGRect(x: 0, y: 27, width: actionSheet.view.frame.width - 16, height: 145))
            picker.dataSource = dataSource
            picker.delegate = delegate
            picker.selectRow(selectedRow, inComponent: 0, animated: false)
            actionSheet.view.addSubview(picker)
            
            actionSheet.addAction(UIAlertAction(title: "Done".localized(), style: .default, handler: { action in
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "didClickDone"), object: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
            
            let height: NSLayoutConstraint = NSLayoutConstraint(item: actionSheet.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280)
            actionSheet.view.addConstraint(height)
        }
        
        if #available(iOS 13.0, *), Theme.current.mode != .auto {
            actionSheet.overrideUserInterfaceStyle = Theme.current.mode == .dark ? .dark : .light
        }
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - Auto Theme
extension ASDKViewController {    
    @objc func updateColor() {
        print("This method must be overridden")
    }
}
