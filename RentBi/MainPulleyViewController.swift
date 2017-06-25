//
//  MainPulleyViewController.swift
//  RentBi
//
//  Created by Nguyen Le Vu Long on 6/25/17.
//  Copyright © 2017 vteam. All rights reserved.
//

import UIKit
import Pulley

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
    
    func onShopSelected(_ shop: Shop) {
        let drawerContent = UIStoryboard.viewController(identifier: "InfoDrawerViewController") as! InfoDrawerViewController
        drawerContent.renderShop(shop: shop)
        setDrawerContentViewController(controller: drawerContent, animated: false)
        setDrawerPosition(position: PulleyPosition.collapsed)
    }
    func onShopDeselected() {
        setDrawerPosition(position: PulleyPosition.closed)
    }

}
