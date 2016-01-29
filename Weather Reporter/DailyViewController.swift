//
//  DailyViewController.swift
//  Weather Reporter
//
//  Created by Prasad Sawant on 1/27/16.
//  Copyright © 2016 Prasad Sawant. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let date = NSDate()
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    var components: NSDateComponents!
    var dayNo: Int!
    var day: String = ""
    
    var dailyArray: NSArray!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CustomTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell_daily")
        
        dailyArray = NSUserDefaults.standardUserDefaults().objectForKey("dailyData") as! NSArray!
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dailyArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        components = calendar!.components(.Weekday, fromDate: date)
        dayNo = components.weekday
        
        switch(dayNo) {
        case 1:
            day = "Sunday"
            break;
            
        case 2:
            day = "Monday"
            break;
            
        case 3:
            day = "Tuesday"
            break;
            
        case 4:
            day = "Wednesday"
            break;
            
        case 5:
            day = "Thursday"
            break;
            
        case 6:
            day = "Friday"
            break;
            
        case 7:
            day = "Saturday"
            break;
        default:
            day = ""
        }
        
        if dayNo == 7 {
            dayNo = 1
        }
        else {
            dayNo = dayNo + 1
        }
        
        let cell:TableCellTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell_daily") as! TableCellTableViewCell
        
        let jsonDaily = dailyArray[indexPath.row] as! Dictionary<String, AnyObject>
        
        cell.labelTitle.text = String(day)
        cell.labelTemperature.text = String(jsonDaily["temperatureMin"]! as! Double) + "\u{00B0}F"
        cell.labelDewPoint.text = String(jsonDaily["dewPoint"]! as! Double) + "\u{00B0}F"
        cell.labelPressure.text = String(jsonDaily["pressure"]!) + "mb"
        cell.labelHumidity.text = String(jsonDaily["humidity"]! as! Double)
        cell.labelWindSpeed.text = String(jsonDaily["windSpeed"]! as! Double) + "mph"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400
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
