//
//  DB.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.
//

import Foundation
import SQLite3

struct DB {
    
    static var db: OpaquePointer? = nil
}

protocol ProtocolDB {
    func openDB() -> String
    func closeDB() -> String
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
