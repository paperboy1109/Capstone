//
//  Datum+CoreDataProperties.swift
//  
//
//  Created by Daniel J Janiak on 9/25/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Datum {

    @NSManaged var text: String?
    @NSManaged var numericalValue: NSNumber?

}
