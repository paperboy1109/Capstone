//
//  DataSummaryVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/17/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class DataSummaryVC: UIViewController {
    
    // MARK: - Properties
    
    var dataTableEntries: [DataTableDatum]!
    let numberFormatter = NSNumberFormatter()
    let maxDecimalPlaces = 5
    let themeColor = UIColor(red: 96.0/255.0, green: 237.0/255.0, blue: 179.0/255.0, alpha: 1.0)
    
    // MARK: - Outlets
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var headingLabel: UILabel!
    
    
    @IBOutlet var meanLabel: UILabel!
    @IBOutlet var varLabel: UILabel!
    @IBOutlet var sdLabel: UILabel!
    
    
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var q1Label: UILabel!
    @IBOutlet var medianLabel: UILabel!
    @IBOutlet var q3Label: UILabel!    
    @IBOutlet var maxLabel: UILabel!
    
    @IBOutlet var dividerView: UIView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFont()
        dividerView.backgroundColor = themeColor
        
        let currentData = StatisticsFunctions.getDataTableDataAsArrayOfDoubles(dataTableEntries)
        
        showDataSummary(currentData)


    }
    
    // MARK: - Helpers
    
    func roundDoubleToNDecimals(fullNumber: Double, n: Int) -> String {
        numberFormatter.minimumFractionDigits = n
        numberFormatter.maximumFractionDigits = n
        
        if let roundedNumberAsString = numberFormatter.stringFromNumber(fullNumber) {
            return roundedNumberAsString
        } else {
            return ""
        }
        
    }
    
    func setFont() {
        
        titleLabel.font = UIFont(name: "PTSans-Regular", size: 32)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.darkGrayColor()
        
        headingLabel.font = UIFont(name: "PTSans-Regular", size: 18)
        headingLabel.textColor = UIColor.darkGrayColor()
    }
    
    func showDataSummary(data: [Double]) {
        
        /* Display common descriptive statistics */
        meanLabel.text = roundDoubleToNDecimals(StatisticsFunctions.swift_mean(data), n: maxDecimalPlaces)
        let standardDeviation = StatisticsFunctions.swift_sd(data)
        varLabel.text = roundDoubleToNDecimals(pow(standardDeviation, 2), n: maxDecimalPlaces)
        sdLabel.text = roundDoubleToNDecimals(standardDeviation, n: maxDecimalPlaces)
        
        let fiveNumberSummary = StatisticsFunctions.swift_fiveNumberSummary(data)
        minLabel.text = roundDoubleToNDecimals(fiveNumberSummary.min, n: maxDecimalPlaces)
        q1Label.text = roundDoubleToNDecimals(fiveNumberSummary.q1, n: maxDecimalPlaces)
        medianLabel.text = roundDoubleToNDecimals(fiveNumberSummary.q2, n: maxDecimalPlaces)
        q3Label.text = roundDoubleToNDecimals(fiveNumberSummary.q3, n: maxDecimalPlaces)
        maxLabel.text = roundDoubleToNDecimals(fiveNumberSummary.max, n: maxDecimalPlaces)
        
    }
    
    

    
    // MARK: - Actions
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
