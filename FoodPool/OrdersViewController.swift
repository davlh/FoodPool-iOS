//
//  OrdersViewController.swift
//  FoodPool
//
//  Created by David Lee-Heidenreich on 11/12/16.
//  Copyright © 2016 David Lee-Heidenreich. All rights reserved.
//

import UIKit

struct OrderInfo {
    let name: String
    let order: String
    let total: Int
    let phone: String
    
    init(fromDictionary dictionary: Dictionary<String, AnyObject>) {
        name = dictionary["name"] as! String
        order = dictionary["food_order"] as! String
        total = dictionary["total"] as! Int
        phone = dictionary["phone"] as! String
    }
}

class OrdersViewController: UITableViewController {
    var orders = [OrderInfo]()
    let orderCellReuseIdentifier = "OrderCell"
    let moneyFormatter = NSNumberFormatter()
    var timer: NSTimer?
    
    override init(style: UITableViewStyle) {
        super.init(style: .Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: orderCellReuseIdentifier)
        
        moneyFormatter.numberStyle = .CurrencyStyle
        
        tableView.rowHeight = 72
        
        title = "Orders"        
        navigationItem.hidesBackButton = true

        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "updateOrders", userInfo: nil, repeats: true)
    }
    
    func updateOrders() {
        let defaultSession = NSURLSession.sharedSession()
        let url = NSURL(string: "http://foodpool.mybluemix.net/GetConfirmedOrders")!
        let request = NSMutableURLRequest(URL:url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "GET"
        
        let task = defaultSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options:[]) as! Dictionary<String, AnyObject>
            let orderDictionaries = json["orders"] as! Array<Dictionary<String, AnyObject>>
            self.orders.removeAll()
            for orderDictionary in orderDictionaries {
                let order = OrderInfo(fromDictionary: orderDictionary)
                self.orders.append(order)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData();
            })
            
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Orders you need to place"
        } else {
            return "Once you're back at the dorm, tap this button to let people know their orders are ready"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return orders.count
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(orderCellReuseIdentifier, forIndexPath: indexPath) as! OrderCellTableViewCell
            let order = orders[indexPath.row]
            
            cell.nameAndPhoneNumberLabel.text = "\(order.name) - \(order.phone)"
            cell.priceLabel.text = moneyFormatter.stringFromNumber(NSNumber(float: Float(order.total) / 100))
            cell.orderLabel.text = order.order
            
            return cell
        } else {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
            cell.textLabel!.text = "I'm back at the dorm";
            return cell;
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            sendArrivedToBackend()
        }
    }
    
    func sendArrivedToBackend() {
        let defaultSession = NSURLSession.sharedSession()
        let url = NSURL(string: "http://foodpool.mybluemix.net/PoolArrived")!
        let request = NSMutableURLRequest(URL:url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        
        let task = defaultSession.dataTaskWithRequest(request)
        task.resume();
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
