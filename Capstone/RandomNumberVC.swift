//
//  RandomNumberVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/18/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class RandomNumberVC: UIViewController {
    
    // MARK: - Properties
    
    var currentMode: StatDistributions!
    
    // MARK: - Outlets
    
    @IBOutlet var distributionSelectionControl: UISegmentedControl!
    @IBOutlet var randomNumberLabel: UILabel!
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var leftTextField: UITextField!
    @IBOutlet var rightTextField: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the segmented control */
        distributionSelectionControl.setTitle(StatDistributions.normal.rawValue, forSegmentAtIndex: StatDistributions.allOptions.indexOf(StatDistributions.normal)!)
        distributionSelectionControl.setTitle(StatDistributions.uniform.rawValue, forSegmentAtIndex: StatDistributions.allOptions.indexOf(StatDistributions.uniform)!)
        distributionSelectionControl.setTitle(StatDistributions.integerVals.rawValue, forSegmentAtIndex: StatDistributions.allOptions.indexOf(StatDistributions.integerVals)!)
        
        /* Set the UI according to the current mode */
        currentMode = StatDistributions.allOptions[distributionSelectionControl.selectedSegmentIndex]
        updateInputControlsByMode(currentMode)
        
        /* Set custom fonts */
        leftLabel.font = UIFont(name: "PTSans-Regular", size: 17)
        leftLabel.textColor = UIColor.darkGrayColor()
        leftLabel.textAlignment = NSTextAlignment.Center
        
        rightLabel.font = UIFont(name: "PTSans-Regular", size: 17)
        rightLabel.textColor = UIColor.darkGrayColor()
        rightLabel.textAlignment = NSTextAlignment.Center
        
        randomNumberLabel.font = UIFont(name: "PTSans-Regular", size: 38)
        randomNumberLabel.textColor = UIColor.darkGrayColor()
        randomNumberLabel.textAlignment = NSTextAlignment.Center
    }
    
    
    // MARK: - Detect a shake gesture
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if event?.subtype == UIEventSubtype.MotionShake {
            
            print("Device was shaken")
            
            /* Check that values in the text field are valid */
            
            guard leftTextField.text != nil && rightTextField.text != nil else {
                return
            }
            
            switch self.currentMode! {
            case .normal :
                
                if let mu = Double(leftTextField.text!) {
                    if let sigma = Double(rightTextField.text!) {
                        
                        randomNumberLabel.text = String(StatisticsFunctions.swift_randomNormal(mu, sd: sigma))
                        
                    } else {
                        showAlert("Invalid value entered", alertDescription: "Is your standard deviation a valid number?")
                    }
                } else {
                    showAlert("Invalid value entered", alertDescription: "Is your mean a valid number?")
                }
                
                
            case .uniform :
                
                if let minValue = Double(leftTextField.text!) {
                    if let maxValue = Double(rightTextField.text!) {
                        
                        if maxValue <= minValue {
                            
                            showAlert("Error", alertDescription: "Quick fix: your maximum value must be greater than your minimum value.")
                            
                        } else {
                            
                            
                            randomNumberLabel.text = String(StatisticsFunctions.swift_randomUniform(minValue, max: maxValue))
                        }
                        
                    } else {
                        showAlert("Invalid value entered", alertDescription: "Is your maximum value a valid number?")
                    }
                } else {
                    showAlert("Invalid value entered", alertDescription: "Is your minimum value a valid number?")
                }
                
            case .integerVals :
                
                if let minValue = Double(leftTextField.text!) {
                    if let maxValue = Double(rightTextField.text!) {
                        
                        if maxValue <= minValue {
                            
                            showAlert("Error", alertDescription: "Quick fix: your maximum value must be greater than your minimum value.")
                            
                        } else {
                            
                            
                            randomNumberLabel.text = String(StatisticsFunctions.swift_randomInt(minValue, max: maxValue))
                        }
                        
                    } else {
                        showAlert("Invalid value entered", alertDescription: "Is your maximum value a valid number?")
                    }
                } else {
                    showAlert("Invalid value entered", alertDescription: "Is your minimum value a valid number?")
                }
            }
            
        }
    }
    
    // MARK: - Helpers
    func updateInputControlsByMode(updatedMode: StatDistributions!) {
        
        randomNumberLabel.text = "Shake Me ;)"
        
        switch updatedMode! {
        case .normal :
            leftLabel.text = "\nMean: "
            rightLabel.text = "Standard \nDeviation: "
            
        case .uniform :
            setMaxMinLabels()
            
        case .integerVals :
            setMaxMinLabels()
        }
        
    }
    
    func setMaxMinLabels() {
        leftLabel.text = "Minimum Value"
        rightLabel.text = "Maximum Value"
        
    }
    
    func showAlert(alertTitle: String, alertDescription: String) {
        
        let alertView = UIAlertController(title: "\(alertTitle)", message: "\(alertDescription)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func modeChangedByTap(sender: UISegmentedControl) {
        
        self.currentMode = StatDistributions.allOptions[sender.selectedSegmentIndex]
        updateInputControlsByMode(self.currentMode)
    }
    
}

// MARK: - Improve Keyboard behavior

extension RandomNumberVC {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}


extension RandomNumberVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}