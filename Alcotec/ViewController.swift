//
//  ViewController.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import UIKit
import GoogleMaps
import GooglePlaces


class ViewController: UIViewController, LocationsDBProtocol, SetMarkerProtocol, PlacementOfLocations, InitVCProtocol{
    
    
    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var radiusLabel = UILabel()
    
    var searchView = UIView()
    var tableView = UITableView()
    var searchBar = UISearchTextField()
    var filterData = [String]()
    var filtered = false
    
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var mapsClear = UIButton()
    var pickerView = UIPickerView()
    let userDefaults = UserDefaults.standard
    
    var switchSearch = UISwitch()
    var searchButton = UIButton()
    var circle: GMSCircle?
    var locations = Locations.locations
    
    
    override func viewDidLoad() {
        
        let frameOfMap = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let camera = GMSCameraPosition(latitude: CLLocationDegrees(locations[0].coordinate.0), longitude: CLLocationDegrees(locations[0].coordinate.1), zoom: 15.0)
        
        self.mapView = GMSMapView.map(withFrame: frameOfMap, camera: camera)
        self.view.addSubview(mapView)
        
        placementOfLocation(locations, self.mapView)
        
        locationManager.distanceFilter = 5
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        createSearchView(searchView, searchBar, self.view, tableView)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.mapView.delegate = self
        
        createSearchButton(searchButton, self.view)
        searchButton.addTarget(self, action: #selector(searchFunc), for: .touchUpInside)
        
        createMapsClearButton(mapsClear, self.view)
        mapsClear.addTarget(self, action: #selector(mapsClearFunc), for: .touchUpInside)
        
        createSearchMode(switchSearch, self.view)
        switchSearch.addTarget(self, action: #selector(getArea), for: .valueChanged)
        
        createRadiusLabel(radiusLabel, self.view, userDefaults)
        
    }
    
    //MARK: - objc func
    @objc func searchFunc() {
        searchView.isHidden = false
    }
    
    @objc func mapsClearFunc() {
        let titleOfAlert = "Do you want to delete all locations?"
        let messageOfAlert = ""
        let okActionTitle = "Yes"
        let cancelActionTitle = "No"
        
        let alert = UIAlertController(title: titleOfAlert, message: messageOfAlert, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okActionTitle, style: .default) { (action) in
            self.mapView.clear()
            self.locations.removeAll()
            self.deleteAll()
        }
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func getArea() {
        switch switchSearch.isOn {
        case true:
            self.mapView.clear()
            radiusLabel.isHidden = false
            searchButton.isEnabled = false
            let alert = UIAlertController(title: "Enter radius: ", message: "", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Введите радиус"
                textField.keyboardType = .numberPad
            }
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                //self.circle = GMSCircle(position: CLLocationCoordinate2D(latitude: CLLocationDegrees( self.locations[0].coordinate.0), longitude: CLLocationDegrees(self.locations[0].coordinate.1)), radius: CLLocationDistance(Radius.shared.radius))
                Radius.shared.radius = Double(alert.textFields![0].text ?? "") ?? 0.0
                print(Radius.shared.radius)
                
                self.circle?.radius = Radius.shared.radius
                self.circle?.map = self.mapView
                self.radiusLabel.text = String(Radius.shared.radius)
                self.userDefaults.setValue(Radius.shared.radius, forKey: "radius")
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        case false:
            self.mapView.clear()
            radiusLabel.isHidden = true
            searchButton.isEnabled = true
            self.circle?.radius = 0.0
            placementOfLocation(self.locations, self.mapView)
        }
    }
}

extension ViewController: CLLocationManagerDelegate, GetPlaceNearProtocol {
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
        
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
        
        if switchSearch.isOn {
            getAreaNearYou(Radius.shared.radius, &self.circle, self.locations, self.mapView, location.coordinate.latitude, location.coordinate.longitude)
        }
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        rememberLocation(coordinate, pickerView, locations, self.mapView, self)
    }
}
