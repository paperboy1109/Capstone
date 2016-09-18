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
    
    // MARK: - Outlets
    
    @IBOutlet var meanLabel: UILabel!
    @IBOutlet var varLabel: UILabel!
    @IBOutlet var sdLabel: UILabel!
    
    
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var q1Label: UILabel!
    @IBOutlet var medianLabel: UILabel!
    @IBOutlet var q3Label: UILabel!    
    @IBOutlet var maxLabel: UILabel!
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n*** Data Summary VC ***")
        print(dataTableEntries?.count)
        
        if let currentData = dataTableEntries {
            
            for item in currentData {
                print(item.datumDoubleValue)
            }
        }
        
        let currentData = StatisticsFunctions.getDataTableDataAsArrayOfDoubles(dataTableEntries)
        print("mean: \(StatisticsFunctions.swift_mean(currentData))")
        print("sd: \(StatisticsFunctions.swift_sd(currentData))")
        // print("fiveNumberSummary: \(StatisticsFunctions.swift_fiveNumberSummary(currentData))")
        
        /* Display common descriptive statistics */
        
        meanLabel.text = roundDoubleToNDecimals(StatisticsFunctions.swift_mean(currentData), n: maxDecimalPlaces)
        let standardDeviation = StatisticsFunctions.swift_sd(currentData)
        varLabel.text = roundDoubleToNDecimals(pow(standardDeviation, 2), n: maxDecimalPlaces)
        sdLabel.text = roundDoubleToNDecimals(standardDeviation, n: maxDecimalPlaces)
        
        let fiveNumberSummary = StatisticsFunctions.swift_fiveNumberSummary(currentData)
        minLabel.text = roundDoubleToNDecimals(fiveNumberSummary.min, n: maxDecimalPlaces)
        q1Label.text = roundDoubleToNDecimals(fiveNumberSummary.q1, n: maxDecimalPlaces)
        medianLabel.text = roundDoubleToNDecimals(fiveNumberSummary.q2, n: maxDecimalPlaces)
        q3Label.text = roundDoubleToNDecimals(fiveNumberSummary.q3, n: maxDecimalPlaces)
        maxLabel.text = roundDoubleToNDecimals(fiveNumberSummary.max, n: maxDecimalPlaces)

        print(fiveNumberSummary.q1)
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
    
    

    
    // MARK: - Actions
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
