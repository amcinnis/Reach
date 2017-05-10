//
//  Event.swift
//  Reach
//
//  Created by Austin McInnis on 5/9/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import Foundation

class Event {
    var id: String?
    var name: String?
    var location: Location?
    var start: Date?
    var end: Date?
    var description: String?
    var price: Double?
    var coordinator: User?
    
}

class Location {
    
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
