//
//  UtilitiesVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/27/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class UtilitiesVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var statUtilityTableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
                
        statUtilityTableView.delegate = self
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

// MARK: - Table View Delegate Methods

extension UtilitiesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "StatUtilityCell"
        
        if var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell! {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellReuseIdentifier)
            
            cell.textLabel!.text = "textLabel"
            
            cell.detailTextLabel!.text = "detailTextLabel"
            
            return cell
            
        } else {
            /* Make updates here when working with a custom cell */
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // let selectedTableCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)
        
        //TODO: Segue to the corresponding statistics tool
        self.performSegueWithIdentifier("ToErsatzStatTables", sender: nil)
        
        
    }
    
    
}