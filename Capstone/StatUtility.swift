//
//  StatUtility.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/5/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

struct StatUtility {
    
    let title: String
    let moreInfo: String
    let utilityID: Int
    var isShowingDetails: Bool
    
    init(title: String, moreInfo: String, utilityID: Int) {
        self.title = title
        self.moreInfo = moreInfo
        self.utilityID = utilityID
        self.isShowingDetails = false
    }
    
    static func getUtilitiesFromBundle() -> [StatUtility] {
        
        var utilityCollection = [StatUtility]()
        
        guard let path = NSBundle.mainBundle().pathForResource("statisticsUtilities", ofType: "json"), data = NSData(contentsOfFile: path) else {
            /* JSON file not found */
            return utilityCollection
        }
        
        do {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            
            guard let statUtilityDictionary = result["statUtilities"] as? [[String: AnyObject]] else {
                return utilityCollection
            }
            
            /* Use JSON content to create objects for the table view */
            for item in statUtilityDictionary {
                
                if let title = item["title"] as? String, moreInfo = item["moreInfo"] as? String, utilityID = item["id"] as? Int {
                    
                    let utility = StatUtility(title: title, moreInfo: moreInfo, utilityID: utilityID)
                    utilityCollection.append(utility)
                    
                }
            }
            
        } catch {
            /* When parsing fails */
            return utilityCollection
        }
        
        return utilityCollection    
    }
}
