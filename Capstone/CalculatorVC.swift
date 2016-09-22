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
    
    var enteredValue1 = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearDisplayText()
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func numberTapped(sender: CalculatorNumberButton) {
        
        enableMathOperations()
        
        guard displayLabel.text != nil else {return}
        
        let currentDisplayText = displayLabel.text!
        let currentDigit = sender.tag
        let currentDigitString = String(currentDigit)
        let concatenatedString = currentDisplayText + currentDigitString
        
        /* Simply update the active value */
        if calculatorData.operation == nil {
            
            if currentDisplayText == "0" || currentDisplayText == "" {
                displayLabel.text = currentDigitString
            } else {
                displayLabel.text = concatenatedString
            }
            
            updateActiveValue()
            
            /* Take the mathematical operation into account */
        } else {
            
            /* The display label is showing the saved value and should not be modified but rather replaced */
            if calculatorData.activeValue == nil {
                
                displayLabel.text = currentDigitString
                
                /* The display label is showing the active value and should be updated */
            } else {
                displayLabel.text = concatenatedString
            }
            
            updateActiveValue()
        }
        
    }
    
    @IBAction func operationButtonTapped(sender: UIButton) {
        
        if sender.tag == EditingOperations.clear.rawValue {
            
            clearDisplayText()
            calculatorData.resetValues()
            
        } else if sender.tag == EditingOperations.delete.rawValue {
            
            del()
            
        } else if sender.tag == MathOperations.equate.rawValue {
            
            if let currentStoredValue = calculatorData.activeValue {
                
                if let currentSecondStoredValue = calculatorData.savedValue {
                    
                    let result = currentStoredValue + currentSecondStoredValue
                    
                    displayLabel.text = String(result)
                    
                    calculatorData.updateValues(result, val2: nil)
                    
                } else {
                    displayLabel.text = String(currentStoredValue)
                }
                
                
            }
            
            print("After tapping =, calculator data is \(calculatorData)")
            
            
        } else {
            
            /* Ignore the button tap if no values have been entered */
            guard calculatorData.activeValue != nil else { return }
            
            /* Ignore the button tap if the screen is currently blank */
            guard displayLabel.text != "" else { return }
            
            disableMathOperations()
            
            calculatorData.setOperation(sender.tag)
            
            updateActiveValue()
            
            if calculatorData.hasSavedValue {
                
                calculatorData.combineValues()
                let newResult = calculatorData.getSavedValueAsString()
                displayLabel.text = newResult
                
            } else {
                
                saveDisplayedValue()
                self.displayLabel.text = ""
            }
            
        }
    }
    
    // MARK: - Helpers
    
    func clearDisplayText() {
        displayLabel.text = "0"
        currentCalculatorTask = CalculatorTasks.blank
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
    
    
    func disableMathOperations() {
        clearButton.enabled = false
        delButton.enabled = false
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
        delButton.enabled = true
        sqrtButton.enabled = true
        expButton.enabled = true
        divideButton.enabled = true
        multiplyButton.enabled = true
        subtractButton.enabled = true
        addButton.enabled = true
        equalsButton.enabled = true
    }
    
}


extension CalculatorVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}