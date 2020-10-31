//
//  DB.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import Foundation
import SQLite3
import UIKit

struct DB {
    
    static var db: OpaquePointer? = nil
}

protocol ProtocolDB {
    func openDB() -> String
    func closeDB() -> String
}

protocol GettingLocationProtocol {
    func gettingLocation() -> [Location]
}

//MARK: - Getting location from DB
extension GettingLocationProtocol {
    func gettingLocation() -> [Location] {
        
        let query = "select * from location"
        var str: OpaquePointer? = nil
        var colorOfPin: String?
        
        var listOfLocations = [Location]()
        
        if sqlite3_prepare_v2(DB.db, query, -1, &str, nil) == SQLITE_OK {
            print("Query \(query) is done!")
        } else {
            print("Query \(query) is incorrect!")
        }
        
        while sqlite3_step(str) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(str, 0))
            let name = String(cString: sqlite3_column_text(str, 1))
            let latitude = String(cString: sqlite3_column_text(str, 2))
            let longitude = String(cString: sqlite3_column_text(str, 3))
            
            if let color = sqlite3_column_text(str, 4) {
                colorOfPin = String(cString: color)
                print(colorOfPin ?? "nil")
            }
                
            listOfLocations.append(Location(id: id, name: name, latitude: Float(latitude) ?? 0.0, longitude: Float(longitude) ?? 0.0, color: UIColor.colorWith(name: "\(String(describing: colorOfPin))") ?? UIColor.systemGray))
        }
        
        sqlite3_finalize(str)
                
        return listOfLocations
    }

}
//MARK: - Open DB
extension ProtocolDB {
   
    func openDB() -> String {
        let resource = "Alcotec"
        
        guard let dbResourcePath = Bundle.main.path(forResource: resource, ofType: "db") else {
            return "Error of getting path of DB!"
        }
        
        let fileManager = FileManager.default
        
        do {
            let dbPath = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(resource + ".db")
                .path
            
            if !fileManager.fileExists(atPath: dbPath) {
                try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
            }
            
            guard sqlite3_open(dbPath, &DB.db) == SQLITE_OK else {
                print("error open DB \(Error.self)")
                return "error open DB on path =  \(dbPath)"
            }
            
            return "open DataBase done \(dbPath)"
        } catch {}
        
        return "error copy DB:\(dbResourcePath) in applicationSupportDirectory"
    }
   
}

extension ProtocolDB {
    func closeDB() -> String{
        sqlite3_close(DB.db)
        return "Database was closed!"
    }
}
