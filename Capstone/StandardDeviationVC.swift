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
    
    let pinchGestureRecognizer = UIPinchGestureRecognizer()
    var pinchGestureActive = false
    var initialTouchPoints: TouchPoints!
    var addNewCellByPinch = false
    
    var upperCellIndex = -100
    var lowerCellIndex = -100
    
    var pullDownGestureActive = false
    
    // MARK: - Outlets
    
    @IBOutlet var dataTableView: UITableView!
    
    @IBOutlet var stDevTitleLabel: UILabel!
    @IBOutlet var stDevAnswerLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinchGestureRecognizer.addTarget(self, action: #selector(StandardDeviationVC.userDidPinch(_:)))
        dataTableView.addGestureRecognizer(pinchGestureRecognizer)
        
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
        print("Here are the data table entries respective double values:")
        for item in dataTableEntries {
            print("-")
            print(item.datumText)
            print(item.datumDoubleValue)
        }
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DatumCell", forIndexPath: indexPath) as! DataTableViewCell
        
        cell.delegate = self
        // TODO: Add data to the cell
        cell.datum = dataTableEntries[indexPath.row]
        
        return cell
    }
    
    
    
}

// MARK: - Delegate methods for the custom cell class

extension StandardDeviationVC: DataTableViewCellDelegate {
    
    func cellDidBeginEditing(editingCell: DataTableViewCell) {
        
        print("\n *** cellDidBeginEditing *** ")
        print("dataTableView.contentOffset: \(dataTableView.contentOffset)")
        print("editingCell.frame.origin.y: \(editingCell.frame.origin.y)")
        
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
    
}

// MARK: - UIScrollViewDelegate methods

extension StandardDeviationVC {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        pullDownGestureActive = scrollView.contentOffset.y <= 0.0
        
        if dataTableEntries.count <= 2 {
            
            if pullDownGestureActive {
                placeholderTableCell.backgroundColor = UIColor.redColor() // make the placeholder cell distinct for debugging
                /* User has pulled downward at the top of the table, add the placeholder cell */
                dataTableView.insertSubview(placeholderTableCell, atIndex: 0)
            }
        }
        
        //        else {
        //            if pullDownGestureActive {
        //                print("A pull-down drag has cued the calculation of a data summary ")
        //                StatisticsFunctions.swift_sd(dataTableEntries)
        //            }
        //        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let scrollViewContentOffsetY = scrollView.contentOffset.y
        
        if dataTableEntries.count <= 2 && pullDownGestureActive && scrollView.contentOffset.y <= 0.0 {
            /* Re-position the placeholder cell as the user scrolls */
            placeholderTableCell.frame = CGRect(x: 0, y: -dataTableView.rowHeight,
                                                width: dataTableView.frame.size.width, height: dataTableView.rowHeight)
            
            // TODO: Fix the crash caused by trying to access datumTextField.text
            //placeholderTableCell.datumTextField.text = -scrollViewContentOffsetY > dataTableView.rowHeight ? "Release to add the cell" : "Pull to create a data entry cell"
            
            /* Give the placeholder cell a fade-in effect */
            placeholderTableCell.alpha = min(1.0, (-1.0) * scrollViewContentOffsetY / dataTableView.rowHeight)
            
        } else if pullDownGestureActive && scrollView.contentOffset.y <= 0.0 {
            
            /* Instead of adding a new data and a new cell, summarize the data */
            print("A pull-down drag has cued the calculation of a data summary ")
            
            /* Check that all values are valid (Doubles) */
            // TODO: Create an alert if there are invalid elements
            let currentData = StatisticsFunctions.getDataTableDataAsArrayOfDoubles(dataTableEntries)
            print(StatisticsFunctions.swift_sd(currentData))
            stDevAnswerLabel.text = String(StatisticsFunctions.swift_sd(currentData))
            
        } else {
            pullDownGestureActive = false
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        /* If the scroll-down gesture was far enough, add the placeholder cell to the collection of items in the table view */
        if dataTableEntries.count <= 2 && pullDownGestureActive && (-1.0) * scrollView.contentOffset.y > dataTableView.rowHeight {
            // TODO: Insert a new cell into the table
            addDataTableCell()
        } else {
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
                cell.backgroundColor = UIColor.purpleColor()
            }
            if viewContainsPoint(cell, point: initialTouchPoints.lower) {
                lowerCellIndex = i
                cell.backgroundColor = UIColor.purpleColor()
            }
        }
        
        /* Are the cells neighbors? */
        if abs(upperCellIndex - lowerCellIndex) == 1 {
            
            pinchGestureActive = true
            
            /* Insert the placeholder cell */
            let precedingCell = allVisibleCells[upperCellIndex]
            
            placeholderTableCell.frame = CGRectOffset(precedingCell.frame, 0.0, dataTableView.rowHeight / 2.0)
            placeholderTableCell.backgroundColor = precedingCell.backgroundColor
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
