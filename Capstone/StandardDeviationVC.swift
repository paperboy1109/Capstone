//
//  StandardDeviationVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import CoreData

class StandardDeviationVC: UIViewController {
    
    // MARK: - Properties
    var dataTableEntries: [DataTableDatum]!
    
    let placeholderTableCell = DataTableViewCell()
    
    let pinchGestureRecognizer = UIPinchGestureRecognizer()
    var pinchGestureActive = false
    var initialTouchPoints: TouchPoints!
    var addNewCellByPinch = false
    
    var upperCellIndex = -100
    var lowerCellIndex = -100
    
    let themeColor = UIColor(red: 96.0/255.0, green: 237.0/255.0, blue: 179.0/255.0, alpha: 1.0)
    
    var pullDownGestureActive = false
    
    var sharedContext = CoreDataStack.sharedInstance().managedObjectContext
    var fetchedResultController: NSFetchedResultsController!
    
    // MARK: - Outlets
    
    @IBOutlet var bannerTextLabel: UILabel!
    @IBOutlet var dataTableView: UITableView!
    @IBOutlet var dividerView: UIView!
    @IBOutlet var bottomView: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for debugging
        //deleteAllPersistedData()
        
        dividerView.backgroundColor = themeColor
        bottomView.backgroundColor = themeColor
        
        pinchGestureRecognizer.addTarget(self, action: #selector(StandardDeviationVC.userDidPinch(_:)))
        dataTableView.addGestureRecognizer(pinchGestureRecognizer)
        
        dataTableView.dataSource = self
        dataTableView.delegate = self
        dataTableView.rowHeight = 64.0
        
        dataTableEntries = []
        
        /* Configure the initial banner text */
        bannerTextLabel.font = UIFont(name: "PTSans-Regular", size: 21)
        bannerTextLabel.textAlignment = NSTextAlignment.Center
        bannerTextLabel.textColor = UIColor.darkGrayColor()
        
        /* Create some example data */
        let sampleData = ["1.0", "2.0", "3.0", "4.0", "5.0", "6.0", "7.0"]
        for item in sampleData {
            let newDatum = DataTableDatum(textFieldText: item)
            dataTableEntries.append(newDatum)
        }
        
        /* Persist this sample data set */
//        for item in dataTableEntries {
//            
//            let coreDataDatum = NSEntityDescription.insertNewObjectForEntityForName("Datum", inManagedObjectContext: self.sharedContext) as! Datum
//            
//            coreDataDatum.text = item.datumText
//            coreDataDatum.numericalValue = NSNumber(double: item.datumDoubleValue!)
//            
//        }
        refreshPersistedData()
        
        updateBannerMessage()
        
        loadData()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        refreshPersistedData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ToDataSummary" {
            
            if let dataSummaryVC = segue.destinationViewController as? DataSummaryVC {
                
                guard self.dataTableEntries != nil else {
                    return
                }
                
                dataSummaryVC.dataTableEntries = self.dataTableEntries!
            }
            
        }
    }
    
    
    // MARK: - Actions
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func plusMinusTapped(sender: UIButton) {
        
        /* Access the cell that contains the button */
        var targetIndexPath: NSIndexPath!
        
        let currentButton = sender
        
        if let buttonStackView = currentButton.superview {
            
            if let buttonSuperview = buttonStackView.superview {
                
                if let currentCell = buttonSuperview.superview as? DataTableViewCell {
                    
                    /* Keep track of the cell's index */
                    targetIndexPath = dataTableView.indexPathForCell(currentCell)
                    
                    /* Update the model with the sign change */
                    var currentDatum = dataTableEntries[sender.tag]
                    currentDatum.changeSignOfDatum()
                    
                    /* Update the cell */
                    currentCell.datum = currentDatum
                    
                    /* Update the model */
                    dataTableEntries[targetIndexPath.row] = currentDatum
                    
                    /* Animate constraint changes now that the moreInfoTextView has changed size and content */
                    UIView.animateWithDuration(0.1) {
                        currentCell.contentView.layoutIfNeeded()
                    }
                    
                    /* Force the table view to update */
                    dataTableView.beginUpdates()
                    dataTableView.endUpdates()
                    
                    /* Sync the persisted data */
                    refreshPersistedData()
                }
            }
        }
        
    }
    
    
    // MARK: - Helpers
    private func blockGarbageIn(alertTitle: String, alertDescription: String, tableCell: DataTableViewCell?) {
        
        let alertView = UIAlertController(title: "\(alertTitle)", message: "\(alertDescription)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            
            // Make UI changes
            if let cell = tableCell as DataTableViewCell! {
                self.deleteDataTableCell(cell.datum!)
            }
            
        }) )
        
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func updateBannerMessage() {
        
        if dataTableEntries.count <= 2 {
            bannerTextLabel.text = "Pull downward to add data."
        } else {
            bannerTextLabel.text = "Pull downward to summarize the data. Pinch outward to add new data."
        }
    }
    
    func refreshPersistedData() {
        
        deleteAllPersistedData()
        
        for item in dataTableEntries {
            
            let coreDataDatum = NSEntityDescription.insertNewObjectForEntityForName("Datum", inManagedObjectContext: self.sharedContext) as! Datum
            
            coreDataDatum.text = item.datumText
            coreDataDatum.numericalValue = NSNumber(double: item.datumDoubleValue!)
            
        }
        
        CoreDataStack.sharedInstance().saveContext()
    }
    
}

