//
//  ViewController.swift
//  Weather Reporter
//
//  Created by Prasad Sawant on 1/21/16.
//  Copyright © 2016 Prasad Sawant. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var ivTemperature: UIImageView!
    @IBOutlet weak var ivPressure: UIImageView!
    @IBOutlet weak var ivDewPoint: UIImageView!
    @IBOutlet weak var ivHumidity: UIImageView!
    @IBOutlet weak var ivWindSpeed: UIImageView!
    
    @IBOutlet weak var lbTemperature: UILabel!
    @IBOutlet weak var lbPressure: UILabel!
    @IBOutlet weak var lbDewPoint: UILabel!
    @IBOutlet weak var lbHumidity: UILabel!
    @IBOutlet weak var lbWindSpeed: UILabel!
    
    var jsonCurrently: Dictionary<String, AnyObject>!
    var jsonDay: Dictionary<String, AnyObject>!
    var jsonHour: Dictionary<String, AnyObject>!
    
    @IBOutlet weak var dayForecastButton: UIButton!
    @IBOutlet weak var hourForecastButton: UIButton!
    
    struct Constants {
        static let urlString = "https://api.forecast.io/forecast/e22dd680d4a3d0d11ab8ef37404eee5e/"
        static let TAG = "ViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(Constants.TAG + " viewDidLoad()")
        
        let nsUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if nsUserDefaults.objectForKey("dailyData") != nil {
            nsUserDefaults.removeObjectForKey("dailyData")
        }
        
        if nsUserDefaults.objectForKey("hourlyData") != nil {
            nsUserDefaults.removeObjectForKey("hourlyData")
        }
        
        /*if nsUserDefaults.objectForKey("current_temperature") != nil &&
        nsUserDefaults.objectForKey("current_pressure") != nil &&
        nsUserDefaults.objectForKey("current_dew_point") != nil &&
        nsUserDefaults.objectForKey("current_humidity") != nil &&
            nsUserDefaults.objectForKey("current_wind_speed") != nil {
                updateUI()
        }*/
        
        
        
        
    }
    
    @IBAction func weatherUpdateButtonPressed(sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() {
            
            let spinnerActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spinnerActivity.color = UIColor(colorLiteralRed: 39.0, green: 174.0, blue: 96.0, alpha: 1.0)
            spinnerActivity.labelText = "Pease wait!"
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        } else {
            print("No internet!")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let currentLocation: CLLocation = locations[0]
        
        let latitude: CLLocationDegrees = currentLocation.coordinate.latitude
        let longitude: CLLocationDegrees = currentLocation.coordinate.longitude
        
        locationManager.stopUpdatingLocation()
        
        getWeatherUpdates(latitude, longitude: longitude)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func getWeatherUpdates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let url = NSURL(string: Constants.urlString + String(latitude) + "," + String(longitude))!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            
            if let urlContent = data {
                
                do {
                    
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
                    
                    self.jsonCurrently = (jsonObject)["currently"] as! Dictionary<String, AnyObject>
                    self.jsonDay = (jsonObject)["daily"] as! Dictionary<String, AnyObject>
                    self.jsonHour = (jsonObject)["hourly"] as! Dictionary<String, AnyObject>
                    
                    let dailyData = self.jsonDay["data"]! as! NSArray
                    NSUserDefaults.standardUserDefaults().setObject(dailyData, forKey: "dailyData")
                    
                    let hourlyData = self.jsonHour["data"]! as! NSArray
                    NSUserDefaults.standardUserDefaults().setObject(hourlyData, forKey: "hourlyData")
                    
                    
                    self.updateUI()
                    
                    
                } catch {
                    print("JSON serialization failed")
                }
            }
        }
        
        task.resume()
        
    }
    
    func updateUI() {
        
        NSUserDefaults.standardUserDefaults().setObject(self.jsonCurrently["temperature"]!, forKey: "current_temperature")
        NSUserDefaults.standardUserDefaults().setObject(self.jsonCurrently["pressure"]!, forKey: "current_pressure")
        NSUserDefaults.standardUserDefaults().setObject(self.jsonCurrently["dewPoint"]!, forKey: "current_dew_point")
        NSUserDefaults.standardUserDefaults().setObject(self.jsonCurrently["humidity"]!, forKey: "current_humidity")
        NSUserDefaults.standardUserDefaults().setObject(self.jsonCurrently["windSpeed"]!, forKey: "current_wind_speed")
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            
            self.ivTemperature.hidden = false
            self.ivPressure.hidden = false
            self.ivDewPoint.hidden = false
            self.ivHumidity.hidden = false
            self.ivWindSpeed.hidden = false
            
            self.dayForecastButton.hidden = false
            self.hourForecastButton.hidden = false
            
            self.lbTemperature.hidden = false
            self.lbTemperature.text = String(NSUserDefaults.standardUserDefaults().objectForKey("current_temperature") as! Double) + "\u{00B0}F"
            
            self.lbPressure.hidden = false
            self.lbPressure.text = String(NSUserDefaults.standardUserDefaults().objectForKey("current_pressure") as! Double) + "mb"
            
            self.lbDewPoint.hidden = false
            self.lbDewPoint.text = String(NSUserDefaults.standardUserDefaults().objectForKey("current_dew_point") as! Double) + "\u{00B0}F"
            
            self.lbHumidity.hidden = false
            self.lbHumidity.text = String(NSUserDefaults.standardUserDefaults().objectForKey("current_humidity") as! Double) + "%"
            
            self.lbWindSpeed.hidden = false
            self.lbWindSpeed.text = String(NSUserDefaults.standardUserDefaults().objectForKey("current_wind_speed") as! Double) + "mph"
            
        }
        
        
    }
    
    


}

