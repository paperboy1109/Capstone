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
    
    // MARK: - Outlets
    
    @IBOutlet var lookupValueTextField: UITextField!
    @IBOutlet var lookupValueLabel: UILabel!
    @IBOutlet var answerValueLabel: UILabel!
    @IBOutlet var entryTypeLabel: UILabel!
    
    
    @IBOutlet var modeControl: UISegmentedControl!
    @IBOutlet var calculateButton: UIButton!
    
    @IBOutlet var calculateButton_Secondary: UIButton!
    
    @IBOutlet var dfPickerView: UIPickerView!
    @IBOutlet var dfLabel1: UILabel!
    @IBOutlet var dfLabel2: UILabel!
    
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
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Actions
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
        
        if let newUserEntry = lookupValueTextField.text {
            
            if let unformattedNewValue = Double(newUserEntry) {
                lookupValue = unformattedNewValue
            }
        }

        
        /* Verify that the value entered by the user is valid */
        guard lookupValue != nil else {
            return
        }
        
        switch currentMode! {
        case .zScore :
            answerValueLabel.text = "\(StatisticsFunctions.swift_qNorm(lookupValue))"
        case .tScore :
            answerValueLabel.text = "\(StatisticsFunctions.swift_qt(lookupValue, df: selectedDf))"
        case .pVal :
            if sender.tag == 0 {
                answerValueLabel.text = "\(StatisticsFunctions.swift_pnormFewestSteps(lookupValue, mean: 0.0, standardDev: 1.0, n: integrationStepCount))"
            }
        }
        
    }
    
    // MARK: - Helpers
    func updateInputControlsByMode(updatedMode: ErsatzStatTableOptions!) {
        
        answerValueLabel.text = ""
        
        switch updatedMode! {
        case .zScore :
            removeSecondaryButton()
            removeDfEntry()
            
            entryTypeLabel.text = "p-value (left tail): "
            
            calculateButton.setTitle("Calculate z-score", forState: .Normal)
            
        case .tScore :
            removeSecondaryButton()
            addDfEntry()
            dfLabel2.hidden = true
            
            entryTypeLabel.text = "p-value (left tail): "
            
            calculateButton.setTitle("Calculate t-score", forState: .Normal)
            
        case .pVal :
            addSecondaryButton()
            addDfEntry()
            
            entryTypeLabel.text = "z or t: "
            
            calculateButton.setTitle("Calculate p-value for z", forState: .Normal)
            calculateButton_Secondary.setTitle("Calculate p-value for t", forState: .Normal)
        }
        
        
        
        //calculateButton.setTitle("Calculate \(updatedMode.rawValue)", forState: .Normal)
        
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
}

