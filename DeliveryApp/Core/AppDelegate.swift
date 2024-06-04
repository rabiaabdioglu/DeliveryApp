//
//  AppDelegate.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 28.05.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabbarVC()
        window?.makeKeyAndVisible()
        return true
    }



}

