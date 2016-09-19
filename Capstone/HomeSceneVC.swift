//
//  HomeSceneVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/4/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import Charts

class HomeSceneVC: UIViewController {
    
    // MARK: - Properties
    
    let calculationHelper = StatisticsFunctions()
    
    // MARK: - Outlets
    
    @IBOutlet var plotView: LineChartView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Create some sample data */
        
        let xValues = SequenceGenerator.createSequenceWithStartingPoint(-2.5, end: 2.5, numberOfSteps: 50)
        
        let xValuesAsStrings = xValues.map { String(format: "%.2f", $0) }
        var yValues: [ChartDataEntry] = []
        for i in 0..<xValues.count {
            let dataEntry = ChartDataEntry(value: StatisticsFunctions.swift_dorm(xValues[i], mean: 0, standardDev: 1), xIndex: i)
            yValues.append(dataEntry)
        }
        
        /* Display the sample data in a plot */
        let lineChart_yValues = LineChartDataSet(yVals: yValues, label: "Line 1")
        lineChart_yValues.mode = .CubicBezier
        lineChart_yValues.fillColor = UIColor(red: 96.0/255.0, green: 237.0/255.0, blue: 179.0/255.0, alpha: 1.0)
        lineChart_yValues.drawFilledEnabled = true
        lineChart_yValues.drawCirclesEnabled = false
        
        /* Set the data to display in the plot */
        let lineChartData = LineChartData(xVals: xValuesAsStrings, dataSets: [lineChart_yValues])
        plotView.data = lineChartData
        
        /* Configure the look of the plot */
        plotView.leftAxis.axisMinValue = 0.0
        plotView.rightAxis.axisMaxValue = 0.0        
        plotView.legend.enabled = false
        plotView.descriptionText = ""
        plotView.userInteractionEnabled = false
        /* Remove labels from the data points and axes */
        plotView.data?.setValueTextColor(UIColor.clearColor())
        plotView.leftAxis.labelTextColor = UIColor.clearColor()
        plotView.xAxis.labelTextColor = UIColor.clearColor()
        
    }


}

extension HomeSceneVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
