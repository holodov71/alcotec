//
//  extensionOfUIColor.swift
//  Alcotec
//
//  Created by Admin on 31.10.2020.
//

import Foundation
import UIKit

extension UIColor {

    static func colorWith(name:String) -> UIColor? {
        let selector = Selector("\(name)Color")
        if UIColor.self.responds(to: selector) {
            let color = UIColor.self.perform(selector).takeUnretainedValue()
            return (color as? UIColor)
        } else {
            return nil
        }
    }
}

