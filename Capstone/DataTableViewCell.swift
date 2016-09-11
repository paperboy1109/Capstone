//
//  DataTableViewCell.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/9/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

protocol DataTableViewCellDelegate {
    
    func deleteDataTableCell(itemToRemove: DataTableDatum)
    
}


class DataTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var initialCellCenter = CGPoint()
    
    var deleteWhenPanGestureEnds = false
    var changeSignOfDatumValue = false
    
    var delegate: DataTableViewCellDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet var datumTextField: UITextField!
    
    // MARK: - Observers
    
    /* If new text is entered */
    var datum: DataTableDatum? {
        /* Update table view cells when the datum is set (previous data has been loaded)*/
        didSet {
            datumTextField.text = datum!.datumText
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .None
        
        deleteWhenPanGestureEnds = false
        
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
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            
            let displacementByPan = panGestureRecognizer.translationInView(superview!)
            
            /* Ignore gestures that are mostly vertical so that the table cells still scroll well */
            if fabs(displacementByPan.x) > fabs(displacementByPan.y) {
                return true
            }
            return false
        }
        return false
    }
    
    func panGestureRecognized(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .Began {
            /* when the gesture begins, record the initial center location */
            initialCellCenter = center
            
            datumTextField.backgroundColor = UIColor.blueColor()
        }
        
        if recognizer.state == .Changed {
            
            print("State has changed")
            print(frame.size.width)
            print(frame.origin.x)
            
            let currentDisplacement = recognizer.translationInView(self)
            
            /* Re-locate the cell in the view */
            center = CGPointMake(initialCellCenter.x + currentDisplacement.x, initialCellCenter.y)
            
            /* If the pan gesture is far enough to the left or right, set the respective value to true */
            deleteWhenPanGestureEnds = frame.origin.x < -frame.size.width / 3.0
            changeSignOfDatumValue = frame.origin.x > frame.size.width / 3.0
            
            
        }
        
        if recognizer.state == .Ended {
            
            print("Here is deleteWhenPanGestureEnds: \(deleteWhenPanGestureEnds)")
            
            let initialCellFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            
            if self.deleteWhenPanGestureEnds {
                datumTextField.backgroundColor = UIColor.redColor()
                UIView.animateWithDuration(0.4, animations: {self.frame = initialCellFrame})
                
                // Create a protocol and delegate to remove the cell from the table view
                if delegate != nil && datum != nil {
                    delegate!.deleteDataTableCell(datum!)
                    datumTextField.backgroundColor = UIColor.orangeColor()
                }
                
            } else if self.changeSignOfDatumValue {
                datumTextField.backgroundColor = UIColor.greenColor()
                UIView.animateWithDuration(0.4, animations: {self.frame = initialCellFrame})
            } else {
                UIView.animateWithDuration(0.2, animations: {self.frame = initialCellFrame})
            }
            
            
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
