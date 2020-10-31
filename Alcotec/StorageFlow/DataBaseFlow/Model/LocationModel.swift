//
//  LocationModel.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import Foundation
import UIKit

struct Location {
    var id: Int
    var name: String
    var latitude: Float
    var longitude: Float
    var color: UIColor?
}

//struct Locations: GettingLocationProtocol {
//    var locations: [Location]?
//
//    init() {
//        self.locations = gettingLocation()
//    }
//}
