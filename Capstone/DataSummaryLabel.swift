//
//  DataSummaryLabel.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/21/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class DataSummaryLabel: UILabel {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        font = UIFont(name: "PTSans-Regular", size: 17)
        textColor = UIColor.darkGrayColor()
    }
    
}
