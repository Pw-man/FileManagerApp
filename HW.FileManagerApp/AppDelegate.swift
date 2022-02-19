//
//  AppDelegate.swift
//  HW.FileManagerApp
//
//  Created by Роман on 14.01.2022.
//

import UIKit
import RealmSwift
import KeychainAccess
import Security

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.set(true, forKey: "sortingFlag")
        
        var alreadyLaunched: Bool = UserDefaults.standard.bool(forKey: "alreadyLaunched")
        
        if alreadyLaunched {
            alreadyLaunched = true
        } else {
            do {
                var key = Data(count: 64)
                _ = key.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!) }
                keychain[data: "realmConfigKey"] = key
                
                let localRealm = try Realm(configuration: RealmConfiguration.config)
                do {
                    try localRealm.write({
                        localRealm.add(user)
                    })
                    UserDefaults.standard.set(true, forKey: "alreadyLaunched")
                } catch {
                    print(error.localizedDescription)
                }
            } catch {
                print(error.localizedDescription)
                print("Error with Realm DATABASE")
            }
        }
        return true
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

