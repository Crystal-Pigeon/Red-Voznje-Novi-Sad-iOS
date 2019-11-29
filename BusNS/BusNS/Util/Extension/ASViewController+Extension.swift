//
//  ASViewController+Extension.swift
//  BusNS
//
//  Created by Marko Popić on 11/12/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

fileprivate var activityLoader = ActivityLoaderViewController()

extension ASViewController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func showAlert(title: String, message: String, duration: Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if #available(iOS 13.0, *), Theme.current.mode == .dark {
            alert.view.overrideUserInterfaceStyle = .dark
        }
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func showActivityIndicator() {
        if activityLoader.isOnScreen { return }
        activityLoader.modalPresentationStyle = .overFullScreen
        self.present(activityLoader, animated: false, completion: nil)
    }
    
    @objc func removeActivityIndicator() {
        activityLoader.stop()
    }
    
    @objc func showPicker(with title: String, delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource, selectedRow: Int = 0) {
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
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
        
        if #available(iOS 13.0, *) {
            if Theme.current.mode == .dark {
                actionSheet.view.overrideUserInterfaceStyle = .dark
            } else {
                actionSheet.view.overrideUserInterfaceStyle = .light
            }
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
}