// MARK: - Delegates for the table view

extension StandardDeviationVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        if let sections = fetchedResultController.sections {
//            return sections.count
//        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataTableEntries.count
        
//        if let sections = fetchedResultController.sections {
//            let currentSection = sections[section]
//            return currentSection.numberOfObjects
//        }
//        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DatumCell", forIndexPath: indexPath) as! DataTableViewCell
        
        //let datum = fetchedResultController.objectAtIndexPath(indexPath) as! Datum
        //let dataTableDatum = DataTableDatum(textFieldText: datum.text!)
        
        cell.delegate = self
        cell.backgroundColor = UIColor.whiteColor()
        cell.datum = dataTableEntries[indexPath.row]//dataTableDatum //dataTableEntries[indexPath.row]
        cell.plusMinusButton.tag = indexPath.row
        
        return cell
    }
    
    /* Incomplete pinch gestures will change background colors; give the user a way to return the color to white */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.whiteColor()
    }
    
    
}

// MARK: - Delegate methods for the custom cell class

extension StandardDeviationVC: DataTableViewCellDelegate {
    
    func cellDidBeginEditing(editingCell: DataTableViewCell) {
        
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
        
        /* Don't insert empty cells into the table */
        if editingCell.datum!.datumText == "" {
            deleteDataTableCell(editingCell.datum!)
        }
        
        /* Update the data model if the cell has valid data */
        
        if let newDatum = editingCell.datum?.datumText {

            editingCell.datum?.updateDatumValue()
        }
        
        if let newDatumValue = editingCell.datum?.datumDoubleValue {            
            
        } else {
            editingCell.backgroundColor = UIColor.redColor()
            blockGarbageIn("Invalid data", alertDescription: "Check that the value you entered is a valid number", tableCell: editingCell)
        }
        
        
        
    }
    
    func addDataTableCell() {
        /* By default, add a cell to the top of the table */
        addDataTableCellAtIndex(0)
        
    }
    
    func addDataTableCellAtIndex(index: Int) {
        
        let newDatum = DataTableDatum(textFieldText: "")
        dataTableEntries.insert(newDatum, atIndex: index)
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
        
        updateBannerMessage()
    }
    
    func deleteDataTableCell(itemToRemove: DataTableDatum) {
        
        let indexOfItemToRemove = (dataTableEntries as NSArray).indexOfObject(itemToRemove)
        
        guard indexOfItemToRemove != NSNotFound else {
            return
        }
        
        dataTableEntries.removeAtIndex(indexOfItemToRemove)
        
        /* Remove the persisted datum as well */
        //let indexPathOfItemToDelete = NSIndexPath(forRow: indexOfItemToRemove, inSection: 0)
        //let datumToDelete = fetchedResultController.objectAtIndexPath(indexPathOfItemToDelete) as! Datum
        //self.sharedContext.deleteObject(datumToDelete)
        //CoreDataStack.sharedInstance().saveContext()
        
        // Complete refresh
//        self.deleteAllPersistedData()
//        self.refreshPersistedData()
        
        
        /* Update the table view */
        dataTableView.beginUpdates()
        let indexPathOfItemToDelete = NSIndexPath(forRow: indexOfItemToRemove, inSection: 0)
        dataTableView.deleteRowsAtIndexPaths([indexPathOfItemToDelete], withRowAnimation: .Automatic)
        dataTableView.endUpdates()
        
        updateBannerMessage()
    }
    
}

// MARK: - UIScrollViewDelegate methods

extension StandardDeviationVC {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        updateBannerMessage()
        
