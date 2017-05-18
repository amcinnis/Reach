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
    var category: String?
    var coordinator: User?
    var coordinate: CLLocationCoordinate2D
    var desc: String?
    var end: Date?
    var id: String?
    var location: Location?
    var name: String?
    var start: Date?
    
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
