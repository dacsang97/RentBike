//
//  AppDelegate.swift
//  RentBi
//
//  Created by slay on 6/24/17.
//  Copyright © 2017 vteam. All rights reserved.
//

import UIKit
import GoogleMaps
import Material

extension UIStoryboard {
    class func viewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: MainViewController = {
        return UIStoryboard.viewController(identifier: "MainViewController") as! MainViewController
    }()
//    var rootViewController: FakeViewController = {
//        return UIStoryboard.viewController(identifier: "FakeViewController") as! FakeViewController
//    }()
    var sidebarViewController: SidebarViewController = {
        return UIStoryboard.viewController(identifier: "SidebarViewController") as! SidebarViewController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCk7qbxcyQZic6DgR8Hqoi7QdX9CDDkPiU")
        
        window = UIWindow(frame: Screen.bounds)
        window!.rootViewController = DrawerNavigatorViewController(rootViewController: rootViewController, leftViewController: sidebarViewController, rightViewController: nil)
        window!.makeKeyAndVisible()
        
        return true
    }

}

