//
//  AppDelegate.swift
//  Alcotec
//
//  Created by Admin on 30.10.2020.

import UIKit
// AIzaSyAnGIODXBvuf3nlBng7i6mWjbdo_4_Ng6E

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ProtocolDB {

    var db = DB()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(openDB())
        return true
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

