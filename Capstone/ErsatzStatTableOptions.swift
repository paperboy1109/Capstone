//
//  TableOptions.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/28/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import UIKit

enum ErsatzStatTableOptions: String {
    
    case pVal = "p-value"
    case zScore = "z-score"
    case tScore = "t-score"
    
    static let allOptions = [pVal, zScore, tScore]        
    
}
