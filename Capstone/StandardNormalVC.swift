//
//  StandardNormalVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/5/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import Charts
import NumberMorphView

class StandardNormalVC: UIViewController {
    
    // MARK: - Properties
    
    let plotBackgroundColor = UIColor.whiteColor()
    let defaultStartingPoint = -3.0
    let defaultEndingPoint = 3.0
    let defaultStepsPerLine = 99
    let defaultDecimalPlacesToShow = 3
    
    let numberFormatter = NSNumberFormatter()
    let pValNumberFormatter = NSNumberFormatter()
    
    var zScore: Double!
    
    // MARK: - Outlets
    
    @IBOutlet var plusMinusLabel: UILabel!
    @IBOutlet var leadingDigit: NumberMorphView!
    @IBOutlet var decimal1: NumberMorphView!
    @IBOutlet var decimal2: NumberMorphView!
    @IBOutlet var decimal3: NumberMorphView!
    
    @IBOutlet var stepper: UIStepper!
    
    @IBOutlet var pValTitleLabel: UILabel!
    @IBOutlet var pValueLabel: UILabel!
    
    @IBOutlet var plotView: LineChartView!
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var maskView: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePlotView()
        
        numberFormatter.maximumFractionDigits = defaultDecimalPlacesToShow
        numberFormatter.minimumFractionDigits = defaultDecimalPlacesToShow
        
        slider.minimumValue = -3.0
        slider.maximumValue = 3.0
        
        stepper.stepValue = 0.001
        stepper.minimumValue = Double(slider.minimumValue)
        stepper.maximumValue = Double(slider.maximumValue)
        
        leadingDigit.currentDigit = 0
        decimal1.currentDigit = 0
        zScore = 0.0
        
