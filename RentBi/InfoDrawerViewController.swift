//
//  InfoDrawerViewController.swift
//  RentBi
//
//  Created by Nguyen Le Vu Long on 6/24/17.
//  Copyright © 2017 vteam. All rights reserved.
//

import UIKit
import Material
import Pulley

class InfoDrawerViewController: UIViewController, PulleyDrawerViewControllerDelegate {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var bikeIcon: UIImageView!
    @IBOutlet weak var mBikeIcon: UIImageView!
    @IBOutlet weak var bikePrice: UILabel!
    @IBOutlet weak var mBikePrice: UILabel!
    @IBOutlet weak var bikePriceLong: UILabel!
    @IBOutlet weak var mBikePriceLong: UILabel!
    @IBOutlet weak var routeButton: RaisedButton!
    @IBOutlet weak var contactButton: FlatButton!
    
    func renderShop(shop: Shop) {
        let _ = self.view
        name.text = shop.address
        distance.text = "0.0"
        bikePrice.text = shop.priceBike
        mBikePrice.text = shop.priceMBike
        bikePriceLong.text = shop.priceBikeLong
        mBikePriceLong.text = shop.priceMBikeLong
        routeButton.title = "Tìm đường"
        routeButton.backgroundColor = UIColor(red:0.27, green:0.70, blue:0.15, alpha:1.0)
        contactButton.title = shop.phone
        contactButton.titleColor = UIColor(red:0.27, green:0.70, blue:0.15, alpha:1.0)
    }
    
    func collapsedDrawerHeight() -> CGFloat {
        return 90.0
    }
    func partialRevealDrawerHeight() -> CGFloat {
        return 420.0
    }
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [.closed, .collapsed, .partiallyRevealed]
    }
    
    @IBAction func onRouteTap(_ sender: UIButton) {
    }
    @IBAction func onContactTap(_ sender: UIButton) {
    }
}
