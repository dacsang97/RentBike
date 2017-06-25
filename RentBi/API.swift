//
//  API.swift
//  RentBi
//
//  Created by Nguyen Le Vu Long on 6/25/17.
//  Copyright © 2017 vteam. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct API {
    static func getNearbyShops(x: Double, y: Double, callback: @escaping ([Shop]) -> Void) {
        var shops: [Shop] = []
        Alamofire.request("http://rb.vteam.info/api/places").responseJSON { response in
            var json = JSON(data: response.data!)
            json = json["data"]
            for (_, shopJson):(String, JSON) in json {
                shops.append(Shop(json: shopJson))
            }
            callback(shops)
        }
    }
}
