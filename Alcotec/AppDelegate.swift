//
//  AppDelegate.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.

import UIKit
import GoogleMaps
import GooglePlaces
// AIzaSyAnGIODXBvuf3nlBng7i6mWjbdo_4_Ng6E

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ProtocolDB {

    var locations: [Location]?
    
    let googleApiKey = "AIzaSyAnGIODXBvuf3nlBng7i6mWjbdo_4_Ng6E"
    var db = DB()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(googleApiKey)
//        GMSPlacesClient.provideAPIKey(googleApiKey)
        print(openDB())
        
        locations = Locations.locations
        print(locations)
        return true
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {
        GMSServices.provideAPIKey(googleApiKey)
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print(closeDB())
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

