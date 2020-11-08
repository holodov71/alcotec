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

    
    var searchView = UIView()
    var tableView = UITableView()
    var searchBar = UISearchTextField()
    var filterData = [String]()
    var filtered = false
    
    
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var color: PinColor?
    var mapsClear = UIButton()
    var pickerView = UIPickerView()
    let userDefaults = UserDefaults.standard
    
    var switchSearch = UISwitch()
    var searchButton = UIButton()
    var circle: GMSCircle?
    var locations = Locations.locations
    
    fileprivate func createMapsClearButton() {
        mapsClear.frame = CGRect(x: self.view.frame.width - 65, y: 50, width: 60, height: 40)
        mapsClear.backgroundColor = .systemYellow
        mapsClear.alpha = 0.2
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
        searchButton.alpha = 0.2
        searchButton.layer.cornerRadius = 20
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.addTarget(self, action: #selector(searchFunc), for: .touchUpInside)
        self.view.addSubview(searchButton)
    }
    
    func createRadiusLabel() {
        radiusLabel.frame = CGRect(x: 5, y: 80, width: 70, height: 20)
        if let radius = userDefaults.object(forKey: "radius") {
            radiusLabel.text = "\(radius)"
        }
        radiusLabel.isHidden = true
    }
    
    func createSearchView() {
        
        searchView.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: self.view.frame.height-100)
        
        self.view.addSubview(searchView)
        searchBar.frame = CGRect(x: 20, y: 20, width: searchView.frame.width-40, height: 30)
        searchBar.delegate = self
        
        tableView.frame = CGRect(x: 0, y: 70, width: searchView.frame.width, height: searchView.frame.height-50)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        searchView.addSubview(searchBar)
        searchView.addSubview(tableView)
        searchView.isHidden = true
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
       createSearchView()
        createSearchButton()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
          
        
        createMapsClearButton()
        createSwitchMode()
        createRadiusLabel()
        
    }

    @objc func searchFunc() {
        searchView.isHidden = false
//        let storyboard: UIStoryboard = UIStoryboard(name: "SearchStoryboard", bundle: nil)
//        let controller: SearchViewController = storyboard.instantiateViewController(withIdentifier: "TableVC") as! SearchViewController
//        present(controller, animated: true, completion: nil)
        //controller.modalPresentationStyle = .fullScreen
//        let alert = UIAlertController(title: "Поиск локации по имени", message: "", preferredStyle: .alert)
//
//        alert.addTextField { (textField) in
//            textField.placeholder = "Введите имя"
//            textField.keyboardType = .default
//        }
//
//        let okAction = UIAlertAction(title: "Search", style: .default) { (action) in
//            for value in self.locations {
//                if value.name == alert.textFields![0].text {
//                    self.mapView.camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees( value.coordinate.0),
//                                                          longitude: CLLocationDegrees( value.coordinate.1),
//                                                          zoom: 15.0)
//                }
//            }
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        alert.addAction(cancelAction)
//        alert.addAction(okAction)
//        present(alert, animated: true, completion: nil)
    }
    
    @objc func mapsClearFunc() {
        let alert = UIAlertController(title: "Do you want to delete all locations?", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.mapView.clear()
            self.locations.removeAll()
            self.deleteAll()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
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
                
//                self.circle = GMSCircle(position: CLLocationCoordinate2D(latitude: CLLocationDegrees( self.locations[0].coordinate.0), longitude: CLLocationDegrees(self.locations[0].coordinate.1)), radius: CLLocationDistance(Radius.shared.radius))
                Radius.shared.radius = Double(alert.textFields![0].text ?? "") ?? 0.0
                print(Radius.shared.radius)
//                getAreaNearYou(Radius.shared.radius, &self.circle, self.locations, self.mapView, self.locations[0].coordinate.0, self.locations[0].coordinate.1)
                self.circle?.radius = Radius.shared.radius
                self.circle?.map = self.mapView
                self.radiusLabel.text = String(Radius.shared.radius)
                    //alert.textFields![0].text
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

        
        //FIXME: new alert for checking
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            if alert.textFields![0].text != "" {
                let newLocation = Location(id: lastId + 1, name: alert.textFields![0].text ?? "", coordinate: (Float(coordinate.latitude), Float(coordinate.longitude)), color: self.color?.descriptionImage)
                self.locations.append(newLocation)
                self.insertLocation(newLocation)
                self.createAndSetMarker(newLocation, self.mapView)
            } else {
                
            }
            
            
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

extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchTextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !filterData.isEmpty {
            return filterData.count
        }
        return filtered ? 0 : Locations.locations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(Locations.locations[indexPath.row])
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Locations.locations[indexPath.row].coordinate.0), longitude: CLLocationDegrees(Locations.locations[indexPath.row].coordinate.1), zoom: 15.0)
        searchView.isHidden = true
        //dismiss(animated: true, completion: nil)

        //let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //let controller = storyboard.instantiateViewController(withIdentifier: "VC") as! ViewController
//        print(controller.mapView)
//        controller.mapView?.camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Locations.locations[indexPath.row].coordinate.0), longitude: CLLocationDegrees(Locations.locations[indexPath.row].coordinate.1), zoom: 15.0)
//
//        controller.modalPresentationStyle = .fullScreen
//
//        present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if !filterData.isEmpty {
            cell.textLabel?.text = filterData[indexPath.row]
        } else {
            cell.textLabel?.text = Locations.locations[indexPath.row].name

        }
        
        return cell
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            filterText(text+string)
        }
        return true
    }
    
    func filterText(_ query: String) {
        filterData.removeAll()
        for value in Locations.locations {
            if value.name.lowercased().starts(with: query.lowercased()) {
                filterData.append(value.name)
            }
        }
        filtered = true
        tableView.reloadData()
    }
}
