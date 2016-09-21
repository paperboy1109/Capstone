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
    func addDataTableCell()
    
    /* Lifecycle methods */
    func cellDidBeginEditing(editingCell: DataTableViewCell)
    func cellDidEndEditing(editingCell: DataTableViewCell)
    
}


class DataTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var initialCellCenter = CGPoint()
    
    var deleteWhenPanGestureEnds = false
    var changeSignOfDatumValue = false
    
    var delegate: DataTableViewCellDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet var datumTextField: UITextField!
    
    @IBOutlet var plusMinusButton: UIButton!
    
    // MARK: - Observers
    
    /* If new text is entered */
    var datum: DataTableDatum? {
        /* Update table view cells when the datum is set (previous app use data has been loaded)*/
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
            print("Here is datum: \(datum)")
            
            let initialCellFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            
            if self.deleteWhenPanGestureEnds {
                // datumTextField.backgroundColor = UIColor.redColor()
                backgroundColor = UIColor.redColor()
                UIView.animateWithDuration(0.4, animations: {self.frame = initialCellFrame})
                
                if delegate != nil && datum != nil {
                    delegate!.deleteDataTableCell(datum!)
                }
            /* Add functionality to a swipe-to-the-right gesture */
            } else if self.changeSignOfDatumValue {
                UIView.animateWithDuration(0.4, animations: {self.frame = initialCellFrame})
            } else {
                UIView.animateWithDuration(0.2, animations: {self.frame = initialCellFrame})
            }
            
            
        }
        
    }
    
}

extension DataTableViewCell: UITextFieldDelegate {
    
    /* Improve keyboard behavior: close it when the user taps enter */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    /* Prevent edits to the text field here */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if let currentText = textField.text {
            if currentText.isEmpty {
                return true
            }
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        guard delegate != nil else {
            return
        }
        
        /* Invoke the lifecycle protocol: cellDidBeginEditing */
        delegate!.cellDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        guard datum != nil else {
            return
        }
        
        datum!.datumText = textField.text!
        
        guard delegate != nil else {
            return
        }
        
        delegate!.cellDidEndEditing(self)
    }
    
}


