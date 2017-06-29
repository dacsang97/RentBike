//
//  API.swift
//  RentBi
//
//  Created by Nguyen Le Vu Long on 6/25/17.
//  Copyright © 2017 vteam. All rights reserved.
//

import Alamofire
import SwiftyJSON
import GoogleMaps

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
    
    static func callDirectionsAPI(origin: String, destination: String, callback: @escaping ((dist: String, polypoints: String)) -> Void) {
        Alamofire.request("https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=AIzaSyAvfWYM2-lqH4dNhMZVT4GLVbJzHwA8xdg").responseJSON { response in
            print(response.request)
            var json = JSON(data: response.data!)
            json = json["routes"][0]
            let dist = json["legs"][0]["distance"]["text"].stringValue
            let polypoints = json["overview_polyline"]["points"].stringValue
            callback((dist, polypoints))
        }
    }
}