        pullDownGestureActive = scrollView.contentOffset.y <= 0.0
        
        if dataTableEntries.count <= 2 {
            
            if pullDownGestureActive {
                placeholderTableCell.backgroundColor = themeColor
                /* User has pulled downward at the top of the table, add the placeholder cell */
                dataTableView.insertSubview(placeholderTableCell, atIndex: 0)
            }
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y
        
        if dataTableEntries.count <= 2 && pullDownGestureActive && scrollView.contentOffset.y <= 0.0 {
            /* Re-position the placeholder cell as the user scrolls */
            placeholderTableCell.frame = CGRect(x: 0, y: -dataTableView.rowHeight,
                                                width: dataTableView.frame.size.width, height: dataTableView.rowHeight)
            
            /* Give the placeholder cell a fade-in effect */
            placeholderTableCell.alpha = min(1.0, (-1.0) * scrollViewContentOffsetY / dataTableView.rowHeight)
            
        } else if pullDownGestureActive && scrollView.contentOffset.y <= 0.0 {
            
            pullDownGestureActive = true
            
        } else {
            pullDownGestureActive = false
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        /* If the scroll-down gesture was far enough, add the placeholder cell to the collection of items in the table view */
        if dataTableEntries.count <= 2 && pullDownGestureActive && (-1.0) * scrollView.contentOffset.y > dataTableView.rowHeight {
            
            addDataTableCell()
            updateBannerMessage()
            
        } else if pullDownGestureActive && (-1.0) * scrollView.contentOffset.y > dataTableView.rowHeight {
            
            /* Segue to the data summary scene */
            //let dataSummaryVC = self.storyboard!.instantiateViewControllerWithIdentifier("DataSummary") as! DataSummaryVC
            //self.presentViewController(dataSummaryVC, animated: true, completion: nil)
            updateBannerMessage()
            
            self.performSegueWithIdentifier("ToDataSummary", sender: nil)
            
            self.refreshPersistedData()
            
        }else {
            pullDownGestureActive = false
            placeholderTableCell.removeFromSuperview()
        }
    }
}

// MARK: - pinch-to-add methods

extension StandardDeviationVC {
    
    func userDidPinch(recognizer: UIPinchGestureRecognizer) {
        
        if recognizer.state == .Began {
            pinchStarted(recognizer)
        }
        if recognizer.state == .Changed && pinchGestureActive && recognizer.numberOfTouches() == 2 {
            pinchChanged(recognizer)
        }
        if recognizer.state == .Ended {
            pinchEnded(recognizer)
        }
    }
    
    func pinchStarted(recognizer: UIPinchGestureRecognizer) {
        
        initialTouchPoints = getNormalizedTouchPoints(recognizer)
        
        upperCellIndex = -100
        lowerCellIndex = -100
        
        let allVisibleCells = dataTableView.visibleCells  as! [DataTableViewCell]
        
        for i in 0..<allVisibleCells.count {
            let cell = allVisibleCells[i]
            if viewContainsPoint(cell, point: initialTouchPoints.upper) {
                upperCellIndex = i
                cell.backgroundColor = UIColor.lightGrayColor()
            }
            if viewContainsPoint(cell, point: initialTouchPoints.lower) {
                lowerCellIndex = i
                cell.backgroundColor = UIColor.lightGrayColor()
            }
        }
        
        /* Are the cells neighbors? */
        if abs(upperCellIndex - lowerCellIndex) == 1 {
            
            pinchGestureActive = true
            
            /* Insert the placeholder cell */
            let precedingCell = allVisibleCells[upperCellIndex]
            
            placeholderTableCell.frame = CGRectOffset(precedingCell.frame, 0.0, dataTableView.rowHeight / 2.0)
            placeholderTableCell.backgroundColor = themeColor //precedingCell.backgroundColor
            dataTableView.insertSubview(placeholderTableCell, atIndex: 0)
        }
        
    }
    
