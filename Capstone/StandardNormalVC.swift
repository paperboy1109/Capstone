//
//  StandardNormalVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/5/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class StandardNormalVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // MARK: - Actions
    
    @IBAction func doneTapped(sender: AnyObject) {
        
//        let utilitiesMenu = self.storyboard!.instantiateViewControllerWithIdentifier("UtilitiesMenu") as! UtilitiesVC
//        self.presentViewController(utilitiesMenu, animated: true, completion: nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
