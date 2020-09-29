//
//  AnimationManager.swift
//  BusNS
//
//  Created by Ena Vorkapic on 11/23/19.
//  Copyright © 2019 Crystal Pigeon. All rights reserved.
//

import Foundation
import UIKit

class AnimationManager {
        
    static let shared = AnimationManager()
    
     func animatePulsatingLayer() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.2
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        return animation
    }
}
