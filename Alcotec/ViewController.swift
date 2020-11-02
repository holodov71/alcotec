//
//  ViewController.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, GettingLocationProtocol, SetMarkerProtocol, PlacementOfLocations{


    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        
        let location = gettingLocation()
        
        

        let frameOfMap = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        let camera = GMSCameraPosition(latitude: CLLocationDegrees(location[0].latitude), longitude: CLLocationDegrees(location[0].longitude), zoom: 15.0)
        self.mapView = GMSMapView.map(withFrame: frameOfMap, camera: camera)
        self.view.addSubview(mapView)
        
        placementOfLocation(location, self.mapView)
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
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
        self.mapView.settings.zoomGestures = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
                    return
                }

        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

        createAndSetMarker(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), "My point", self.mapView, .yellow)

        let locationsForCalculation = gettingLocation()
        let coordinateOfLocation = CLLocation(latitude: CLLocationDegrees(locationsForCalculation[0].latitude), longitude: CLLocationDegrees(locationsForCalculation[0].longitude))
        let coordinateMy = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let distance = Int(coordinateMy.distance(from: coordinateOfLocation) ) // in meters
        print("distance =", Int(distance / 1000) )  // in km
    }
}
