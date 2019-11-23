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
        for view in self.view.subviews {
            if view.tag == 47 { return }
        }
        let darkView = UIView(frame: self.view.bounds)
        darkView.tag = 47
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                
        let imageLayer = CAShapeLayer()
        imageLayer.backgroundColor = UIColor.clear.cgColor
        imageLayer.bounds = CGRect(x: UIScreen.main.bounds.midX - 42, y: UIScreen.main.bounds.midY - 40, width: 84, height: 80)
        imageLayer.position = CGPoint(x: UIScreen.main.bounds.midX ,y: UIScreen.main.bounds.midY)
        imageLayer.contents = UIImage(named: "logo-white")?.cgImage
        imageLayer.add(AnimationManager.shared.animatePulsatingLayer(), forKey: nil)
        
        self.view.addSubview(darkView)
        darkView.layer.addSublayer(imageLayer)
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
