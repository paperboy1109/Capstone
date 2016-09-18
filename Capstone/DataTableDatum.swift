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
    var datumText: String
    
    //    var datumText: String {
    //        didSet {
    //            if let unwrappedText = Double(datumText) {
    //                datumDoubleValue = unwrappedText
    //            } else {
    //                datumDoubleValue = nil
    //            }
    //        }
    //    }
    
    init(textFieldText: String) {
        
        self.datumText = textFieldText
        
        if let unwrappedText = Double(self.datumText) {
            self.datumDoubleValue = unwrappedText
        } else {
            self.datumDoubleValue = nil
        }
    }
    
    func updateDatumValue() {
        
        if let unwrappedText = Double(self.datumText) {
            self.datumDoubleValue = unwrappedText
        } else {
            self.datumDoubleValue = nil
        }
    }
    
}
