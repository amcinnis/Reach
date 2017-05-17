//
//  Event.swift
//  Reach
//
//  Created by Austin McInnis on 5/9/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import Foundation
import MapKit

class Event: NSObject, MKAnnotation {
    var id: String?
    var name: String?
    var location: Location?
    var start: Date?
    var end: Date?
    var desc: String?
    var price: Double?
    var coordinator: User?
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    var title: String? {
        if let name = name {
            return name
        }
        return nil
    }
    
    var subtitle: String? {
        if let location = location {
            return location.name
        }
        return nil
    }
    
}

class Location {
    
    var name: String
    var place: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, place: String, latitude: Double, longitude: Double) {
        self.name = name
        self.place = place
        self.latitude = latitude
        self.longitude = longitude
    }
}
