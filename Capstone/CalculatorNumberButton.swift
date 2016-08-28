//
//  CalculatorNumberButton.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/27/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class CalculatorNumberButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
}
