//
//  AppDelegate.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 01. 09..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let diContainer = DepInjectionIContainer()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppAppearance.setupAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let repoListViewController = diContainer.makeReposSceneDIContainer().makeRepoListViewController()
        window?.rootViewController = UINavigationController(rootViewController: repoListViewController)
        window?.makeKeyAndVisible()
    
        return true
    }
}
