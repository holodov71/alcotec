//
//  ViewController.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, LocationsDBProtocol, SetMarkerProtocol, PlacementOfLocations{
    
    
    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var radiusLabel = UILabel()
    
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var color: PinColor?
    let radius = 500.0
    var mapsClear = UIButton()
    var pickerView = UIPickerView()
    
    var favouritePlaces = [Location]()
    var locations = Locations.locations
    override func viewDidLoad() {
        
        
//        arrOfLocation = Locations.locatons
        //arrOfLocation = gettingLocation()
        
        radiusLabel = UILabel(frame: CGRect(x: 5, y: 50, width: 100, height: 100))
        //        radiusLabel.alpha = 1
        radiusLabel.text = "1000"
        
        let circle = GMSCircle(position: CLLocationCoordinate2D(latitude: CLLocationDegrees( locations[0].coordinate.0), longitude: CLLocationDegrees(locations[0].coordinate.1)), radius: CLLocationDistance(radius))
        circle.fillColor = .lightGray
        circle.strokeColor = .black
        circle.fillColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        circle.strokeWidth = 1
        
        
        self.view.backgroundColor = PinColor.Blue.getColor()
        
        let frameOfMap = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        let camera = GMSCameraPosition(latitude: CLLocationDegrees(locations[0].coordinate.0), longitude: CLLocationDegrees(locations[0].coordinate.1), zoom: 15.0)
        self.mapView = GMSMapView.map(withFrame: frameOfMap, camera: camera)
        self.view.addSubview(mapView)
        self.view.addSubview(radiusLabel)
        
        placementOfLocation(locations, self.mapView)
        locationManager.distanceFilter = 50

        self.mapView.delegate = self
        circle.map = self.mapView
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        mapsClear.frame = CGRect(x: 250, y: 250, width: 100, height: 40)
        mapsClear.setTitle("Clear", for: .normal)
        mapsClear.addTarget(self, action: #selector(mapsClearFunc), for: .touchUpInside)
        self.view.addSubview(mapsClear)
        

        
//        pickerView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//        self.view.addSubview(pickerView)
        
        //        print(gettingLocation())
    }
    
    @objc func mapsClearFunc() {
        self.mapView.clear()
    }
    
    func rememberTheLocation(_ coordinate: CLLocationCoordinate2D) {
        //let marker = GMSMarker()
        let alert = UIAlertController(title: "Запоминание текущей геопозиции:", message: "Укажите цвет маркера: \n\n\n\n\n\n\n", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Введите название"
            textField.borderStyle = .roundedRect
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.frame = CGRect(x: 40, y: 70, width: alert.view.frame.width / 2, height: 140)
        alert.view.addSubview(pickerView)
        
        let lastId = locations.last?.id ?? 0

        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            let newLocation = Location(id: lastId + 1, name: alert.textFields![0].text ?? "", coordinate: (Float(coordinate.latitude), Float(coordinate.longitude)), color: self.color?.descriptionImage)
            self.createAndSetMarker(newLocation, self.mapView)
            self.locations.append(newLocation)
            self.insertLocation(newLocation)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
        
//        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        //createAndSetMarker(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), "My point", self.mapView, .yellow)
        
        
        //        let locationsForCalculation = gettingLocation()
        
        func getPlaceNearYour(_ radius: Int){
            //var placesNearYou = [Location]()
            for value in self.locations {
                var newValue = value
                let coordinateOfLocation = CLLocation(latitude: CLLocationDegrees( value.coordinate.0), longitude: CLLocationDegrees(value.coordinate.1))
                let coordinateMy = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let distance = Int(coordinateMy.distance(from: coordinateOfLocation))
                
                if distance > radius {
                    newValue.isInRadius = false
                }
            }
        }
//        let rad = Int(radiusLabel.text ?? "")
        
        print(location)
        
        //let placeNear = getPlaceNearYour(rad!, arrOfLocation)
        
        // placementOfLocation(placeNear, self.mapView)
        
        
                
        //        let coordinateOfLocation = CLLocation(latitude: CLLocationDegrees(locationsForCalculation[0].latitude), longitude: CLLocationDegrees(locationsForCalculation[0].longitude))
        //        let coordinateMy = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //        let distance = Int(coordinateMy.distance(from: coordinateOfLocation) ) // in meters
        //print("distance =", Int(distance / 1000) )  // in km
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
           return PinColor.Red.rawValue
        case 1:
           return PinColor.Violet.rawValue
        case 2:
           return PinColor.Blue.rawValue
        case 3:
           return PinColor.Black.rawValue
        case 4:
           return PinColor.Yellow.rawValue
        case 5:
           return PinColor.Green.rawValue
        default:
            return PinColor.Gray.rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row = \(row)")
        switch row {
        case 0:
            color = .Red
        case 1:
            color = .Violet
        case 2:
            color = .Blue
        case 3:
            color = .Black
        case 4:
            color = .Yellow
        case 5:
            color = .Green
        case 6:
            color = .Gray
        default:
            break
        }
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        rememberTheLocation(coordinate)
        
    }
}
