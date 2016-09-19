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
        iconLabel.text = "\u{26AB}"
        
        // TODO: Add a custom font
        // titleLabel.font =
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
