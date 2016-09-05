//
//  SequenceGenerator.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/5/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation

class SequenceGenerator {
    
    static func createSequenceWithStartingPoint(startingPoint: Double, end: Double, numberOfSteps: Int) -> [Double] {
        let n = numberOfSteps
        let newArray = 0...n
        
        let step = (end - startingPoint) / Double(n)
        
        return newArray.map() {startingPoint + Double($0) * step}
    }

}
