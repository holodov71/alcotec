//
//  SetMarkerProtocol.swift
//  Alcotec
//
//  Created by Admin on 02.11.2020.
//

import Foundation
import GoogleMaps

protocol SetMarkerProtocol {
    func createAndSetMarker(_ coordinage: CLLocationCoordinate2D, _ title: String, _ mapView: GMSMapView, _ colorOfMarker: UIColor?)
}

extension SetMarkerProtocol {
    func createAndSetMarker(_ coordinate: CLLocationCoordinate2D, _ title: String, _ mapView: GMSMapView, _ colorOfMarker: UIColor?){
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = title
        marker.map = mapView
        marker.icon = GMSMarker.markerImage(with: colorOfMarker ?? .systemGray)
        
    }
}
//self.marker.position = CLLocationCoordinate2D(latitude: 53.6884, longitude: 23.8258)
//self.marker.title = "Советская"
//self.marker.map = mapView
//self.marker.icon = GMSMarker.markerImage(with: location[0].color)
