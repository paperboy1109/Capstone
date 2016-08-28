//
//  CalculatorVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/28/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController {

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

}


extension CalculatorVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}