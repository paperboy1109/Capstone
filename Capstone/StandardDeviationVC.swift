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
    
    let placeholderTableCell = DataTableViewCell()
    
    var pullDownGestureActive = false
    
    // MARK: - Outlets
    
    @IBOutlet var dataTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTableView.dataSource = self
        dataTableView.delegate = self
        dataTableView.rowHeight = 64.0
        
        dataTableEntries = []
        
        /* Create some example data */
        let sampleData = ["1.0", "2.0", "3.0", "4.0", "5.0", "6.0", "7.0"]
        for item in sampleData {
            let newDatum = DataTableDatum(textFieldText: item)
            dataTableEntries.append(newDatum)
        }
        
        print("dataTableEntries includes \(dataTableEntries.count) entries")
        
        // TODO: Fix this crash
        //placeholderTableCell.datumTextField.text = "Hello"
        //print("Here is placeholderTableCell: \(placeholderTableCell)")
        
        
    }
    
    
    // MARK: - Actions
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: - Delegates for the table view

extension StandardDeviationVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTableEntries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("cellForRowAtIndexPath, number of cells: \(dataTableEntries.count)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DatumCell", forIndexPath: indexPath) as! DataTableViewCell
        
        cell.delegate = self
        // TODO: Add data to the cell
        cell.datum = dataTableEntries[indexPath.row]
        
        return cell
    }
    
    
    
}

// MARK: - Delegate methods for the custom cell class

extension StandardDeviationVC: DataTableViewCellDelegate {
    
    func addDataTableCell() {
        
        let newDatum = DataTableDatum(textFieldText: "")
        dataTableEntries.insert(newDatum, atIndex: 0)
        dataTableView.reloadData()
        
        var newCell: DataTableViewCell
        
        let allVisibleCells = dataTableView.visibleCells as! [DataTableViewCell]
        
        for item in allVisibleCells {
            
            if item.datum === newDatum {
                newCell = item
                newCell.datumTextField.becomeFirstResponder()
                break
            }
        }
    }
    
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
    
    func cellDidBeginEditing(editingCell: DataTableViewCell) {
        
        print("\n *** cellDidBeginEditing *** ")
        print("dataTableView.contentOffset: \(dataTableView.contentOffset)")
        print("editingCell.frame.origin.y: \(editingCell.frame.origin.y)")
        
        // TODO: Implement this method
        let offsetWhileEditing = dataTableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        let cellsToMove = dataTableView.visibleCells as! [DataTableViewCell]
        
        for item in cellsToMove {
            UIView.animateWithDuration(0.4, animations: {() in
                /* Move the cell up relative to the scroll position of the table view */
                item.transform = CGAffineTransformMakeTranslation(0, offsetWhileEditing)
                if item !== editingCell {
                    item.alpha = 0.3
                }
            })
        }
    }
    
    func cellDidEndEditing(editingCell: DataTableViewCell) {
        
        // TODO: Implement this method
        let cellsToMove = dataTableView.visibleCells as! [DataTableViewCell]
        
        for item in cellsToMove {
            /* Return cells to their pre-editing position and restore opaque color */
            UIView.animateWithDuration(0.3, animations: {() in
                item.transform = CGAffineTransformIdentity
                if item !== editingCell {
                    item.alpha = 1.0
                }
            })
        }
    }    
    
}

// MARK: - UIScrollViewDelegate methods

extension StandardDeviationVC {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        pullDownGestureActive = scrollView.contentOffset.y <= 0.0
        placeholderTableCell.backgroundColor = UIColor.redColor() // make the placeholder cell distinct for debugging
        
        if pullDownGestureActive {
            /* User has pulled downward at the top of the table, add the placeholder cell */
            
            dataTableView.insertSubview(placeholderTableCell, atIndex: 0)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y
        
        if pullDownGestureActive && scrollView.contentOffset.y <= 0.0 {
            /* Re-position the placeholder cell as the user scrolls */
            placeholderTableCell.frame = CGRect(x: 0, y: -dataTableView.rowHeight,
                                                width: dataTableView.frame.size.width, height: dataTableView.rowHeight)
            
            // TODO: Fix the crash caused by trying to access datumTextField.text
            //placeholderTableCell.datumTextField.text = -scrollViewContentOffsetY > dataTableView.rowHeight ? "Release to add the cell" : "Pull to create a data entry cell"
            
            /* Give the placeholder cell a fade-in effect */
            placeholderTableCell.alpha = min(1.0, (-1.0) * scrollViewContentOffsetY / dataTableView.rowHeight)
        } else {
            pullDownGestureActive = false
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        /* If the scroll-down gesture was far enough, add the placeholder cell to the collection of items in the table view */
        if pullDownGestureActive && (-1.0) * scrollView.contentOffset.y > dataTableView.rowHeight {
            // TODO: Insert a new cell into the table
            addDataTableCell()
        }
        pullDownGestureActive = false
        placeholderTableCell.removeFromSuperview()
    }
}

// MARK: - Close the keyboard when the user taps outside the editng field

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
