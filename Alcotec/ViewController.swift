//
//  ViewController.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, GettingLocationProtocol {

    
    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        
        let location = gettingLocation()
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 50)
        let camera = GMSCameraPosition(latitude: 53.6884, longitude: 23.8258, zoom: 10.0)
        self.mapView = GMSMapView.map(withFrame: frame, camera: camera)
        self.view.addSubview(mapView)
        
        self.marker.position = CLLocationCoordinate2D(latitude: 53.6884, longitude: 23.8258)
        self.marker.title = "Советская"
        self.marker.map = mapView
        self.marker.icon = GMSMarker.markerImage(with: location[0].color)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
//        self.view.backgroundColor = gettingLocation()[1].color
        
        print(gettingLocation())
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
    }
}
