//
//  AppDelegate.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/10/23.
//

import UIKit
import AVFoundation

var backgroundMusic: AVAudioPlayer?

let prodAdMobsKey = AppConstants.prodAdMobsKey
let testingAdMobsKey = AppConstants.testingAdMobsKey

let path = Bundle.main.path(forResource: "background_music.mp3", ofType: nil)!
let url = URL(fileURLWithPath: path)


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic?.numberOfLoops = -1
            //backgroundMusic?.play()
        } catch {
            // couldn't load file :(
            print("failed")
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

    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}

