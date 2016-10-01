//
//  ViewController.swift
//  MSGInABottle
//
//  Created by Sahil Jain on 10/1/16.
//  Copyright © 2016 Internal Mini-Project Team. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var messageField: UITextField!
    var locManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMessageButton(_ sender: UIButton) {
        print("Sending message: " + messageField.text!)
        
        //request permission if we don't already have it
        locManager.requestWhenInUseAuthorization()
        
        // check location permissions
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            let currentLocation = locManager.location
            let lat = currentLocation?.coordinate.latitude
            let long = currentLocation?.coordinate.longitude
            print("lat: " + String(describing: lat) + " long: " + String(describing: long));
        }
    }

}
