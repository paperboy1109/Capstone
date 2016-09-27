//
//  ThemeColors.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/26/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import UIKit

enum ThemeColors {
    
    case themeColor, lightGrey
    
    func color() -> UIColor {
        
        switch self {
        case .themeColor:
            return UIColor(red: 96.0/255.0, green: 237.0/255.0, blue: 179.0/255.0, alpha: 1.0)
            
        case .lightGrey:
            return UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
            
        }
    }
    
}
