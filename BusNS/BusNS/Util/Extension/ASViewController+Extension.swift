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
}