        pValTitleLabel.text = "p-value:"
        maskView.hidden = false
    }
    
    
    // MARK: - Actions
    
    @IBAction func plotTapped(sender: UIButton) {
        
        maskView.hidden = true
        
        plotView.data = nil
        plotView.setNeedsLayout()
        
        let xValues = SequenceGenerator.createSequenceWithStartingPoint(defaultStartingPoint, end: defaultEndingPoint, numberOfSteps: defaultStepsPerLine)
        let yValues = xValues.map() { StatisticsFunctions.swift_dorm($0, mean: 0, standardDev: 1)}
        
        switch sender.tag {
            
        case 0:
            let maskFillValues = lineDataForMaskingFill(xValues, targetValue: zScore, maskingValue: yValues.maxElement()!, leftTail: true)
            pNormWithFill(xValues, dataCollections: [yValues, maskFillValues])
            
            /* Display the p-value */
            if zScore > 0 {
                
                pValueLabel.text = roundPValue(1.0 - StatisticsFunctions.swift_pnormFewestSteps(zScore, mean: 0, standardDev: 1, n: 500))
                
            } else {
                
                pValueLabel.text = roundPValue(StatisticsFunctions.swift_pnormFewestSteps(zScore, mean: 0, standardDev: 1, n: 500))
            }
        case 1:
            let maskFillValues = lineDataForMaskingFill(xValues, targetValue: zScore, maskingValue: yValues.maxElement()!, leftTail: false)
            pNormWithFill(xValues, dataCollections: [yValues, maskFillValues])
            /* Display the p-value */
            if zScore < 0 {

                pValueLabel.text = roundPValue(1.0 - StatisticsFunctions.swift_pnormFewestSteps(zScore, mean: 0, standardDev: 1, n: 500))
                
            } else {
                
                pValueLabel.text = roundPValue(StatisticsFunctions.swift_pnormFewestSteps(zScore, mean: 0, standardDev: 1, n: 500))
            }
        default:
            let maskFillValues = lineDataForMaskingFill(xValues, targetValue: 3.0, maskingValue: yValues.maxElement()!, leftTail: false)
            pNormWithFill(xValues, dataCollections: [yValues, maskFillValues])
            
        }
        
        let plotVerticalLimit = yValues.maxElement()! * 1.1
        
        plotView.xAxis.setLabelsToSkip(10)
        plotView.leftAxis.axisMaxValue = plotVerticalLimit
        plotView.rightAxis.axisMaxValue = plotVerticalLimit
        plotView.setNeedsLayout()
        
        plotView.animate(xAxisDuration: 2.0, easingOption: .EaseInOutQuad)
        //plotView.animate(yAxisDuration: 1.5, easingOption: .EaseInOutQuart)
        
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sliderMoved(sender: UISlider) {
        
        /* Synchronize with the stepper value */
        stepper.value = Double(slider.value)
        
        if sender.value < 0 {
            plusMinusLabel.text = "-"
        } else {
            plusMinusLabel.text = ""
        }
        
        setMorphNumbers(sender.value)
        
    }
    
    
    @IBAction func stepperTapped(sender: UIStepper) {
        
        if sender.value < 0 {
            plusMinusLabel.text = "-"
        } else {
            plusMinusLabel.text = ""
        }
        
        slider.value = Float(stepper.value)
        
        setMorphNumbers(slider.value)
        
        
    }
    
    // MARK: - Helpers
    
    func updateZScore(leadingDigit: Int, firstDecimal: Int, secondDecimal: Int, thirdDecimal: Int) {
        
        let zScoreText = "\(leadingDigit)" + "." + "\(firstDecimal)\(secondDecimal)\(thirdDecimal)"
        
        zScore = Double(zScoreText)
        
        if plusMinusLabel.text == "-" {
            zScore = (-1.0) * zScore
        }
        
    }
    
    func setMorphNumbers(newValue: Float) {
        
        guard var numberText = numberFormatter.stringFromNumber(abs(newValue)) else {
            return
        }
        
        guard !numberText.isEmpty else {
            return
        }
        
        /* Add a leading zero */
        if numberText[numberText.startIndex] == "." {
            numberText = "0" + numberText
        }
        
        if numberText.characters.count == 5 {
            
            let leadingDigitAsString = String(numberText[numberText.startIndex])
            let firstDecimalAsString = String(numberText[numberText.startIndex.advancedBy(2)])
            let secondDecimalAsString = String(numberText[numberText.startIndex.advancedBy(3)])
            let thirdDecimalAsString = String(numberText[numberText.startIndex.advancedBy(4)])
            
            guard let newLeadingDigit = Int(leadingDigitAsString),
                newFirstDecimal = Int(firstDecimalAsString),
                newSecondDecimal = Int(secondDecimalAsString),
                newThirdDecimal = Int(thirdDecimalAsString) else {
                    return
            }
            
            leadingDigit.nextDigit = newLeadingDigit
            decimal1.nextDigit = newFirstDecimal
            decimal2.nextDigit = newSecondDecimal
            decimal3.nextDigit = newThirdDecimal
            
            /* The zScore and displayed value must be an exact match */
            updateZScore(newLeadingDigit, firstDecimal: newFirstDecimal, secondDecimal: newSecondDecimal, thirdDecimal: newThirdDecimal)
        }
    }
    
    func roundPValue(fullNumber: Double) -> String {
        pValNumberFormatter.minimumFractionDigits = 4
        pValNumberFormatter.maximumFractionDigits = 4
        
        if let roundedNumberAsString = pValNumberFormatter.stringFromNumber(fullNumber) {
            return roundedNumberAsString
        } else {
            return ""
        }
        
    }
    
    
}

extension StandardNormalVC {
    
    func configurePlotView() {
        
        /* Remove the grid */
        plotView.xAxis.drawGridLinesEnabled = false
        plotView.drawGridBackgroundEnabled = false
        plotView.backgroundColor = plotBackgroundColor
        
        /* Set up the axes */
        plotView.leftAxis.drawGridLinesEnabled = false
        plotView.leftAxis.enabled = false
        plotView.leftAxis.axisMinValue = 0.0
        
        plotView.rightAxis.drawGridLinesEnabled = false
        plotView.rightAxis.enabled = false
        plotView.rightAxis.axisMinValue = 0.0
        
        plotView.xAxis.setLabelsToSkip(0)
        
        /* Remove the legend */
        plotView.legend.enabled = false
        
        /* Remove the description */
        plotView.descriptionText = ""
        
        /* Disable user interaction (tapping would otherwise collapse the plot */
        plotView.userInteractionEnabled = false
        
    }
    
