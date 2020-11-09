//
//  LocationModel.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import Foundation

struct Location {
    
    var id: Int
    var name: String
    var coordinate: (Float, Float)
    var color: String?

}

struct Locations: LocationsDBProtocol {
        
     static var locations: [Location] = Locations().gettingLocation()

}

