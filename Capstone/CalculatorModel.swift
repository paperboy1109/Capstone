//
//  CalculatorModel.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/21/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation

enum MathOperations: Int {
    
    // The raw values are set to match the button tags
    case sqrt = 12, exponentiation, division, multiplication, subtraction, addition, equate, none
}

enum EditingOperations: Int {
    // The raw values are set to match the button tags
    case clear = 10, delete
}

struct CalculatorMathVariablePair {
    
    var savedValue: Double?
    var activeValue: Double?
    var hasSavedValue = false
    var operation: MathOperations?    
    
    init() {
        self.savedValue = nil
        self.activeValue = nil
    }
    
    mutating func setActiveValue(value: Double) {
        self.activeValue = value
    }
    
    mutating func saveValue(value: Double) {
        self.savedValue = value
        self.activeValue = nil
        setDoesHaveSavedValue()
    }
    
    mutating func setDoesHaveSavedValue() {
        self.hasSavedValue = true
    }
    
    mutating func setOperation(rawValue: Int) {
        
        switch rawValue {
            
        case MathOperations.sqrt.rawValue:
            self.operation = MathOperations.sqrt
            
        case MathOperations.exponentiation.rawValue:
            self.operation = MathOperations.exponentiation
            
        case MathOperations.division.rawValue:
            self.operation = MathOperations.division
            
        case MathOperations.multiplication.rawValue:
            self.operation = MathOperations.multiplication
            
        case MathOperations.subtraction.rawValue:
            self.operation = MathOperations.subtraction
            
        case MathOperations.addition.rawValue:
            self.operation = MathOperations.addition
            
        default:
            self.operation = MathOperations.none
            
        }
        
    }
    
    mutating func resetValues() {
        self.hasSavedValue = false
        self.savedValue = nil
        self.activeValue = nil
    }
    
    mutating func combineValues() {
        
        guard self.activeValue != nil && self.savedValue != nil && self.operation != nil else { return }
        
        switch self.operation! {
            
        case MathOperations.exponentiation:
            self.savedValue = pow(self.savedValue!, self.activeValue!)
        case MathOperations.division:
            self.savedValue = self.savedValue! / self.activeValue!
        case MathOperations.multiplication:
            self.savedValue = self.savedValue! * self.activeValue!
        case MathOperations.subtraction:
            self.savedValue = self.savedValue! - self.activeValue!
        case MathOperations.addition:
            self.savedValue = self.savedValue! + self.activeValue!

        default:
            self.savedValue = 0.0
        }
        
        self.activeValue = nil        
        self.operation = nil
    }
    
    func getSavedValueAsString() -> String {
        guard self.savedValue != nil else { return "" }
        
        return String(self.savedValue!)
    }
    
    mutating func setOperation(currentOperation: MathOperations) {
        self.operation = currentOperation
    }            

    

}