    func lineDataForMaskingFill(xValues: [Double], targetValue: Double, maskingValue: Double, leftTail: Bool) -> [Double] {
        
        var errorArray: [Double] = [] // xValues.map() {abs(targetValue - $0)}
        var offset = 0
        
        /* Most practical use cases fit one of the statements below */
        
        // (1)
        if leftTail && targetValue < 0 {
            errorArray = xValues[0...xValues.count/2].map() {abs(targetValue - $0)}
        }
            // (2)
        else if !leftTail && targetValue > 0 {
            errorArray = xValues[(xValues.count-1)/2...(xValues.count-1)].map() {abs(targetValue - $0)}
            offset = ((xValues.count-1)/2)
        }
            
            /* Not practical, but students will want the flexibility */
            
            // (3)
        else {
            errorArray = xValues.map() {abs(targetValue - $0)}
        }
        
        guard errorArray.count > 0 else {
            return [Double](count: xValues.count, repeatedValue: 0.0)
        }
        
        // let maskingValue = yValues.maxElement()!
        let availableTarget = xValues[offset + errorArray.indexOf(errorArray.minElement()!)!]
        
        let maskingArray = xValues.map() { (xValue) -> Double in
            
            if leftTail {
                return xValue < availableTarget ? 0 : maskingValue
            } else {
                return xValue < availableTarget ? maskingValue : 0
            }
        }
        
        return maskingArray
    }
    
    func pNormWithFill(xValues: [Double], dataCollections: [[Double]]) {
        
        let xValuesAsStrings = xValues.map { String(format: "%.2f", $0) }
        
        let bezierIntensity:CGFloat = 0.1
        
        var completeDataEntriesCollection: [[ChartDataEntry]] = [[]]
        
        for item in dataCollections {
            
            var newDataCollection: [ChartDataEntry] = []
            
            for i in 0..<xValues.count {
                let dataEntry = ChartDataEntry(value: item[i], xIndex: i)
                newDataCollection.append(dataEntry)
            }
            
            completeDataEntriesCollection.append(newDataCollection)
            
        }
        
        completeDataEntriesCollection.removeFirst()
        
        let lineChartDataSet_Layer1 = LineChartDataSet(yVals: completeDataEntriesCollection[0], label: "Line 1")
        let lineChartDataSet_Layer2 = LineChartDataSet(yVals: completeDataEntriesCollection[1], label: "Line 2")
        let lineChartDataSet_Layer3 = LineChartDataSet(yVals: completeDataEntriesCollection[0], label: "Line 3")
        
        /* Customize the appearance of line 1 (bottom layer) */
        lineChartDataSet_Layer1.fillColor = UIColor.redColor()
        lineChartDataSet_Layer1.drawFilledEnabled = true
        lineChartDataSet_Layer1.drawCirclesEnabled = false
        lineChartDataSet_Layer1.mode = .CubicBezier
        lineChartDataSet_Layer1.cubicIntensity = bezierIntensity
        lineChartDataSet_Layer1.setColor(UIColor.darkGrayColor())
        
        /* Customize the appearance of line 2 (middle layer) */
        lineChartDataSet_Layer2.setColor(plotBackgroundColor)
        lineChartDataSet_Layer2.fillColor = plotBackgroundColor
        lineChartDataSet_Layer2.drawFilledEnabled = true
        lineChartDataSet_Layer2.fillAlpha = 1.0
        lineChartDataSet_Layer2.mode = .Stepped
        lineChartDataSet_Layer2.drawCirclesEnabled = false
        
        /* Customize the appearance of line 3 (top layer)*/
        lineChartDataSet_Layer3.drawCirclesEnabled = false
        lineChartDataSet_Layer3.mode = .CubicBezier
        lineChartDataSet_Layer3.cubicIntensity = bezierIntensity
        lineChartDataSet_Layer3.setColor(UIColor.darkGrayColor())
        
        
        let linesToPlot = [lineChartDataSet_Layer1, lineChartDataSet_Layer2, lineChartDataSet_Layer3]
        
        let lineChartData = LineChartData(xVals: xValuesAsStrings, dataSets: linesToPlot)
        
        /* Set the data to be included in the plot */
        plotView.data = lineChartData
        
        /* Remove labels from the data points */
        plotView.data?.setValueTextColor(UIColor.clearColor())
        
        // plotView.xAxis.axisMinValue
        plotView.leftAxis.axisMinValue = dataCollections[0].minElement()!
        plotView.rightAxis.axisMinValue = dataCollections[0].minElement()!
    }
    
    
}

extension StandardNormalVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /* Disable landscape mode for this scene */
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}
