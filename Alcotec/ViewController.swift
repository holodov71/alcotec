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
    var radiusLabel = UITextView()
    
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var color: PinColor?
    let radius = 0.0
    var mapsClear = UIButton()
    var pickerView = UIPickerView()
    
    var switchSearch = UISwitch()
    var searchButton = UIButton()
    var circle: GMSCircle?
    var locations = Locations.locations
    
    
    fileprivate func createMapsClearButton() {
        mapsClear.frame = CGRect(x: self.view.frame.width - 65, y: 50, width: 60, height: 40)
        mapsClear.backgroundColor = .systemYellow
        mapsClear.alpha = 0.8
        mapsClear.layer.cornerRadius = 20
        mapsClear.setTitle("Clear", for: .normal)
        mapsClear.setTitleColor(.black, for: .normal)
        mapsClear.addTarget(self, action: #selector(mapsClearFunc), for: .touchUpInside)
        self.view.addSubview(mapsClear)
    }
    
    fileprivate func createSwitchMode() {
        switchSearch.frame = CGRect(x: 5, y: 40, width: 30, height: 30)
        switchSearch.addTarget(self, action: #selector(getArea), for: .valueChanged)
        switchSearch.isOn = false
        self.view.addSubview(switchSearch)
    }
    
    fileprivate func createSearchButton() {
        searchButton.frame = CGRect(x: self.view.frame.width - 65, y: 100, width: 60, height: 40)
        searchButton.backgroundColor = .systemYellow
        searchButton.alpha = 0.8
        searchButton.layer.cornerRadius = 20
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.addTarget(self, action: #selector(searchFunc), for: .touchUpInside)
        self.view.addSubview(searchButton)
    }
    
    override func viewDidLoad() {
        
        let frameOfMap = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        let camera = GMSCameraPosition(latitude: CLLocationDegrees(locations[0].coordinate.0), longitude: CLLocationDegrees(locations[0].coordinate.1), zoom: 15.0)
        self.mapView = GMSMapView.map(withFrame: frameOfMap, camera: camera)
        self.view.addSubview(mapView)
        self.view.addSubview(radiusLabel)
        
        placementOfLocation(locations, self.mapView)
        locationManager.distanceFilter = 1

        self.mapView.delegate = self
       
        createSearchButton()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
        createMapsClearButton()
        createSwitchMode()
        
    }
    
    @objc func searchFunc() {
        let alert = UIAlertController(title: "Поиск локации по имени", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Введите имя"
            textField.keyboardType = .default
        }
        
        let okAction = UIAlertAction(title: "Search", style: .default) { (action) in
            for value in self.locations {
                if value.name == alert.textFields![0].text {
                    self.mapView.camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees( value.coordinate.0),
                                                          longitude: CLLocationDegrees( value.coordinate.1),
                                                          zoom: 15.0)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func mapsClearFunc() {
        self.mapView.clear()
        self.locations.removeAll()
        deleteAll()
    }
    
    @objc func getArea() {
        switch switchSearch.isOn {
        case true:
            self.mapView.clear()
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
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        case false:
            self.mapView.clear()
            self.circle?.radius = 0.0
            placementOfLocation(self.locations, self.mapView)
            
        }
    }
    
    func rememberTheLocation(_ coordinate: CLLocationCoordinate2D) {
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
            self.locations.append(newLocation)
            self.insertLocation(newLocation)
            self.createAndSetMarker(newLocation, self.mapView)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
        
//        func getPlaceNearYour(_ radius: Double){
//            self.mapView.clear()
//            circle = GMSCircle(position: CLLocationCoordinate2D(latitude: CLLocationDegrees( location.coordinate.latitude), longitude: CLLocationDegrees(location.coordinate.longitude)), radius: CLLocationDistance(Radius.shared.radius))
//            circle?.fillColor = .lightGray
//            circle?.strokeColor = .black
//            circle?.fillColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
//            circle?.strokeWidth = 1
//            circle?.map = self.mapView
//            for value in self.locations {
//                let coordinateOfLocation = CLLocation(latitude: CLLocationDegrees( value.coordinate.0), longitude: CLLocationDegrees(value.coordinate.1))
//                let coordinateMy = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//                let distance = Double(coordinateMy.distance(from: coordinateOfLocation))
//                if distance <= radius {
//                    createAndSetMarker(value, self.mapView)
//                }
//            }
//        }
        
        if switchSearch.isOn {
            getAreaNearYou(Radius.shared.radius, &self.circle, self.locations, self.mapView, location.coordinate.latitude, location.coordinate.longitude)
//            getPlaceNearYour(Radius.shared.radius)
        }
        
        print(location)
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

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        Radius.shared.radius = Double(textView.text) ?? 0.0
    }
}
