//
//  Track.swift
//  GBMap
//
//  Created by Артём Сарана on 10.11.2021.
//

import Foundation
import RealmSwift
import CoreLocation

class Track: Object {
    var points = List<Point>()
}

class Point: Object {
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    
    required convenience init(lon: Double, lat: Double) {
        self.init()
        self.lon = lon
        self.lat = lat
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.lon = coordinate.longitude
        self.lat = coordinate.latitude
    }
}
