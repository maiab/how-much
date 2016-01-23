//
//  ViewController.swift
//  how much
//
//  Created by Maia Bittner on 1/17/16.
//
//

import UIKit
import CoreData


class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var creditTipControl: UISegmentedControl!
    @IBOutlet weak var cashField: UITextField!
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var cashView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set default total & credit card tip amounts
        creditLabel.text = "0.00"
        totalLabel.text = "0.00"
        
        // set default tip percentage (if exists)
        let defaults = NSUserDefaults.standardUserDefaults()
            var tipToSegmentIndex = [Int: Int]()
            tipToSegmentIndex = [0: 0, 15: 1, 18: 2, 20: 3]
            print(tipToSegmentIndex[defaults.integerForKey("Default Percentage")])
            self.creditTipControl.selectedSegmentIndex = tipToSegmentIndex[defaults.integerForKey("Default Percentage")]!

    }
    
    // run through every time bill amount is changed. calculates dollar amount of tips from percentages (for when using credit card)
    @IBAction func onEditingChanged(sender: AnyObject) {
        var billAmount = Double(0) // default value for bill
        
        // determine tip percentage amount
        var tipPercentages = [0,0.15,0.18,0.20]
        let tipPercentage = tipPercentages[creditTipControl.selectedSegmentIndex]
        if billField.text != "" {// annoyingly, this prevents an exception when bill is nil
            billAmount = Double(billField.text!)! // convert bill amount from string to decimal
        }
        let creditTip = billAmount * tipPercentage // caculate tip in dollars from percentage
        let totalCreditBillTotal = billAmount + creditTip // calculate total
        
        // reflect bill and total in view
        totalLabel.text = String(format: "$%.2f", totalCreditBillTotal)
        creditLabel.text = String(format: "$%.2f", creditTip)
        
        
        // cash tip calculations
        var cashOnHand = Double(0) // default value for amount of cash user has on hand
        if cashField.text != "" {
            cashOnHand = Double(cashField.text!)! // annoyingly, this prevents an exception when amount of cash is nil
        }

        
        var calculatedPercentageTip = Double(0)
        calculatedPercentageTip = ((cashOnHand - billAmount ) / billAmount)*100 // infer percentage tip based on amount of cash on hand
        
        // color percentage tip to let the user know if they have enough cash to leave a good tip or not
        if cashOnHand < billAmount {
            cashLabel.textColor = UIColor.redColor()
        }
        else if calculatedPercentageTip < 15 {
            cashLabel.textColor = UIColor.yellowColor()
        }
        else if 15 ... 25 ~= calculatedPercentageTip {
            cashLabel.textColor = UIColor.greenColor()
        }
        else {
            cashLabel.textColor = UIColor.blackColor()
        }
        
        // set cash percentage amounts and total amounts in view
        if cashField.text != "" {
            cashLabel.text = String(format: "%.1f", calculatedPercentageTip) + "%"
            totalLabel.text = String(format: "$%.2f", cashOnHand)
        }
        else {
            cashLabel.textColor = UIColor.blackColor()
            cashLabel.text = "0.0%"
            totalLabel.text = billField.text
            totalLabel.text = String(format: "$%.2f", totalCreditBillTotal)
        }

    }
    
    @IBAction func onPercentControlValueChange(sender: AnyObject) {
        cashField.text = ""
        
        UIView.animateWithDuration(0.5, animations: {
            // shrink cash box (if expanded)
            self.cashView.frame.size.height = 155
            self.cashView.center.y = 465
            
            // expand credit box to cover total
            self.creditView.frame.size.height = 250
            self.creditView.center.y = 240
        })
    }

    @IBAction func onCashFieldTouch(sender: AnyObject) {
        creditLabel.text = "0.00"
        UIView.animateWithDuration(0.5, animations: {
            //shrink credit box (if expanded)
            self.creditView.frame.size.height = 155
            self.creditView.center.y = 210
            
            //expand cash box to cover total
            self.cashView.frame.size.height = 250
            self.cashView.center.y = 440
        })
    }

    // TODO: Change current tip percentage on setting default tip percentage
    // Allow users to set default tip percentage that will persist on new app launch
    @IBAction func touchSettings(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let alertController = UIAlertController(title: nil, message: "Do you want to save a default tip percentage for next time?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        let actionClear = UIAlertAction(title: "Clear default", style: .Default) { (action) in
            defaults.setInteger(0, forKey: "Default Percentage")
            
        }
        alertController.addAction(actionClear)
        
        let action15 = UIAlertAction(title: "15%", style: .Default) { (action) in
            defaults.setInteger(15, forKey: "Default Percentage")

        }
        alertController.addAction(action15)
        
        let action18 = UIAlertAction(title: "18%", style: .Default) { (action) in
            defaults.setInteger(18, forKey: "Default Percentage")
            
        }
        alertController.addAction(action18)
        
        let action20 = UIAlertAction(title: "20%", style: .Default) { (action) in
            defaults.setInteger(20, forKey: "Default Percentage")
            
        }
        alertController.addAction(action20)
        
        
        self.presentViewController(alertController, animated: true) {
        }
        
    }
    
    

    @IBAction func onTap(sender: AnyObject) {
        // tapping most anywhere on the screen shrinks keyboard
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

