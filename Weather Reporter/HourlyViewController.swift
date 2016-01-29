//
//  HourlyViewController.swift
//  Weather Reporter
//
//  Created by Prasad Sawant on 1/28/16.
//  Copyright © 2016 Prasad Sawant. All rights reserved.
//

import UIKit

class HourlyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var hourlyArray: NSArray!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CustomTableCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell_daily")
        
        hourlyArray = NSUserDefaults.standardUserDefaults().objectForKey("hourlyData") as! NSArray!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 400
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourlyArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TableCellTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell_daily") as! TableCellTableViewCell
        
        let jsonHourly = hourlyArray[indexPath.row] as! Dictionary<String, AnyObject>
        
        cell.labelTitle.text = "Hour # " + String(indexPath.row + 1)
        cell.labelTemperature.text = String(jsonHourly["temperature"]! as! Double) + "\u{00B0}F"
        cell.labelDewPoint.text = String(jsonHourly["dewPoint"]! as! Double) + "\u{00B0}F"
        cell.labelPressure.text = String(jsonHourly["pressure"]!) + "mb"
        cell.labelHumidity.text = String(jsonHourly["humidity"]! as! Double)
        cell.labelWindSpeed.text = String(jsonHourly["windSpeed"]! as! Double) + "mph"
        
        return cell
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
