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
    
    // MARK: - Outlets
    
    @IBOutlet var lookupValueLabel: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var modeControl: UISegmentedControl!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the segmented control */
        modeControl.setTitle(ErsatzStatTableOptions.pVal.rawValue, forSegmentAtIndex: ErsatzStatTableOptions.allOptions.indexOf(ErsatzStatTableOptions.pVal)!)
        modeControl.setTitle(ErsatzStatTableOptions.zScore.rawValue, forSegmentAtIndex: ErsatzStatTableOptions.allOptions.indexOf(ErsatzStatTableOptions.zScore)!)
        modeControl.setTitle(ErsatzStatTableOptions.tScore.rawValue, forSegmentAtIndex: ErsatzStatTableOptions.allOptions.indexOf(ErsatzStatTableOptions.tScore)!)
        
        /* Configure the step size for the stepper control */
        stepper.stepValue = 0.01
        
        currentMode = ErsatzStatTableOptions.allOptions[modeControl.selectedSegmentIndex]
        updateInputControlsByMode(currentMode)
        
        
        
//        switch currentMode! {
//        case .pVal :
//            slider.minimumValue = 0.0
//            slider.maximumValue = 1.0
//        case .tScore, .zScore:
//            print("The current mode is pval")
//            slider.minimumValue = -6.0
//            slider.maximumValue = 6.0
//        }
//        
//        /* Configure the controls that will allow the user to input a value */
////        slider.minimumValue = -6.0
////        slider.maximumValue = 6.0
////        slider.value = 0.0
//        
//        stepper.minimumValue = Double(slider.minimumValue)
//        stepper.maximumValue = Double(slider.maximumValue)
//        stepper.value = Double(slider.value)
//        stepper.stepValue = 0.01
//        
//        lookupValueLabel.text = "\(slider.value)"
        
        
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
        lookupValueLabel.text = "\(sender.value)"
        stepper.value = Double(sender.value)
    }
    
    
    
    @IBAction func stepperTapped(sender: UIStepper) {
        slider.value = Float(sender.value)
        lookupValueLabel.text = "\(slider.value)"
    }
    
    
    @IBAction func modeChangedByTap(sender: UISegmentedControl) {
        print(sender)
        print(ErsatzStatTableOptions.allOptions[sender.selectedSegmentIndex])
        
        self.currentMode = ErsatzStatTableOptions.allOptions[sender.selectedSegmentIndex]
        updateInputControlsByMode(self.currentMode)
    }
    
    // MARK: - Helpers
    func updateInputControlsByMode(updatedMode: ErsatzStatTableOptions!) {
        
        switch updatedMode! {
        case .pVal :
            slider.minimumValue = 0.0
            slider.maximumValue = 1.0
            slider.value = 0.5
        case .tScore, .zScore:
            print("The current mode is pval")
            slider.minimumValue = -6.0
            slider.maximumValue = 6.0
            slider.value = 0.0
        }
        
        stepper.minimumValue = Double(slider.minimumValue)
        stepper.maximumValue = Double(slider.maximumValue)
        stepper.value = Double(slider.value)
        
        lookupValueLabel.text = "\(slider.value)"
        
    }
    
    
    
    
}

extension ErsatzStatTablesVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
