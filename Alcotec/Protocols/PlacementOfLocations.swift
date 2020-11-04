//
//  PlacementOfLocations.swift
//  Alcotec
//
//  Created by Admin on 02.11.2020.
//

import Foundation
import GoogleMaps
import GooglePlaces

protocol PlacementOfLocations: SetMarkerProtocol {
    func placementOfLocation(_ locations: [Location], _ mapView: GMSMapView)
}

extension PlacementOfLocations {
    func placementOfLocation(_ locations: [Location], _ mapView: GMSMapView) {
        for value in locations {
            createAndSetMarker(value, mapView)
        }
    }
}
