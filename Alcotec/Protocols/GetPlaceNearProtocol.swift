//
//  GetPlaceNearProtocol.swift
//  Alcotec
//
//  Created by Admin on 06.11.2020.
//

import Foundation
import GoogleMaps

protocol GetPlaceNearProtocol: SetMarkerProtocol {
    func getAreaNearYou(_ radius: Double, _ circle: inout GMSCircle?, _ locations: [Location], _ mapView: GMSMapView, _ latitude: Double, _ longitude: Double)
}

extension GetPlaceNearProtocol {
    func getAreaNearYou(_ radius: Double, _ circle: inout GMSCircle?, _ locations: [Location], _ mapView: GMSMapView, _ latitude: Double, _ longitude: Double) {
        mapView.clear()
        circle = GMSCircle(position: CLLocationCoordinate2D(latitude: CLLocationDegrees( latitude), longitude: CLLocationDegrees(longitude)), radius: CLLocationDistance(Radius.shared.radius))
        circle?.fillColor = .lightGray
        circle?.strokeColor = .black
        circle?.fillColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        circle?.strokeWidth = 1
        circle?.map = mapView
        for value in locations {
            let coordinateOfLocation = CLLocation(latitude: CLLocationDegrees( value.coordinate.0), longitude: CLLocationDegrees(value.coordinate.1))
            let coordinateMy = CLLocation(latitude: latitude, longitude: longitude)
            let distance = Double(coordinateMy.distance(from: coordinateOfLocation))
            if distance <= radius {
                createAndSetMarker(value, mapView)
            }
        }
        
    }
}
