import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var messageTable: UITableView!
    
    var locManager = CLLocationManager()
    var unDroppedMessage = ""
    var messages: [String] = ["First message.", "Second message."]
    
    // MARK: Lifecycle Functions
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
    
    // MARK: Table Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
    // MARK: Actions
    @IBAction func dropMessageButton(_ sender: UIButton) {
        let dropMessageController = UIAlertController(
            title: "Create Message",
            message: "",
            preferredStyle: UIAlertControllerStyle.alert)
        let dropButton = UIAlertAction(
            title: "Drop",
            style: UIAlertActionStyle.default,
            handler: {(_) in
                let message = (dropMessageController.textFields!.first! as UITextField).text!
                if (message == "") {
                    let alertController = UIAlertController(
                        title: "Error",
                        message: "Message cannot be empty. Try again!",
                        preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(
                        title: "OK",
                        style: UIAlertActionStyle.default,
                        handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("message dropped: " + message)
                    self.unDroppedMessage = ""
                    self.dropMessage(message: message)
                }
        })
        let cancelButton = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler: {(_) in
                let message = (dropMessageController.textFields!.first! as UITextField).text!
                self.unDroppedMessage = message
        })
        dropMessageController.addTextField(configurationHandler: {(textField: UITextField!) in
            if (self.unDroppedMessage != "") {
                textField.text = self.unDroppedMessage
            } else {
                textField.placeholder = "Enter message here"
            }
            textField.borderStyle = UITextBorderStyle.roundedRect
        })
        dropMessageController.addAction(dropButton)
        dropMessageController.addAction(cancelButton)
        dropMessageController.preferredAction = dropButton
        self.present(dropMessageController, animated: true, completion: nil)
    }
    
    // MARK: Utility
    private func dropMessage(message: String) {
        // Request permission if we don't already have it.
        locManager.requestWhenInUseAuthorization()
        
        // Check location permissions.
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse
            || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            let currentLocation = locManager.location
            let lat = currentLocation?.coordinate.latitude
            let long = currentLocation?.coordinate.longitude
            print("lat: " + String(describing: lat!)
                + " long: " + String(describing: long!));
            self.makeRequestToDropMessage(text: message, lat: lat!, long: long!)
        }
        
    }
    
    private func makeRequestToDropMessage(text: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
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
            guard let data = data, error == nil else {  // Check for fundamental networking  error.
                print("error=\(error)")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {  // Check for HTTP errors.
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")

            let alertController = UIAlertController(title: "Message Dropped!", message: text, preferredStyle: .alert)


            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            alertController.addAction(OKAction)

            DispatchQueue.main.async {
                self.present(alertController, animated: true)
            }
        }
        task.resume()
    }
    
    private func printMessages() {
        var request = URLRequest(url: URL(string: "http://52.41.253.190:9000/messages/?latitude=119.123123&longitude=120.1222")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {  // Check for fundamental networking error.
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {  // Check for http errors.
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
}
