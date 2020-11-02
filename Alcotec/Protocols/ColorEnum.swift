//
//  ColorEnum.swift
//  Alcotec
//
//  Created by Admin on 02.11.2020.
//

import Foundation
import UIKit

enum PinColor : Int {
    case Red
    case Violet
    case Green
    case Blue
    case Black
    case Yellow
    
    func getColor() -> UIColor {
        switch self {
        case .Violet:
            return UIColor.purple
        case .Red:
            return UIColor.red
        case .Green:
            return UIColor.green
        case .Blue:
            return UIColor.blue
        case .Black:
            return UIColor.black
        case .Yellow:
            return UIColor.yellow
        }
    }
    
    var descriptionImage: String {
        switch self {
        case .Violet:
            return "_purple"
        case .Red:
            return "_red"
        case .Green:
            return "_green"
        case .Blue:
            return "_blue"
        case .Black:
            return "_grey"
        case .Yellow:
            return "_yellow"
        }
    }
}
