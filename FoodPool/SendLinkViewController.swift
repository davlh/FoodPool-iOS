//
//  SendLinkViewController.swift
//  FoodPool
//
//  Created by David Lee-Heidenreich on 11/12/16.
//  Copyright © 2016 David Lee-Heidenreich. All rights reserved.
//

import UIKit
import MessageUI

class SendLinkViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var restaurant: String!
    var url: NSURL!
    var returnTime: NSDate!
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var messageTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        title = "Send out this link"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        instructionsLabel.text = "Cool! Now, just let your dorm know that you're going to \(restaurant). Here's a message we wrote for you, feel free to modify it. Tap copy message once you're done."
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateString = dateFormatter.stringFromDate(returnTime)
        
        messageTextView.text = "Hey all,\n\nI'm going to \(restaurant) right now. I'll be back around \(dateString).  If any of y'all want anything, fill out this order form and I'll grab it for you.\n\nLink: \(url.absoluteString)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailButtonPressed() {
        let emailController = MFMailComposeViewController()
        emailController.mailComposeDelegate = self
        emailController.setSubject("Place Orders for \(restaurant)")
        emailController.setMessageBody(messageTextView.text, isHTML: false)
        presentViewController(emailController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func copyButtonPressed() {
        UIPasteboard.generalPasteboard().string = messageTextView.text
        let alertController = UIAlertController(title: "Copied message to clipboard!", message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showOrdersButtonPressed() {
        let ordersViewController = OrdersViewController(style: .Grouped)
        navigationController?.pushViewController(ordersViewController, animated: true)
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
