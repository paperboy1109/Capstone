//
//  DataTableViewCell.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/9/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet var datumCellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
