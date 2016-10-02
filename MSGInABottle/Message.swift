//
//  Message.swift
//  MSGInABottle
//
//  Created by Sahil Jain on 10/2/16.
//  Copyright © 2016 Internal Mini-Project Team. All rights reserved.
//

import Foundation
import MapKit

class Message : NSObject, MKAnnotation {
    let text: String
    let latitude: Double
    let longitude: Double
    let expiry: Date?

    init(text: String, latitude: Double, longitude: Double) {
        self.text = text
        self.latitude = latitude
        self.longitude = longitude
        self.expiry = nil
    }
    
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

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }

    var title: String? {
        return text
    }

}
