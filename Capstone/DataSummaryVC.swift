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
    }
    
    

    
    // MARK: - Actions
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
