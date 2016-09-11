//
//  dataTableDatum.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/10/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation

class DataTableDatum: NSObject {
        
    var datumDoubleValue: Double?
    var datumText: String {
        didSet {
            if let unwrappedText = Double(datumText) {
                datumDoubleValue = unwrappedText
            } else {
                datumDoubleValue = nil
            }
        }
    }
    
    init(textFieldText: String) {
        self.datumText = textFieldText
    }
    
}
