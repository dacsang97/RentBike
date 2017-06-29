//
//  MainPulleyViewController.swift
//  RentBi
//
//  Created by Nguyen Le Vu Long on 6/25/17.
//  Copyright © 2017 vteam. All rights reserved.
//

import UIKit
import Pulley
import GoogleMaps

class MainPulleyViewController: PulleyViewController {
    @IBOutlet weak var primaryContentContainerViewOutlet: UIView!
    @IBOutlet weak var drawerContentContainerViewOutlet: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        primaryContentContainerView = primaryContentContainerViewOutlet
        drawerContentContainerView = drawerContentContainerViewOutlet
        if let mainViewController = primaryContentViewController as? MainViewController {
            mainViewController.delegate = self
        }
        setDrawerPosition(position: PulleyPosition.closed)
    }
    
    func onShopSelected(_ shop: Shop, _ userY: Double, _ userX: Double) {
        let drawerContent = UIStoryboard.viewController(identifier: "InfoDrawerViewController") as! InfoDrawerViewController
        drawerContent.renderShop(shop: shop)
        setDrawerContentViewController(controller: drawerContent, animated: false)
        setDrawerPosition(position: PulleyPosition.collapsed)
        
        API.callDirectionsAPI(origin: "\(userY),\(userX)", destination: "\(shop.y!),\(shop.x!)") { (dist, polypoints) in
            if let drawerVC = self.drawerContentViewController as? InfoDrawerViewController {
                drawerVC.distance.text = dist
            }
            if let mapVC = self.primaryContentViewController as? MainViewController {
                if let path = GMSMutablePath(fromEncodedPath: polypoints) {
                    mapVC.drawPath(path)
                }
            }
        }
    }
    func onShopDeselected() {
        setDrawerPosition(position: PulleyPosition.closed)
        if let mapVC = self.primaryContentViewController as? MainViewController {
            mapVC.removePath()
        }
    }

}
