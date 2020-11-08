//
//  SearchViewController.swift
//  Alcotec
//
//  Created by Admin on 07.11.2020.
//

import UIKit
import GoogleMaps


class SearchViewController: UIViewController {

    var tableView = UITableView()
    var searchBar = UISearchTextField()
    var filterData = [String]()
    var filtered = false
    var controller: ViewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.frame = CGRect(x: 20, y: 20, width: self.view.frame.width-40, height: 30)
        searchBar.delegate = self
        
        tableView.frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: self.view.frame.height-50)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchTextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !filterData.isEmpty {
            return filterData.count
        }
        return filtered ? 0 : Locations.locations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print(Locations.locations[indexPath.row])
        
        dismiss(animated: true, completion: nil)

        //let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        //let controller = storyboard.instantiateViewController(withIdentifier: "VC") as! ViewController
        print(controller.mapView)
        controller.mapView?.camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Locations.locations[indexPath.row].coordinate.0), longitude: CLLocationDegrees(Locations.locations[indexPath.row].coordinate.1), zoom: 15.0)
        
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
