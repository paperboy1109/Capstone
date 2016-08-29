//
//  StatisticsFunctions.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/29/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation

public class StatisticsFunctions {
    
    
    // MARK: - Helpers
    
    func swift_dorm(x: Double, mean: Double, standardDev: Double) -> Double {
        
        let variance = standardDev*standardDev
        let coef = ( 1/(sqrt(2.0 * M_PI * variance)) )
        let exponent = (-1) * ( pow(x - mean, 2) / (2 * variance) )
        
        return coef * pow(M_E, exponent)
    }
    
    
    func swift_standardizedScore(x: Double, mean: Double, standardDev: Double) -> Double {
        
        return (x - mean) / standardDev
    }
    
    func simpsonCoefsArray(k: Int) -> [Double] {
        
        var coefArray: [Double] = [1.0]
        
        // k will always be odd and should never be less than 3
        guard ((k-1)%2 == 0) && (k >= 3) else {
            return [1, 4, 1]
        }
        
        while coefArray.count < (k - 1) {
            if coefArray.last == 1.0 || coefArray.last == 2.0 {
                coefArray.append(4.0)
            } else {
                coefArray.append(2.0)
            }
        }
        coefArray.append(1)
        
        return coefArray
    }
    
    
    func swift_pnorm(x: Double, mean: Double, standardDev: Double, n: Int) -> Double {
                
        let zScore = swift_standardizedScore(x, mean: mean, standardDev: standardDev)
        let a, b : Double
        let delta_x: Double
        let rangeLimit: Double = 6.0
        
        /* Constrain calculations to be within rangeLimit standard scores of the mean */
        
        if (abs(zScore) >= rangeLimit) {
            a = 0; b = 0
            delta_x = 0.0
        } else if (zScore <= 0.0) {
            a = (-1.0) * rangeLimit
            b = zScore
            delta_x = (b - a) / Double(n)
        } else {
            a = zScore
            b = rangeLimit
            delta_x = (b - a) / Double(n)
        }
        
        var funcionValuesArray = [Double](count: n+1, repeatedValue: 0.0)
        
        for index in 0...(funcionValuesArray.count-1) {
            
            funcionValuesArray[index] = (swift_dorm((a + (delta_x * Double(index))), mean: 0, standardDev: 1))
            
        }
        
        /* Numerical integration performed using Simpson's method */
        
        let coefs = simpsonCoefsArray(funcionValuesArray.count)
        
        return (delta_x / 3) * zip(coefs, funcionValuesArray).map(*).reduce(0) {$0 + $1}
    }

    
}
