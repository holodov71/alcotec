//
//  LocationModel.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import Foundation
//import UIKit


//TODO: create tuple of coordinate
struct Location {
    
    var id: Int
    var name: String
    var coordinate: (Float, Float)
    var color: String?
    //var isInRadius = true
    
    //    var latitude: Float
    //    var longitude: Float
    //    var color: UIColor?
}

struct Locations: LocationsDBProtocol {
        
     static var locations: [Location] = Locations().gettingLocation()
      
        
    
    
    //didSet
    
//    static var shared: Locations = Locations()
//    init() {
//        Locations.locations = gettingLocation()
//    }
}

//class LocationObserver: LocationsDBProtocol {
//    var locations = Locations.locations {
//        didSet {
//            if locations.count == 0 {
//                deleteAll()
//                print(gettingLocation())
//            } else {
//                print("locations.last = ", locations.last)
//                if let location = locations.last {
//                    insertLocation(location)
//                    print(gettingLocation())
//                }
//                
//            }
//        }
//    }
//}

