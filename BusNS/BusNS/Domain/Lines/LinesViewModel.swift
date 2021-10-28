//
//  LinesViewModel.swift
//  BusNS
//
//  Created by Marko Popić on 10/28/21.
//  Copyright © 2021 Crystal Pigeon. All rights reserved.
//

import Foundation

class LinesViewModel: NSObject {
    
    weak var viewController: LinesViewController?
    var urbanLines: [Line] { DatabaseManager.shared.urbanLines }
    var suburbanLines: [Line] { DatabaseManager.shared.suburbanLines }
}
