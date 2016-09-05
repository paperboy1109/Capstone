//
//  UtilitiesVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/27/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class UtilitiesVC: UIViewController {
    
    // MARK: - Properties
    
    let statUtilities = StatUtility.getUtilitiesFromBundle()
    
    // MARK: - Outlets
    
    @IBOutlet var statUtilityTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in statUtilities {
            print(item)
        }
        
        statUtilityTableView.delegate = self
        
        /* Have Auto Layout determine the height of the table view cells */
        statUtilityTableView.rowHeight = UITableViewAutomaticDimension
        statUtilityTableView.estimatedRowHeight = 64
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
        
        let utilityForCell = statUtilities[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! StatUtilitiesTableViewCell? {
            
            cell.titleLabel.text = utilityForCell.title//"Calculate ALL the p-values!"
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statUtilities.count
        
    }
    
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 68
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // let selectedTableCell = tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)
        print(statUtilities[indexPath.row].utilityID)
        
        let utilityID = statUtilities[indexPath.row].utilityID
        
//        if utilityID == 1 {
//            let selectedUtility = self.storyboard!.instantiateViewControllerWithIdentifier("StandardNormal") as! StandardNormalVC
//            self.presentViewController(selectedUtility, animated: true, completion: nil)
//        }
        
        //TODO: Segue to the corresponding statistics tool
        //self.performSegueWithIdentifier("ToErsatzStatTables", sender: nil)
        switch utilityID {
        case 0:
            let selectedUtility = self.storyboard!.instantiateViewControllerWithIdentifier("StatTables") as! ErsatzStatTablesVC
            self.presentViewController(selectedUtility, animated: true, completion: nil)
        case 1:
            let selectedUtility = self.storyboard!.instantiateViewControllerWithIdentifier("StandardNormal") as! StandardNormalVC
            self.presentViewController(selectedUtility, animated: true, completion: nil)
        default: break
            
        }
        
        
    }
    
    
}