//
//  InitVCProtocol.swift
//  Alcotec
//
//  Created by Admin on 09.11.2020.
//

import Foundation
import UIKit
import GoogleMaps

protocol InitVCProtocol: LocationsDBProtocol, SetMarkerProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    func createMapsClearButton(_ mapsButton: UIButton, _ view: UIView)
    func createSearchMode(_ switchButton: UISwitch, _ view: UIView)
    func createSearchButton(_ searchButton: UIButton, _ view: UIView)
    func createSearchView(_ searchView: UIView, _ searchBar: UISearchTextField, _ mainView: UIView, _ tableView: UITableView)
    func createRadiusLabel(_ radiusLabel: UILabel, _ view: UIView, _ userDefaults: UserDefaults)
    func rememberLocation(_ coordinate: CLLocationCoordinate2D, _ colorPickerView: UIPickerView, _ arrOfLocations: [Location], _ mapView: GMSMapView, _ vc: UIViewController)
}

extension InitVCProtocol {
    func createMapsClearButton(_ mapsButton: UIButton, _ view: UIView) {
        let titleMapsClearButton = "Delete all!"
        mapsButton.frame = CGRect(x: view.frame.width - 110, y: 50, width: 100, height: 40)
        mapsButton.backgroundColor = .systemYellow
        mapsButton.alpha = 0.2
        mapsButton.layer.cornerRadius = 20
        mapsButton.setTitle(titleMapsClearButton, for: .normal)
        mapsButton.setTitleColor(.black, for: .normal)
        view.addSubview(mapsButton)
        }
    
    func createSearchMode(_ switchButton: UISwitch, _ view: UIView) {
        switchButton.frame = CGRect(x: 5, y: 40, width: 30, height: 30)
        switchButton.isOn = false
        view.addSubview(switchButton)
    }
    
    func createSearchButton(_ searchButton: UIButton, _ view: UIView){
        let titleSearchButton = "Search"
        searchButton.frame = CGRect(x: view.frame.width - 110, y: 100, width: 100, height: 40)
        searchButton.backgroundColor = .systemYellow
        searchButton.alpha = 0.2
        searchButton.layer.cornerRadius = 20
        searchButton.setTitle(titleSearchButton, for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        view.addSubview(searchButton)
    }

    func createSearchView(_ searchView: UIView, _ searchBar: UISearchTextField, _ mainView: UIView, _ tableView: UITableView) {
        searchView.frame = CGRect(x: 20, y: 100, width: mainView.frame.width - 40, height: mainView.frame.height-100)
        
        mainView.addSubview(searchView)
        searchBar.frame = CGRect(x: 20, y: 20, width: searchView.frame.width-40, height: 30)
        
        tableView.frame = CGRect(x: 0, y: 70, width: searchView.frame.width, height: searchView.frame.height-50)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        searchView.addSubview(searchBar)
        searchView.addSubview(tableView)
        searchView.isHidden = true
    }
    
    func createRadiusLabel(_ radiusLabel: UILabel, _ view: UIView, _ userDefaults: UserDefaults) {
        radiusLabel.frame = CGRect(x: 5, y: 80, width: 70, height: 20)
        if let radius = userDefaults.object(forKey: "radius") {
            radiusLabel.text = "\(radius)"
        }
        view.addSubview(radiusLabel)
        radiusLabel.isHidden = true
    }

    func rememberLocation(_ coordinate: CLLocationCoordinate2D, _ colorPickerView: UIPickerView, _ arrOfLocations: [Location], _ mapView: GMSMapView, _ vc: UIViewController) {
        var locations = arrOfLocations
        let alertTitle = "Remember current location"
        let alertMessage = "Choose color of pin: \n\n\n\n\n\n\n"
        let placeholder = "Enter name"
        let titleOfOkAction = "Ok"
        let titleOfCancelAction = "Cancel"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        
        
        alert.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
        }
        
        colorPickerView.delegate = self
        colorPickerView.dataSource = self
        colorPickerView.frame = CGRect(x: 40, y: 70, width: alert.view.frame.width / 2, height: 140)
        alert.view.addSubview(colorPickerView)
        
        let lastId = locations.last?.id ?? 0
        
        let okAction = UIAlertAction(title: titleOfOkAction, style: .default) { (action) in
            if alert.textFields![0].text != "" {
                let newLocation = Location(id: lastId + 1, name: alert.textFields![0].text ?? "", coordinate: (Float(coordinate.latitude), Float(coordinate.longitude)), color: Color.shared.color?.descriptionImage)
                locations.append(newLocation)
                self.insertLocation(newLocation)
                self.createAndSetMarker(newLocation, mapView)
            } else {
                
            }
        }
        
        let cancelAction = UIAlertAction(title: titleOfCancelAction, style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
        //present(alert, animated: true, completion: nil)
    }
}



   


