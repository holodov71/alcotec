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
    
    private var mapView: GMSMapView!
    private var locationManager = CLLocationManager()
    private var marker = GMSMarker()
    
    override func viewDidLoad() {
        
        let location = gettingLocation()
        print(location)
        
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 50.4536, longitude: 30.5164, zoom: 5.0)
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        
        
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: 50.4536, longitude: 30.5164)
        marker.title = "Киев"
        marker.snippet = "Укриана"
        marker.map = mapView
        marker.icon = GMSMarker.markerImage(with: location[0].color)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 10, bearing: 0, viewingAngle: 0)
        
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        marker.title = "My point"
        marker.snippet = "Curent point"
        marker.map = mapView
        marker.icon = GMSMarker.markerImage(with: .red)
        
        let coordinateKiev = CLLocation(latitude: 50.4536, longitude: 30.5164)
        let coordinateMy = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let distance = Int(coordinateMy.distance(from: coordinateKiev) ) // in meters
        print("distance =", Int(distance / 1000) )  // in km
        
        
        print("locations =", locations)
        // 8
        locationManager.stopUpdatingLocation()
    }
}

