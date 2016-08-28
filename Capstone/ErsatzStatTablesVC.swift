//
//  ErsatzStatTablesVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 8/27/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class ErsatzStatTablesVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var lookupValueLabel: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var stepper: UIStepper!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.minimumValue = -6.0
        slider.maximumValue = 6.0
        slider.value = 0.0
        
        stepper.minimumValue = Double(slider.minimumValue)
        stepper.maximumValue = Double(slider.maximumValue)
        stepper.value = Double(slider.value)
        stepper.stepValue = 0.01
        
        
        
        lookupValueLabel.text = "\(slider.value)"
        
        
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
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func sliderMoved(sender: UISlider) {
        lookupValueLabel.text = "\(sender.value)"
        stepper.value = Double(sender.value)
    }
    
    
    
    @IBAction func stepperTapped(sender: UIStepper) {        
        slider.value = Float(sender.value)
        lookupValueLabel.text = "\(slider.value)"
    }
    
    
    
    
    
    
    
}

extension ErsatzStatTablesVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
