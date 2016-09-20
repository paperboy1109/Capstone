//
//  ErsatzStatTablesVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/27/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class ErsatzStatTablesVC: UIViewController {
    
    // MARK: - Properties
    
    var currentMode: ErsatzStatTableOptions!
    let integrationStepCount = 500
    let dfPickerViewDataSource = 1...100
    var lookupValue: Double!
    var selectedDf: Int!
    let numberFormatter = NSNumberFormatter()
    
    // MARK: - Outlets
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var lookupValueTextField: UITextField!
    
    @IBOutlet var plusMinusButton: UIButton!
    
    @IBOutlet var answerValueLabel: UILabel!
    @IBOutlet var answerValueLabel_Secondary: UILabel!
    
    @IBOutlet var entryTypeLabel: UILabel!
    
    @IBOutlet var modeControl: UISegmentedControl!
    @IBOutlet var calculateButton: UIButton!
    
    @IBOutlet var calculateButton_Secondary: UIButton!
    
    @IBOutlet var dfPickerView: UIPickerView!
    @IBOutlet var dfLabel1: UILabel!
    @IBOutlet var dfLabel2: UILabel!
    
    @IBOutlet var assumptionLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the segmented control */
        modeControl.setTitle(ErsatzStatTableOptions.pVal.rawValue, forSegmentAtIndex: ErsatzStatTableOptions.allOptions.indexOf(ErsatzStatTableOptions.pVal)!)
        modeControl.setTitle(ErsatzStatTableOptions.zScore.rawValue, forSegmentAtIndex: ErsatzStatTableOptions.allOptions.indexOf(ErsatzStatTableOptions.zScore)!)
        modeControl.setTitle(ErsatzStatTableOptions.tScore.rawValue, forSegmentAtIndex: ErsatzStatTableOptions.allOptions.indexOf(ErsatzStatTableOptions.tScore)!)
        
        /* Set the UI according to the current mode */
        currentMode = ErsatzStatTableOptions.allOptions[modeControl.selectedSegmentIndex]
        updateInputControlsByMode(currentMode)
        
        /* Set up the pickerView */
        dfPickerView.dataSource = self;
        dfPickerView.delegate = self;
        selectedDf = 1
        
        answerValueLabel.text = ""
        
        /* Set custom fonts */
        titleLabel.font = UIFont(name: "PTSans-Italic", size: 21)
        titleLabel.textColor = UIColor.darkGrayColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        
        entryTypeLabel.font = UIFont(name: "PTSans-Regular", size: 17)
        entryTypeLabel.textColor = UIColor.darkGrayColor()
        entryTypeLabel.textAlignment = NSTextAlignment.Left
        
        dfLabel1.font = UIFont(name: "PTSans-Regular", size: 17)
        dfLabel1.textColor = UIColor.darkGrayColor()
        dfLabel1.textAlignment = NSTextAlignment.Left
        
        dfLabel2.font = UIFont(name: "PTSans-Italic", size: 17)
        dfLabel2.textColor = UIColor.darkGrayColor()
        dfLabel2.textAlignment = NSTextAlignment.Center
        
        assumptionLabel.font = UIFont(name: "PTSans-Regular", size: 14)
        assumptionLabel.textColor = UIColor.darkGrayColor()
        assumptionLabel.textAlignment = NSTextAlignment.Center
        
        answerValueLabel.font = UIFont(name: "PTSans-Bold", size: 17)
        answerValueLabel.textColor = UIColor.darkGrayColor()
        answerValueLabel.textAlignment = NSTextAlignment.Center
        
        answerValueLabel_Secondary.font = UIFont(name: "PTSans-Bold", size: 17)
        answerValueLabel_Secondary.textColor = UIColor.darkGrayColor()
        answerValueLabel_Secondary.textAlignment = NSTextAlignment.Center
        
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func plusMinusTapped(sender: AnyObject) {
        
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 10
        
        if let numberText = lookupValueTextField.text {
            if let currentNSNumber = numberFormatter.numberFromString(numberText) {
                var currentNumberFloat = Double(currentNSNumber)
                currentNumberFloat = (-1.0) * currentNumberFloat
                
                lookupValueTextField.text = numberFormatter.stringFromNumber(currentNumberFloat)
            }
            
        }
    }
    
    
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func modeChangedByTap(sender: UISegmentedControl) {
        
        self.currentMode = ErsatzStatTableOptions.allOptions[sender.selectedSegmentIndex]
        updateInputControlsByMode(self.currentMode)
    }
    
    @IBAction func calculateTapped(sender: UIButton) {
        
        print("The current mode is: ")
        print(self.currentMode.rawValue)
        
        var result: Double = 0.0
        
        if let newUserEntry = lookupValueTextField.text {
            
            if let unformattedNewValue = Double(newUserEntry) {
                lookupValue = unformattedNewValue
            }
        }
        
        
        /* Verify that the value entered by the user is valid */
        guard lookupValue != nil else {
            showErrorAlert("Oops!", alertDescription: "Did you forget to enter a number?")
            return
        }
        
        switch currentMode! {
        case .zScore :
            // answerValueLabel.text = "\(StatisticsFunctions.swift_qNorm(lookupValue))"
            result = StatisticsFunctions.swift_qNorm(lookupValue)
            answerValueLabel.text = roundDoubleToNDecimals(result, n: 3)
            
        case .tScore :
            //answerValueLabel.text = "\(StatisticsFunctions.swift_qt(lookupValue, df: selectedDf))"
            result = StatisticsFunctions.swift_qt(lookupValue, df: selectedDf)
            answerValueLabel.text = roundDoubleToNDecimals(result, n: 3)
            
        case .pVal :
            if sender.tag == 0 {
                // answerValueLabel.text = "\(StatisticsFunctions.swift_pnormFewestSteps(lookupValue, mean: 0.0, standardDev: 1.0, n: integrationStepCount))"
                result = StatisticsFunctions.swift_pnormFewestSteps(lookupValue, mean: 0.0, standardDev: 1.0, n: integrationStepCount)
                
                if lookupValue <= 0.0 {
                    answerValueLabel.text = "Area to the left: " + roundDoubleToNDecimals(result, n: 4)
                    answerValueLabel_Secondary.text = "Area to the right: " + roundDoubleToNDecimals(1.0 - result, n: 4)
                } else {
                    answerValueLabel.text = "Area to the left: " + roundDoubleToNDecimals(1.0 - result, n: 4)
                    answerValueLabel_Secondary.text = "Area to the right: " + roundDoubleToNDecimals(result, n: 4)
                }
                
            } else if sender.tag == 1 {
                // answerValueLabel.text = "\(StatisticsFunctions.swift_pt(lookupValue, df: selectedDf))"
                result = StatisticsFunctions.swift_pt(lookupValue, df: selectedDf)
                //answerValueLabel.text = roundDoubleToNDecimals(result, n: 4)
                
                
                answerValueLabel.text = "Area to the left: " + roundDoubleToNDecimals(result, n: 4)
                answerValueLabel_Secondary.text = "Area to the right: " + roundDoubleToNDecimals(1.0 - result, n: 4)
                
            }
        }
        
    }
    
    // MARK: - Helpers
    func updateInputControlsByMode(updatedMode: ErsatzStatTableOptions!) {
        
        answerValueLabel.text = ""
        answerValueLabel_Secondary.text = ""
        lookupValueTextField.text = ""
        lookupValue = 0.0
        
        switch updatedMode! {
        case .zScore :
            removeSecondaryButton()
            removeDfEntry()
            removePlusMinusButton()
            entryTypeLabel.text = "p-value: "
            answerValueLabel_Secondary.hidden = true
            assumptionLabel.hidden = false
            assumptionLabel.text = "* Your p-value is treated as the area to the left of z"
            
            calculateButton.setTitle("Calculate z-score", forState: .Normal)
            
        case .tScore :
            removeSecondaryButton()
            addDfEntry()
            dfLabel2.hidden = true
            removePlusMinusButton()
            entryTypeLabel.text = "p-value: "
            answerValueLabel_Secondary.hidden = true
            assumptionLabel.hidden = false
            assumptionLabel.text = "* Your p-value is treated as the area to the left of t"
            
            calculateButton.setTitle("Calculate t-score", forState: .Normal)
            
        case .pVal :
            addSecondaryButton()
            addDfEntry()
            addPlusMinusButton()
            answerValueLabel_Secondary.hidden = false
            entryTypeLabel.text = "z or t: "
            assumptionLabel.hidden = true
            
            calculateButton.setTitle("Calculate p-value for z", forState: .Normal)
            calculateButton_Secondary.setTitle("Calculate p-value for t", forState: .Normal)
        }
        
        
        
        //calculateButton.setTitle("Calculate \(updatedMode.rawValue)", forState: .Normal)
        
    }
    
    func showErrorAlert(alertTitle: String, alertDescription: String) {
        
        let alertView = UIAlertController(title: "\(alertTitle)", message: "\(alertDescription)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            
            self.lookupValueTextField.text = ""
            
        }) )
        
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func addSecondaryButton() {
        calculateButton_Secondary.hidden = false
        calculateButton_Secondary.enabled = true
    }
    
    func removeSecondaryButton() {
        calculateButton_Secondary.hidden = true
        calculateButton_Secondary.enabled = false
    }
    
    func addDfEntry() {
        dfPickerView.hidden = false
        dfLabel1.hidden = false
        dfLabel2.hidden = false
    }
    
    func removeDfEntry() {
        dfPickerView.hidden = true
        dfLabel1.hidden = true
        dfLabel2.hidden = true
    }
    
    func addPlusMinusButton() {
        plusMinusButton.hidden = false
        plusMinusButton.enabled = true
    }
    
    func removePlusMinusButton() {
        plusMinusButton.hidden = true
        plusMinusButton.enabled = false
    }
    
    
    func roundDoubleToNDecimals(fullNumber: Double, n: Int) -> String {
        numberFormatter.minimumFractionDigits = n
        numberFormatter.maximumFractionDigits = n
        
        if let roundedNumberAsString = numberFormatter.stringFromNumber(fullNumber) {
            return roundedNumberAsString
        } else {
            return ""
        }
        
    }
}

extension ErsatzStatTablesVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dfPickerViewDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(row + 1)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDf = row + 1
        /* Clear out the answer label if the value for df is changed */
        answerValueLabel.text = ""
    }
    
    
    
}

// MARK: - Improve Keyboard behavior

extension ErsatzStatTablesVC {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}

extension ErsatzStatTablesVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /* Disable landscape mode for this scene */
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}

