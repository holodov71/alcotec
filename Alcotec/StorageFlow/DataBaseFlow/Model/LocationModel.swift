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
    var latitude: Float
    var longitude: Float
    var color: String?
}

//struct Locations: GettingLocationProtocol {
//    var listOfLocation: [Location]?
//    
//    init() {
//        self.listOfLocation = gettingLocation()
//    }
//}