    func pinchChanged(recognizer: UIPinchGestureRecognizer) {
        
        let currentTouchPoints = getNormalizedTouchPoints(recognizer)
        
        /* Set the "size" of the pinch to be the smaller of the two distances the touch points have moved */
        let upperDelta = currentTouchPoints.upper.y - initialTouchPoints.upper.y
        let lowerDelta = initialTouchPoints.lower.y - currentTouchPoints.lower.y
        let delta = -min(0, min(upperDelta, lowerDelta))
        
        /* Re-position the cells to take the new cell into account */
        let visibleCells = dataTableView.visibleCells as! [DataTableViewCell]
        
        for i in 0..<visibleCells.count {
            
            let cell = visibleCells[i]
            
            if i <= upperCellIndex {
                cell.transform = CGAffineTransformMakeTranslation(0, -delta)
            }
            if i >= lowerCellIndex {
                cell.transform = CGAffineTransformMakeTranslation(0, delta)
            }
        }
        
        /* Make the new cell more interactive */
        let gapSize = delta * 2
        let maxGapSize = min(gapSize, dataTableView.rowHeight)
        placeholderTableCell.transform = CGAffineTransformMakeScale(1.0, maxGapSize / dataTableView.rowHeight)
        placeholderTableCell.datum?.datumText = gapSize > dataTableView.rowHeight ? "Release to add item" : "Pull apart to add item"
        placeholderTableCell.alpha = min(1.0, gapSize / dataTableView.rowHeight)
        
        /* Should the new cell be added? */
        addNewCellByPinch = gapSize > dataTableView.rowHeight
        
    }
    
    func pinchEnded(recognizer: UIPinchGestureRecognizer) {
        
        addNewCellByPinch = false
        
        /* Get rid of the placeholder cell */
        placeholderTableCell.transform = CGAffineTransformIdentity
        placeholderTableCell.removeFromSuperview()
        
        if pinchGestureActive {
            
            pinchGestureActive = false
            
            /* Remove the space that was added when animating the insertion of the placeholder cell */
            let visibleCells = self.dataTableView.visibleCells as! [DataTableViewCell]
            for cell in visibleCells {
                cell.transform = CGAffineTransformIdentity
            }
            
            /* Add a new cell to the table, and add the accompanying data structure */
            let indexOffset = Int(floor(dataTableView.contentOffset.y / dataTableView.rowHeight))
            addDataTableCellAtIndex(lowerCellIndex + indexOffset)
            
        } else {
            /* Return cells to their position before the pinch gesture occurred */
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: {() in
                let allVisibleCells = self.dataTableView.visibleCells as! [DataTableViewCell]
                for cell in allVisibleCells {
                    cell.transform = CGAffineTransformIdentity
                }
                }, completion: nil)
        }
        
    }
    
    // MARK: - Helpers
    /* Make sure that point1 is the higher of the two on screen */
    func getNormalizedTouchPoints(recognizer: UIGestureRecognizer) -> TouchPoints {
        
        var pointOne = recognizer.locationOfTouch(0, inView: dataTableView)
        var pointTwo = recognizer.locationOfTouch(1, inView: dataTableView)
        
        if pointOne.y > pointTwo.y {
            let temp = pointOne
            pointOne = pointTwo
            pointTwo = temp
        }
        return TouchPoints(upper: pointOne, lower: pointTwo)
    }
    
    /* Did a given point land within the frame ?*/
    func viewContainsPoint(view: UIView, point: CGPoint) -> Bool {
        let frame = view.frame
        return (frame.origin.y < point.y) && (frame.origin.y + (frame.size.height) > point.y)
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

// MARK: - CoreData delegate methods and helpers

extension StandardDeviationVC: NSFetchedResultsControllerDelegate {
    
    func loadData() {
        
        let fetchRequest = NSFetchRequest(entityName: "Datum")
        let sortDescriptors = NSSortDescriptor(key: "numericalValue", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        }
        catch {
            fatalError("Error in fetching records")
        }
    }
    
//    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        dataTableView.beginUpdates()
//    }
//    
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        switch type {
//        case NSFetchedResultsChangeType.Delete:
//            print("NSFetchedResultsChangeType.Delete detected")
//            if let deleteIndexPath = indexPath {
//                dataTableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
//            }
//        case NSFetchedResultsChangeType.Insert:
//            print("NSFetchedResultsChangeType.Insert detected")
//        case NSFetchedResultsChangeType.Move:
//            print("NSFetchedResultsChangeType.Move detected")
//        case NSFetchedResultsChangeType.Update:
//            print("NSFetchedResultsChangeType.Update detected")
//        }
//    }
//    
//    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        dataTableView.endUpdates()
//    }
    
    func deleteAllPersistedData() {
        
        let fetchRequest = NSFetchRequest(entityName: "Datum")
        
        do {
            
            let allPersistedData = try sharedContext.executeFetchRequest(fetchRequest) as! [Datum]
            
            for item in allPersistedData {
                sharedContext.deleteObject(item)
            }
            
        } catch {
            fatalError("Unable to delete persisted data")
        }
        
        CoreDataStack.sharedInstance().saveContext()
    }
    

}
