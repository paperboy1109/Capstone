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
    
    var initialCellCenter = CGPoint()
    
    // MARK: - Outlets
    
    @IBOutlet var datumTextField: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .None
        
        /* Configure the cell labels */
        datumTextField.delegate = self
        datumTextField.contentVerticalAlignment = .Center
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(DataTableViewCell.panGestureRecognized(_:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helpers
    
    func panGestureRecognized(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .Began {
            /* when the gesture begins, record the initial center location */
            initialCellCenter = center
            
            datumTextField.backgroundColor = UIColor.blueColor()
        }
        
        if recognizer.state == .Changed {
            datumTextField.backgroundColor = UIColor.redColor()
        }
        
        if recognizer.state == .Ended {
            datumTextField.backgroundColor = UIColor.clearColor()
        }
        
    }

}

extension DataTableViewCell: UITextFieldDelegate {
    
    /* Improve keyboard behavior */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
