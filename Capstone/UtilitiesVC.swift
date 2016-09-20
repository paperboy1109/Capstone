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
    
    var statUtilities = StatUtility.getUtilitiesFromBundle()
    
    let cellReuseIdentifier = "StatUtilityCell"
    
    let utilityInfoText = "Tap for details ... "
    
    // MARK: - Outlets
    
    @IBOutlet var statUtilityTableView: UITableView!
    @IBOutlet var bannerLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in statUtilities {
            print(item)
        }
        
        statUtilityTableView.delegate = self
        
        /* Have Auto Layout determine the height of the table view cells */
        statUtilityTableView.rowHeight = UITableViewAutomaticDimension
        statUtilityTableView.estimatedRowHeight = 100
        
        /* Set the text in the banner */
        bannerLabel.font = UIFont(name: "PTSans-Regular", size: 32)
        bannerLabel.textColor = UIColor.darkGrayColor()
        bannerLabel.textAlignment = NSTextAlignment.Center
        bannerLabel.text = "Helpful utilities, ready when you are."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func moreInfoTapped(sender: UIButton) {
        print("The button was tapped")
        print(sender.tag)
        
        /* Access the cell that contains the button */
        var targetIndexPath: NSIndexPath!
        
        let currentButton = sender
        if let buttonSuperview = currentButton.superview {
            if let currentCell = buttonSuperview.superview as? StatUtilitiesTableViewCell {
                targetIndexPath = statUtilityTableView.indexPathForCell(currentCell)
                
                
                /* Toggle the state of the cell (utility details are displayed, or not) */
                var utilityForCell = statUtilities[sender.tag]
                utilityForCell.isShowingDetails = !utilityForCell.isShowingDetails
                
                /* Update the cell */
                currentCell.utilityDetailsText.text = utilityForCell.isShowingDetails ? utilityForCell.moreInfo : utilityInfoText
                currentCell.utilityDetailsText.textAlignment = utilityForCell.isShowingDetails ? NSTextAlignment.Left : NSTextAlignment.Center
                
                /* Update the model */
                statUtilities[targetIndexPath.row] = utilityForCell
                
                /* Animate constraint changes now that the moreInfoTextView has changed size and content */
                UIView.animateWithDuration(0.3) {
                    currentCell.contentView.layoutIfNeeded()
                }
                
                /* Force the table view to update */
                statUtilityTableView.beginUpdates()
                statUtilityTableView.endUpdates()
                
                /* Scroll the table view so that the selected cell is aligned with the top of the table view (helpful when the description is long)*/
                statUtilityTableView.scrollToRowAtIndexPath(targetIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            }
        }
        
    }
    
    
    
}

// MARK: - Table View Delegate Methods

extension UtilitiesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let utilityForCell = statUtilities[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! StatUtilitiesTableViewCell? {
            
            cell.utilityDetailsButton.tag = indexPath.row
            
            cell.titleLabel.text = utilityForCell.title
            cell.utilityDetailsText.text = utilityForCell.isShowingDetails ? utilityForCell.moreInfo : utilityInfoText
            cell.utilityDetailsText.textAlignment = utilityForCell.isShowingDetails ? NSTextAlignment.Left : NSTextAlignment.Center
            
            
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
        case 2:
            let selectedUtility = self.storyboard!.instantiateViewControllerWithIdentifier("ConfidenceIntervals")
            self.presentViewController(selectedUtility, animated: true, completion: nil)
        case 3:
            let selectedUtility = self.storyboard!.instantiateViewControllerWithIdentifier("StandardDeviation") as! StandardDeviationVC
            self.presentViewController(selectedUtility, animated: true, completion: nil)
        default: break
            
        }
        
        
    }
}


extension UtilitiesVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}