//
//  ViewController.swift
//  MSGInABottle
//
//  Created by Sahil Jain on 10/1/16.
//  Copyright © 2016 Internal Mini-Project Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendMessageButton(_ sender: UIButton) {
        print("BUTTON PRESSED")
    }

}
