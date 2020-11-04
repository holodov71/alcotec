//
//  ColorEnum.swift
//  Alcotec
//
//  Created by Admin on 02.11.2020.
//

import Foundation
import UIKit

enum PinColor : String {
    case Red = "Red"
    case Violet = "Purple"
    case Green = "Green"
    case Blue = "Blue"
    case Black = "Black"
    case Yellow = "Yellow"
    case Gray = "Gray"
    
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
        case .Gray:
            return UIColor.systemGray
        }
    }
    
    var descriptionImage: String {
        switch self {
        case .Violet:
            return "purple"
        case .Red:
            return "red"
        case .Green:
            return "green"
        case .Blue:
            return "blue"
        case .Black:
            return "black"
        case .Yellow:
            return "yellow"
        case .Gray:
            return "gray"
        }
    }
}


