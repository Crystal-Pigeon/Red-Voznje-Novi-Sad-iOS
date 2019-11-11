//
//  ASViewController+Extension.swift
//  BusNS
//
//  Created by Marko Popić on 11/12/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import AsyncDisplayKit

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
        let darkView = UIView(frame: self.view.bounds)
        darkView.tag = 47
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.frame = CGRect(x: self.view.bounds.midX - 30, y: self.view.bounds.midY - 30, width: 60, height: 60)
        indicator.color = Colors.white
        self.view.addSubview(darkView)
        darkView.addSubview(indicator)
        indicator.startAnimating()
    }
    
    @objc func removeActivityIndicator() {
        for view in self.view.subviews {
            if view.tag == 47 {
                view.removeFromSuperview()
                return
            }
        }
    }
}
