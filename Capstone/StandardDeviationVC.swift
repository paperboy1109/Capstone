//
//  StandardDeviationVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class StandardDeviationVC: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet var dataTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataTableView.dataSource = self
        dataTableView.delegate = self
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

        
        return cell
    }



}
