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
    
    private func printMessages() {
        var request = URLRequest(url: URL(string: "http://52.41.253.190:9000/messages/?latitude=119.123123&longitude=120.1222")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    private func sendMessage(text: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
        var request = URLRequest(url: URL(string: "http://52.41.253.190:9000/send/")!)
        request.httpMethod = "POST"
        let dict = [
            "text": text,
            "latitude": lat,
            "longitude": long
                    ] as [String : Any]
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            print(String(bytes: request.httpBody!, encoding: String.Encoding.utf8))
        } catch {
            print("error serializing into json");
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
    
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                return
            }
    
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
            
            let alertController = UIAlertController(title: "Message Dropped!", message: text, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
            }
        }
        task.resume()
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
            print("lat: " + String(describing: lat!) + " long: " + String(describing: long!));
            sendMessage(text: messageField.text!, lat: lat!, long: long!)
        }
    }

}
