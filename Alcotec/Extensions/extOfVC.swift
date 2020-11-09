//
//  extOfViewController.swift
//  Alcotec
//
//  Created by Admin on 09.11.2020.
//

import Foundation
import UIKit
import GoogleMaps

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
        switch row {
        case 0:
            Color.shared.color = .Red
        case 1:
            Color.shared.color = .Violet
        case 2:
            Color.shared.color = .Blue
        case 3:
            Color.shared.color = .Black
        case 4:
            Color.shared.color = .Yellow
        case 5:
            Color.shared.color = .Green
        case 6:
            Color.shared.color = .Gray
        default:
            break
        }
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

        if !filterData.isEmpty {
            for value in locations {
                if value.name == filterData[indexPath.row] {
                    self.mapView.camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(value.coordinate.0), longitude: CLLocationDegrees(value.coordinate.1), zoom: 15.0)
                    searchView.isHidden = true
                }
            }
        } else {
            self.mapView.camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Locations.locations[indexPath.row].coordinate.0), longitude: CLLocationDegrees(Locations.locations[indexPath.row].coordinate.1), zoom: 15.0)
            searchView.isHidden = true
        }
        
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

