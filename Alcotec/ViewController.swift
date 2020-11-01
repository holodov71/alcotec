//
//  ViewController.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import UIKit

class ViewController: UIViewController, GettingLocationProtocol {

    override func viewDidLoad() {
        
        
        self.view.backgroundColor = gettingLocation()[1].color
        
        print(gettingLocation())
    }
    
}

