//
//  StatUtilitiesTableViewCell.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/4/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class StatUtilitiesTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconLabel: UILabel!    
    @IBOutlet var utilityDetailsText: UITextView!
    @IBOutlet var utilityDetailsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        
        titleLabel.font = UIFont(name: "PTSans-Regular", size: 21)
        titleLabel.textColor = UIColor.darkGrayColor()
        
        iconLabel.text = "\u{26AB}"
        
        utilityDetailsText.font = UIFont(name: "PTSans-Italic", size: 17)
        utilityDetailsText.textColor = UIColor.darkGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
