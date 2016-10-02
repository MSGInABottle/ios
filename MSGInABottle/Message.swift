//
//  Message.swift
//  MSGInABottle
//
//  Created by Sahil Jain on 10/2/16.
//  Copyright © 2016 Internal Mini-Project Team. All rights reserved.
//

import Foundation

struct Message {
    var text: String
    var latitude: Double
    var longitude: Double
    var expiry: Date
    
    init?(json: [String: Any]) {
        guard let text = json["Text"] as? String,
            let latitude = json["Latitude"] as? Double,
            let longitude = json["Longitude"] as? Double,
            let expiry = json["Expiry"] as? String
            else {
                return nil
        }
        self.text = text
        self.latitude = latitude
        self.longitude = longitude
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSZ"
        self.expiry = dateFormatter.date(from: expiry)!
    }
}
