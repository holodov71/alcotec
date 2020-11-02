//
//  ViewController.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, GettingLocationProtocol, SetMarkerProtocol {


    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        
        let location = gettingLocation()

        let frameOfMap = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 50)
        
        
        
        let camera = GMSCameraPosition(latitude: CLLocationDegrees(location[0].latitude), longitude: CLLocationDegrees(location[0].longitude), zoom: 15.0)
        //let camera1 = GMSCameraPosition(target: , zoom: <#T##Float#>)
        self.mapView = GMSMapView.map(withFrame: frameOfMap, camera: camera)
        self.view.addSubview(mapView)
        
        createAndSetMarker(CLLocationCoordinate2D(latitude: CLLocationDegrees( location[0].latitude), longitude: CLLocationDegrees(location[0].longitude)), location[0].name, self.mapView, location[0].color)
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.view.backgroundColor = gettingLocation()[1].color
        currentLocation = self.mapView.myLocation
        


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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//                    return
//                }
//
//        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 20, bearing: 0, viewingAngle: 0)
//
//        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//
//        createAndSetMarker(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), "My point", self.mapView, .yellow)
////        marker.title = "My point"
////        marker.snippet = "Curent point"
////        marker.map = mapView
////        marker.icon = GMSMarker.markerImage(with: .red)
//
//        let coordinateKiev = CLLocation(latitude: 50.4536, longitude: 30.5164)
//        let coordinateMy = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let distance = Int(coordinateMy.distance(from: coordinateKiev) ) // in meters
//        print("distance =", Int(distance / 1000) )  // in km
//    }
}
