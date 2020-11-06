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

protocol LocationsDBProtocol {
    func gettingLocation() -> [Location]
    func insertLocation(_ location: Location)
    func deleteAll()
}

//MARK: - Getting location from DB
extension LocationsDBProtocol {
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
            }
            //            let colorOfPin = String(cString: sqlite3_column_text(str, 4))
            
            //            listOfLocations.append(Location(id: id, name: name, latitude: Float(latitude) ?? 0.0, longitude: Float(longitude) ?? 0.0, color: UIColor.colorWith(name: "\(String(describing: colorOfPin))") ?? UIColor.systemGray))
            listOfLocations.append(Location(id: id, name: name, coordinate: ((Float(latitude) ?? 0.0), (Float(longitude) ?? 0.0)), color: colorOfPin))
        }
        
        sqlite3_finalize(str)
        
        return listOfLocations
    }
    
}

//MARK: - insert new Location in BD
extension LocationsDBProtocol {
    
    func insertLocation(_ location: Location) {
        let insert = "insert into Location (name, latitude, longitude, color) VALUES ('\(location.name)', '\(location.coordinate.0)', '\(location.coordinate.1)', '\(location.color ?? "")')"
        var str: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(DB.db, insert, -1, &str, nil) == SQLITE_OK,
              sqlite3_step(str) == SQLITE_DONE
        else {
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error preparing insert: \(errmsg): for insert: ", insert)
            return
            
        }
        sqlite3_finalize(str)
        
    }
}

//MARK: - delete all
extension LocationsDBProtocol {
    func deleteAll() {
        let query = "delete from location"
        var del: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(DB.db, query, -1, &del, nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error prepare delete: \(errmsg)")
            return
        }
        
        guard sqlite3_step(del) == SQLITE_DONE  else {
            let errmsg = String(cString: sqlite3_errmsg(DB.db)!)
            print("error delete: \(errmsg)")
            return
        }
        
        sqlite3_finalize(del)
        print(query)
        
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
