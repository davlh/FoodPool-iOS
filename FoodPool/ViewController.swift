//
//  ViewController.swift
//  FoodPool
//
//  Created by David Lee-Heidenreich on 11/11/16.
//  Copyright © 2016 David Lee-Heidenreich. All rights reserved.
//

import UIKit
struct FoodPool {
    var restaurant: String?
    var timeOfReturn: NSDate?
    var numOrders: Int?
    var pickupLocation: String?
    
    func convertToDict() -> Dictionary<String, AnyObject> {
        var poolInfoDict: [String:AnyObject] = Dictionary()
        poolInfoDict["restaurant"] = restaurant
        poolInfoDict["return_time"] = timeOfReturn?.timeIntervalSince1970
        poolInfoDict["num_orders"] = numOrders
        poolInfoDict["pickup_location"] = pickupLocation
        return poolInfoDict
        
    }
    
}

class ViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
   
    let restaurantPickerView = UIPickerView()
    let restaurantNames = ["In N Out", "Chipotle"]
    @IBOutlet var restaurantTextField: UITextField!
    let timeReturnPickerView = UIDatePicker()
    @IBOutlet var returnTimeTextField: UITextField!
    @IBOutlet var numOrdersTextField: UITextField!
    @IBOutlet var pickupLocationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantPickerView.dataSource = self
        restaurantPickerView.delegate = self
        restaurantTextField?.inputView = restaurantPickerView
        timeReturnPickerView.datePickerMode = .DateAndTime
        returnTimeTextField?.inputView = timeReturnPickerView
        timeReturnPickerView.addTarget(self, action: "datePickerEdited", forControlEvents: .ValueChanged)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return restaurantNames.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return restaurantNames[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        restaurantTextField.text = restaurantNames[row]
    }
    
    func datePickerEdited() {
        returnTimeTextField.text = timeReturnPickerView.date.description
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var foodPool = FoodPool()
        foodPool.restaurant = restaurantTextField?.text
        foodPool.timeOfReturn = timeReturnPickerView.date
        foodPool.numOrders = Int(numOrdersTextField!.text!)
        foodPool.pickupLocation = pickupLocationTextField!.text
        print(foodPool.convertToDict());
        let foodPoolDict: NSDictionary = foodPool.convertToDict();
        
        
        let defaultSession = NSURLSession.sharedSession()
        let url = NSURL(string: "http://foodpool.mybluemix.net/CreatePool")!
        let request = NSMutableURLRequest(URL:url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(foodPoolDict, options: [])
        request.HTTPMethod = "POST"
        
        let task = defaultSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            let linkDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options:[] )
            print(linkDictionary)
        
        }
        task.resume()
    }
    

}

