//
//  Haptic.swift
//  BusNS
//
//  Created by Ena Vorkapic on 4/1/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import UIKit

class Haptic {
    public static let shared = Haptic()
    private init() { }
    private let impact = UIImpactFeedbackGenerator(style: .light)
    private let notification = UINotificationFeedbackGenerator()
    
    func pulse() {
        impact.impactOccurred()
    }
    
    func success() {
        notification.notificationOccurred(.success)
    }
}
