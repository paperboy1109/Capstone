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
    var selectedDf: Int!
    
    // MARK: - Outlets
    
    @IBOutlet var lookupValueLabel: UILabel!
    @IBOutlet var answerValueLabel: UILabel!
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var modeControl: UISegmentedControl!
    @IBOutlet var calculateButton: UIButton!
    
    @IBOutlet var dfPickerView: UIPickerView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the segmented control */
        modeControl.setTitle(ErsatzStatTableOptions.pVal.rawValue, forSegmentAtIndex: ErsatzStatTableOptions.allOptions.indexOf(ErsatzStatTableOptions.pVal)!)
        modeControl.setTitle(ErsatzStatTableOptions.zScore.rawValue, forSegmentAtIndex: ErsatzStatTableOptions.allOptions.indexOf(ErsatzStatTableOptions.zScore)!)
        modeControl.setTitle(ErsatzStatTableOptions.tScore.rawValue, forSegmentAtIndex: ErsatzStatTableOptions.allOptions.indexOf(ErsatzStatTableOptions.tScore)!)
        
        /* Configure the step size for the stepper control */
        stepper.stepValue = 0.01
        
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
    
    
    @IBAction func sliderMoved(sender: UISlider) {
        answerValueLabel.text = ""
        lookupValueLabel.text = "\(sender.value)"
        stepper.value = Double(sender.value)
    }
    
    
    
    @IBAction func stepperTapped(sender: UIStepper) {
        answerValueLabel.text = ""
        slider.value = Float(sender.value)
        lookupValueLabel.text = "\(slider.value)"
    }
    
    
    @IBAction func modeChangedByTap(sender: UISegmentedControl) {
        
        self.currentMode = ErsatzStatTableOptions.allOptions[sender.selectedSegmentIndex]
        updateInputControlsByMode(self.currentMode)
    }
    
    @IBAction func calculateTapped(sender: AnyObject) {
        
        print("The current mode is: ")
        print(self.currentMode.rawValue)
        
        if self.currentMode == .zScore {
            answerValueLabel.text = "\(StatisticsFunctions.swift_pnormFewestSteps(Double(slider.value), mean: 0.0, standardDev: 1.0, n: integrationStepCount))"
        } else {
            // TODO: Calculate a p-value or t-score
            answerValueLabel.text = "\(slider.value)"
        }
        
        switch currentMode! {
        case .zScore :
            // answerValueLabel.text = "\(StatisticsFunctions.swift_pnormFewestSteps(Double(slider.value), mean: 0.0, standardDev: 1.0, n: 500))"
            answerValueLabel.text = "\(StatisticsFunctions.swift_qNorm(Double(slider.value)))"
        case .tScore :
            // answerValueLabel.text = "\(StatisticsFunctions.swift_pnormFewestSteps(Double(slider.value), mean: 0.0, standardDev: 1.0, n: 500))"
            answerValueLabel.text = "\(StatisticsFunctions.swift_qt(Double(slider.value), df: selectedDf))"
        case .pVal :
            answerValueLabel.text = "\(StatisticsFunctions.swift_pnormFewestSteps(Double(slider.value), mean: 0.0, standardDev: 1.0, n: integrationStepCount))"
        }
        
    }
    
    // MARK: - Helpers
    func updateInputControlsByMode(updatedMode: ErsatzStatTableOptions!) {
        
        answerValueLabel.text = ""
        
        switch updatedMode! {
        case .zScore :
            slider.minimumValue = 0.0
            slider.maximumValue = 1.0
            slider.value = 0.5
            calculateButton.setTitle("Calculate z-score", forState: .Normal)
            
        case .tScore :
            slider.minimumValue = 0.0
            slider.maximumValue = 1.0
            slider.value = 0.5
            calculateButton.setTitle("Calculate t-score", forState: .Normal)
            
        case .pVal :
            slider.minimumValue = -6.0
            slider.maximumValue = 6.0
            slider.value = 0.0
            calculateButton.setTitle("Calculate p-value", forState: .Normal)
        }
        
        stepper.minimumValue = Double(slider.minimumValue)
        stepper.maximumValue = Double(slider.maximumValue)
        stepper.value = Double(slider.value)
        
        lookupValueLabel.text = "\(slider.value)"
        // calculateButton.titleLabel = "\(updatedMode.rawValue)"
        //calculateButton.setTitle("Calculate \(updatedMode.rawValue)", forState: .Normal)
        
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

extension ErsatzStatTablesVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

