//
//  StatisticsFunctions.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/29/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import GameplayKit

public class StatisticsFunctions {
    
    static func swift_getArbitraryNormal(z: Double, mean: Double, sd: Double) -> Double {
        return (z * sd) + mean
    }
    
    static func swift_standardizedScore(x: Double, mean: Double, standardDev: Double) -> Double {
        
        return (x - mean) / standardDev
    }
    
    static func swift_dorm(x: Double, mean: Double, standardDev: Double) -> Double {
        
        let variance = standardDev * standardDev
        let coef = ( 1/(sqrt(2.0 * M_PI * variance)) )
        let exponent = (-1) * ( pow(x - mean, 2) / (2 * variance) )
        
        return coef * pow(M_E, exponent)
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
    
    static func swift_dt(x: Double, df: Int) -> Double {
        
        let numerator: Double = tgamma((Double(df) + 1) / 2)
        let denominator1: Double = sqrt(M_PI * Double(df)) * tgamma(Double(df)/2)
        let denominator2: Double =  pow( (1 + ((x * x)/Double(df))), (Double(df)+1)/2 )
        
        return numerator / (denominator1 * denominator2)
    }
    
    // MARK: - Formulas relevant to working with the t-distribution
    // Note: the approximation derives from the work of William T. Shaw
    // http://www.homepages.ucl.ac.uk/~ucahwts/lgsnotes/JCF_Student.pdf
    
    /* Restrict the calculations */
    static let iterationLimit = 1000
    static let desiredAccuracy = pow(10.0, -7)
    
    /* For readability */
    typealias SingleVariableFunctionWithDf = (Double, Int) -> (Double)
    
    static func estimateRoot(targetValue: Double, minValue: Double, maxValue: Double, df: Int, function: SingleVariableFunctionWithDf ) -> Double {
        
        var newApproximation = (minValue + maxValue) / 2.0
        var y = function(newApproximation, df)
        var error = y - targetValue
        var lowerApprox = minValue
        var upperApprox = maxValue
        
        var counter = 0
        
        while abs(error) > desiredAccuracy && counter < iterationLimit {
            
            if error > 0 {
                upperApprox = newApproximation
            } else {
                lowerApprox = newApproximation
            }
            
            newApproximation = (upperApprox + lowerApprox) / 2.0
            
            y = function(newApproximation, df)
            error = (y - targetValue)
            
            counter += 1
            
            print("guess: \(newApproximation)")
        }
        
        return newApproximation
        
    }
    
    /* Beta functions */
    static func logBeta(p: Double, q: Double) -> Double {
        
        guard p > 0.0 && q > 0.0 else {
            return 0.0
        }
        
        return lgamma(p) + lgamma(q) - lgamma(p + q)
    }
    
    static func betaFraction(x: Double, p: Double, q: Double) -> Double {
        
        var delta = 0.0
        
        let pqSum = p + q
        let plusP = 1.0 + p
        let minusP = p - 1.0
        var h = 1.0 - (pqSum * x) / plusP
        
        h = 1.0 / h
        var fraction = h
        var m = 1
        var c = 1.0
        
        while m <= iterationLimit && abs(delta - 1.0) > desiredAccuracy {
            
            let m1 = Double(m)
            let m2 = 2 * Double(m)
            
            // d even
            var d = (m1 * (q - m1) * x) / ( (minusP + m2) * (p + m2) )
            h = 1.0 + (d * h)
            h = 1.0 / h
            c = 1.0 + d / c
            fraction = fraction * h * c
            
            // d odd
            d = ( (-1.0) * (p + m1) * (pqSum + m1) * x ) / ( (p + m2) * (plusP + m2) )
            h = 1.0 + d * h
            h = 1.0 / h
            c = 1.0 + (d / c)
            delta = h * c
            fraction = fraction * delta
            
            m += 1
            
        }
        
        return fraction
        
    }
    
    static func incompleteBeta(x: Double, p: Double, q: Double) -> Double {
        
        guard x >= 0.0 && x <= 1.0 else {
            return 0.0
        }
        
        guard p > 0.0 && q > 0.0 else {
            return 0.0
        }
        
        let beta_gam = pow(M_E, -logBeta(p, q: q) + p * log(x) + q * log(1.0 - x) )
        
        if x < (p + 1.0) / (p + q + 2.0) {
            return beta_gam * betaFraction(x, p: p, q: q) / p
        } else {
            return 1.0 - ( beta_gam * betaFraction((1.0 - x), p: q, q: p) / q )
        }
        
    }
    
    static func swift_pt(tScore: Double, df: Int) -> Double {
        
        let x = ( Double(df) / (Double(df) + pow(tScore, 2)) )
        let p = 0.5 * Double(df)
        let result = 0.5 * incompleteBeta(x, p: p, q: 0.5)
        
        if tScore > 0 {
            return 1.0 - result
        } else {
            return result
        }
        
    }
    
    static func swift_qt(pVal: Double, df: Int) -> Double {
        
        guard pVal >= 0.0 && pVal <= 1.0 else {
            return 0.0
        }
        
        if pVal == 0.0 {
            return Double("inf")!
        } else if pVal == 1.0 {
            return Double("-inf")!
        }
        
        return estimateRoot(pVal, minValue: (-1.0) * pow(10.0, 2), maxValue: pow(10.0, 2), df: df, function: swift_pt)
    }
    
    // MARK: - Data summary
    
    
    /* These methods are all designed with small, user-entered data sets in mind */
    
    static func getDataTableDataAsArrayOfDoubles(data: [DataTableDatum]) -> [Double] {
        
        var arrayOfDoubles: [Double] = []
        
        for item in data {
            if let newDatum = item.datumDoubleValue {
                arrayOfDoubles.append(newDatum)
            }
        }
        
        return arrayOfDoubles
        
    }
    
    static func swift_mean(data: [Double]) -> Double {
        
        return data.reduce(0.0, combine: +) / Double(data.count)
    }
    
    static func swift_sd(data: [Double]) -> Double {
        
        let currentMean = swift_mean(data)
        let squaredDeviations = data.map{pow(($0 - currentMean), 2)}
        let sSD = squaredDeviations.reduce(0.0, combine: +)        
        
        return sqrt(sSD / Double(data.count - 1))
    
    }
    
    static func swift_median(data: [Double]) -> Double {
        
        let sortedData = data.sort()
        
        if data.count % 2 != 0 {
            return sortedData[sortedData.count/2]
        } else {
            return (sortedData[sortedData.count/2 - 1 ] + sortedData[sortedData.count/2 ]) / 2.0
        }
        
    }
    
    static func swift_fiveNumberSummary(data: [Double]) -> (min: Double, q1: Double, q2: Double, q3: Double, max: Double) {
        
        let sortedData = data.sort()
        let q1: Double
        let q3: Double
        
        if sortedData.count % 2 != 0 {
            q1 = swift_median(Array(sortedData[0...sortedData.count/2 - 1 ]))
            q3 = swift_median(Array(sortedData[(sortedData.count/2 + 1)...(sortedData.count - 1) ]))
        } else {
            q1 = swift_median(Array(sortedData[0...sortedData.count/2 - 1 ]))
            q3 = swift_median(Array(sortedData[(sortedData.count/2)...(sortedData.count - 1) ]))
        }
        
        return (sortedData.minElement()!, q1, swift_median(sortedData), q3, sortedData.maxElement()!)
    }

    // MARK: - Generating Random Numbers
    
    static func swift_randomNormal(mean: Double, sd: Double) -> Double {
        
        /* Use the Box-Muller transormation */
        // http://www.design.caltech.edu/erik/Misc/Gaussian.html
        
        let x1: Double = Double(GKMersenneTwisterRandomSource.sharedRandom().nextUniform())
        let x2: Double = Double(GKMersenneTwisterRandomSource.sharedRandom().nextUniform())
        
        let y1 = sqrt( (-1.0) * 2.0 * log(x1)) * cos(2 * M_PI * x2)
        let y2 = sqrt( (-1.0) * 2.0 * log(x1)) * sin(2 * M_PI * x2)
        
        let takeTheFirst = GKMersenneTwisterRandomSource.sharedRandom().nextBool()
        
        let z: Double
        if takeTheFirst {
            z = y1
        } else {
            z = y2
        }
        
        return swift_getArbitraryNormal(z, mean: mean, sd: sd)
    }
    
    static func swift_randomInt(min: Double, max: Double) -> Int {
        
        let minInt = Int(floor(min))
        let maxInt = Int(ceil(max))
        
        let gkRandomDistribution = GKRandomDistribution(lowestValue: minInt, highestValue: maxInt)
        
        return gkRandomDistribution.nextInt()
    }
    
    
    static func swift_randomUniform(min: Double, max: Double) -> Double {
        return ( Double(GKMersenneTwisterRandomSource.sharedRandom().nextUniform()) * (max - min)) + (min)
    }
    
}
