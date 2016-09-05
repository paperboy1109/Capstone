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
        let xValues = [-3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0]
        let xValuesAsStrings = xValues.map { String(format: "%.2f", $0) }
        var yValues: [ChartDataEntry] = []
        for i in 0..<xValues.count {
            let dataEntry = ChartDataEntry(value: StatisticsFunctions.swift_dorm(xValues[i], mean: 0, standardDev: 1), xIndex: i)
            yValues.append(dataEntry)
        }
        
        /* Display the sample data in a plot */
        let lineChart_yValues = LineChartDataSet(yVals: yValues, label: "Line 1")
        lineChart_yValues.mode = .CubicBezier
        lineChart_yValues.fillColor = UIColor.redColor()
        lineChart_yValues.drawFilledEnabled = true
        
        let lineChartData = LineChartData(xVals: xValuesAsStrings, dataSets: [lineChart_yValues])
        
        plotView.data = lineChartData
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
