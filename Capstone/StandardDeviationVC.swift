//
//  StandardDeviationVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class StandardDeviationVC: UIViewController {
    
    // MARK: - Properties
    var dataTableEntries: [DataTableDatum]!
    
    // MARK: - Outlets

    @IBOutlet var dataTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataTableView.dataSource = self
        dataTableView.delegate = self
        
        dataTableEntries = []
    }
    
    
    // MARK: - Actions
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension StandardDeviationVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DatumCell", forIndexPath: indexPath) as! DataTableViewCell
        
        cell.delegate = self
        
        return cell
    }



}

extension StandardDeviationVC: DataTableViewCellDelegate {
    
    func deleteDataTableCell(itemToRemove: DataTableDatum) {
        
        let indexOfItemToRemove = (dataTableEntries as NSArray).indexOfObject(itemToRemove)
        
        guard indexOfItemToRemove != NSNotFound else {
            return
        }
        
        dataTableEntries.removeAtIndex(indexOfItemToRemove)
        
        /* Update the table view */
        
        dataTableView.beginUpdates()
        let indexPathOfItemToDelete = NSIndexPath(forRow: indexOfItemToRemove, inSection: 0)
        dataTableView.deleteRowsAtIndexPaths([indexPathOfItemToDelete], withRowAnimation: .Automatic)
        dataTableView.endUpdates()
        
        
    }
}


extension StandardDeviationVC {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension StandardDeviationVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
