//
//  RandomNumberVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/18/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class RandomNumberVC: UIViewController {
    
    // MARK: - Properties
    
    var currentMode: StatDistributions!
    
    // MARK: - Outlets
    
    @IBOutlet var distributionSelectionControl: UISegmentedControl!
    @IBOutlet var randomNumberLabel: UILabel!
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Configure the segmented control */
        distributionSelectionControl.setTitle(StatDistributions.normal.rawValue, forSegmentAtIndex: StatDistributions.allOptions.indexOf(StatDistributions.normal)!)
        distributionSelectionControl.setTitle(StatDistributions.uniform.rawValue, forSegmentAtIndex: StatDistributions.allOptions.indexOf(StatDistributions.uniform)!)
        distributionSelectionControl.setTitle(StatDistributions.integerVals.rawValue, forSegmentAtIndex: StatDistributions.allOptions.indexOf(StatDistributions.integerVals)!)
        
        /* Set the UI according to the current mode */
        currentMode = StatDistributions.allOptions[distributionSelectionControl.selectedSegmentIndex]
        updateInputControlsByMode(currentMode)
    }
    
    // MARK: - Detect a shake gesture
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if event?.subtype == UIEventSubtype.MotionShake {
            
            print("Device was shaken")
            
            let randomNumber = Int(arc4random_uniform(UInt32(100)))
            print(randomNumber)

        }
    }
    
    // MARK: - Helpers
    func updateInputControlsByMode(updatedMode: StatDistributions!) {
        
        randomNumberLabel.text = "Shake It"
        
        switch updatedMode! {
        case .normal :
            leftLabel.text = "\nMean: "
            rightLabel.text = "Standard \nDeviation: "
            randomNumberLabel.text = String(StatisticsFunctions.swift_randomNormal(0, sd: 1))
            
        case .uniform :
            setMaxMinLabels()
            randomNumberLabel.text = String(StatisticsFunctions.swift_randomUniform(-100, max: 100))
            
        case .integerVals :
            setMaxMinLabels()
            randomNumberLabel.text = String(StatisticsFunctions.swift_randomInt(-100, max: 100))
        }
        
    }
    
    func setMaxMinLabels() {
        leftLabel.text = "Minimum Value"
        rightLabel.text = "Maximum Value"
        
    }

    
    // MARK: - Actions
    @IBAction func doneTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func modeChangedByTap(sender: UISegmentedControl) {
        
        self.currentMode = StatDistributions.allOptions[sender.selectedSegmentIndex]
        updateInputControlsByMode(self.currentMode)
    }

}


extension RandomNumberVC {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}