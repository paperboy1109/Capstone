//
//  CalculatorVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/28/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController {
    
    // MARK: - Properties
    
    var currentCalculatorTask: CalculatorTasks!
    var calculatorData = CalculatorMathVariablePair()
    
    // MARK: - Outlets
    
    @IBOutlet var displayLabel: UILabel!
    
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var delButton: UIButton!
    @IBOutlet var sqrtButton: UIButton!
    @IBOutlet var expButton: UIButton!
    @IBOutlet var divideButton: UIButton!
    @IBOutlet var multiplyButton: UIButton!
    @IBOutlet var subtractButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var equalsButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDisplayText()
        clearDisplayText()
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func numberTapped(sender: CalculatorNumberButton) {
        
        print(sender.tag)
        
        enableMathOperations()
        
        guard displayLabel.text != nil else {return}
        
        let currentDisplayText = displayLabel.text!
        let currentDigit = sender.tag
        var currentDigitString = String(currentDigit)
        var concatenatedString = currentDisplayText + currentDigitString
        
        /* Accommodate the decimal place */
        if sender.tag == 99 {
            
            currentDigitString = "."
            concatenatedString = currentDisplayText + "."
        }
        
        
        /* No math operation has been tapped, simply update the active value */
        if calculatorData.operation == nil {
            
            if currentDisplayText == "0" || currentDisplayText == "" {
                
                displayLabel.text = currentDigitString
                updateActiveValue()
                
            } else if calculatorData.hasSavedValue {
                
                showBlockedFromEditing()
                
            } else {
                displayLabel.text = concatenatedString
                updateActiveValue()
            }
            
            //            if !calculatorData.hasSavedValue {
            //                updateActiveValue()
            //            }
            
            /* Take the mathematical operation into account */
        } else {
            
            /* The display label is showing the saved value and should not be modified but rather replaced */
            if calculatorData.activeValue == nil {
                
                displayLabel.text = currentDigitString
                
                /* The display label is showing the active value and should be updated */
            } else {
                displayLabel.text = concatenatedString
                delButton.enabled = true
            }
            
            updateActiveValue()
        }
        
    }
    
    @IBAction func operationButtonTapped(sender: UIButton) {
        
        if sender.tag == EditingOperations.clear.rawValue {
            
            clearDisplayText()
            calculatorData.resetValues()
            delButton.enabled = true
            
        } else if sender.tag == EditingOperations.delete.rawValue {
            
            del()
            
        } else if sender.tag == MathOperations.equate.rawValue {
            
            /* Ignore the button tap if no values have been entered */
            guard calculatorData.activeValue != nil else { return }
            
            /* Ignore the button tap if the screen is currently blank */
            guard displayLabel.text != "" else { return }
            
            /* Perform a calculation */
            if calculatorData.hasSavedValue && calculatorData.operation != nil {
                
                calculatorData.combineValues()
                
                let newResult = calculatorData.getSavedValueAsString()
                displayLabel.text = newResult
                
                highlightCalculationResult()
            }
            
            delButton.enabled = false
            
        } else if sender.tag == MathOperations.sqrt.rawValue {
            
            /* Ignore the button tap if there is a saved value or if there is no number on screen */
            guard let currentDisplayedValue = displayLabel.text else {
                setError()
                return
            }
            
            guard currentDisplayedValue != "" else {
                setError()
                return
            }
            
            /* If the result of a calculation is being displayed, display its square root */
            if calculatorData.hasSavedValue && calculatorData.activeValue == nil {
                
                guard var result = calculatorData.savedValue else {
                    setError()
                    return
                }
                
                guard result >= 0.0 else {
                    setError()
                    return
                }
                
                result = sqrt(result)
                displayLabel.text = String(result)
                saveDisplayedValue()
                
                calculatorData.operation = nil
                
                
                
                /* Alert the user that sqrt is not available if there is a saved value and an active value */
            } else if calculatorData.hasSavedValue && calculatorData.activeValue != nil {
                
                showBlockedFromEditing()
                
                /* There is no saved vaue, but there is an active value.  Show its square root */
            } else {
                
                guard var result = calculatorData.activeValue else {
                    setError()
                    return
                }
                
                guard result >= 0.0 else {
                    setError()
                    return
                }
                
                result = sqrt(result)
                displayLabel.text = String(result)
                saveDisplayedValue()
                
                calculatorData.operation = nil
                
            }
            
            /* Do some arithmetic */
        } else {
            
            /* Ignore the button tap if no values have been entered */
            guard calculatorData.activeValue != nil || calculatorData.hasSavedValue else { return }
            
            /* Ignore the button tap if the screen is currently blank */
            guard displayLabel.text != "" else { return }
            
            disableMathOperations()
            
            //calculatorData.setOperation(sender.tag)
            //updateActiveValue()
            
            if calculatorData.hasSavedValue {
                
                calculatorData.combineValues()
                let newResult = calculatorData.getSavedValueAsString()
                displayLabel.text = newResult
                
                calculatorData.setOperation(sender.tag)
                
            } else {
                
                saveDisplayedValue()
                self.displayLabel.text = ""
                
                calculatorData.setOperation(sender.tag)
            }
            
        }
    }
    
    
    @IBAction func plusMinusTapped(sender: AnyObject) {
        
        guard displayLabel.text != nil && displayLabel.text != "" else {
            setError()
            return
        }
        
        /* Allow an active value to be updated */
        if calculatorData.activeValue != nil {
            
            let newValue = (-1.0) * calculatorData.activeValue!
            updateDisplayedValue(newValue)
            updateActiveValue()
            
        }
        
        /* Allow the value of a calculation result to be updated */
        else if calculatorData.hasSavedValue {
            
            let newValue = (-1.0) * calculatorData.savedValue!
            updateDisplayedValue(newValue)
            saveDisplayedValue()        
        
        }
    }
    
    
    
    // MARK: - Helpers
    
    func clearDisplayText() {
        displayLabel.text = "0"
        currentCalculatorTask = CalculatorTasks.blank
    }
    
    func configureDisplayText() {
        displayLabel.font = UIFont(name: "PTSans-Regular", size: 32)
        displayLabel.textColor = UIColor.darkGrayColor()
    }
    
    func setError() {
        displayLabel.text = "Error"
        calculatorData.resetValues()
        currentCalculatorTask = CalculatorTasks.fatalError
    }
    
    func del() {
        
        guard let currentText = displayLabel.text else {
            return
        }
        
        guard currentText != "" else {
            return
        }
        
        if currentText.characters.count  > 1 {
            
            let updatedText = String(currentText.characters.dropLast())
            
            displayLabel.text = updatedText
            
            updateActiveValue()
            
        } else {
            
            clearDisplayText()
            
            updateActiveValue()
        }
        
        
    }
    
    func updateActiveValue() {
        
        guard let newStringValue = displayLabel.text else {
            setError()
            return
        }
        
        guard newStringValue.characters.count >= 1 else {
            setError()
            return
        }
        
        if let newDoubleValue = Double(newStringValue) {
            
            calculatorData.setActiveValue(newDoubleValue)
            
        } else {
            setError()
        }
        
    }
    
    func saveDisplayedValue() {
        
        guard let newStringValue = displayLabel.text else {
            setError()
            return
        }
        
        guard newStringValue.characters.count >= 1 else {
            setError()
            return
        }
        
        if let newDoubleValue = Double(newStringValue) {
            
            calculatorData.saveValue(newDoubleValue)
            
        } else {
            setError()
        }
    }
    
    func updateDisplayedValue(newValue: Double) {
        
        guard displayLabel.text != nil else {
            setError()
            return
        }
        
        displayLabel.text = String(newValue)
    
    }
    
    
    func disableMathOperations() {
        clearButton.enabled = false
        //delButton.enabled = false
        sqrtButton.enabled = false
        expButton.enabled = false
        divideButton.enabled = false
        multiplyButton.enabled = false
        subtractButton.enabled = false
        addButton.enabled = false
        equalsButton.enabled = false
    }
    
    func enableMathOperations() {
        clearButton.enabled = true
        // delButton.enabled = true
        sqrtButton.enabled = true
        expButton.enabled = true
        divideButton.enabled = true
        multiplyButton.enabled = true
        subtractButton.enabled = true
        addButton.enabled = true
        equalsButton.enabled = true
    }
    
    func showBlockedFromEditing() {
        
        /* Indicate to the user that the result can not be edited */
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseOut, animations:{
            
            self.displayLabel.alpha = 0.6
            self.displayLabel.textColor = UIColor.redColor()
            
            }, completion: { success in
                
                self.displayLabel.alpha = 1.0
                self.displayLabel.textColor = UIColor.darkGrayColor()
                
        })
        
    }
    
    func highlightCalculationResult() {
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseOut, animations:{
            
            self.displayLabel.alpha = 0.9
            self.displayLabel.textColor = UIColor(red: 96.0/255.0, green: 237.0/255.0, blue: 179.0/255.0, alpha: 1.0)
            
            }, completion: { success in
                
                self.displayLabel.alpha = 1.0
                self.displayLabel.textColor = UIColor.darkGrayColor()
                
        })
        
    }
    
}


extension CalculatorVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}