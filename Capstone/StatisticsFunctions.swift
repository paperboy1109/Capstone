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
    
    static func swift_dorm(x: Double, mean: Double, standardDev: Double) -> Double {
        
        let variance = standardDev * standardDev
        let coef = ( 1/(sqrt(2.0 * M_PI * variance)) )
        let exponent = (-1) * ( pow(x - mean, 2) / (2 * variance) )
        
        return coef * pow(M_E, exponent)
    }
    
    
    static func swift_standardizedScore(x: Double, mean: Double, standardDev: Double) -> Double {
        
        return (x - mean) / standardDev
    }
    
    static func simpsonCoefsArray(k: Int) -> [Double] {
        
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
    
    
    static func swift_pnormFewestSteps(x: Double, mean: Double, standardDev: Double, n: Int) -> Double {
        
        let zScore = swift_standardizedScore(x, mean: mean, standardDev: standardDev)
        let a, b : Double
        let delta_x: Double
        let rangeLimit: Double = 6.0
        
        if abs(zScore) >= rangeLimit {
            a = 0.0; b = 0.0
            delta_x = 0.0
            
        } else if zScore <= 0.0 {
            a = (-1.0) * rangeLimit; b = zScore
            delta_x = (b - a) / Double(n)
        } else {
            a = (-1.0) * rangeLimit; b = (-1) * zScore
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
    
    /* Implements the approximation method of Beasley, Springer, and Moro */
    static func swift_qNorm(targetPval: Double) -> Double {
        
        if (targetPval > 0.08) && (targetPval < 0.92) {
            
            let y = targetPval - 0.5
            let z = pow(y,2)
            
            let numeratorCoeffArray = [2.50662823884, -18.61500062529, 41.39119773534, -25.44106049637]
            var numeratorTermsArray: [Double] = []
            for index in 0...(numeratorCoeffArray.count - 1) {
                numeratorTermsArray.append(pow(z, Double(index)))
            }
            let numerator = zip(numeratorCoeffArray, numeratorTermsArray).map(*).reduce(0, combine: +)
            
            let denomCoeffArray = [1.0, -8.47351093090, 23.08336743743, -21.06224101826, 3.13082909833]
            var denomTermsArray: [Double] = []
            for index in 0...(denomCoeffArray.count - 1) {
                denomTermsArray.append(pow(z, Double(index)))
            }
            let denom = zip(denomCoeffArray, denomTermsArray).map(*).reduce(0, combine: +)
            
            return y * numerator / denom
            
            /* For p-values close to the extremes, 0 or 1*/
        } else {
            
            let quantile_y = targetPval - 0.5
            let quantile_z: Double!
            if quantile_y > 0 {
                quantile_z = 1 - targetPval
            } else {
                quantile_z = targetPval
            }
            
            let kappa = log( (-1.0) * log(quantile_z) )
            
            let coeffArray = [0.3374754822726147, 0.9761690190917186, 0.1607979714918209, 0.0276438810333863, 0.0038405729373609, 0.0003951896511919, 0.0000321767881768, 0.0000002888167364, 0.0000003960315187]
            var kappaSeriesArray: [Double] = []
            
            for index in 0...(coeffArray.count - 1) {
                kappaSeriesArray.append(pow(kappa, Double(index)))
            }
            
            if quantile_y < 0 {
                return (-1) * zip(coeffArray, kappaSeriesArray).map(*).reduce(0, combine: +)
            } else {
                return zip(coeffArray, kappaSeriesArray).map(*).reduce(0, combine: +)
            }
        }
    }

    
    
}
