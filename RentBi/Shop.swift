//
//  Shop.swift
//  RentBi
//
//  Created by Nguyen Le Vu Long on 6/25/17.
//  Copyright © 2017 vteam. All rights reserved.
//

import SwiftyJSON

struct Shop {
    var id: String!
    var type: String!
    var address: String!
    var phone: String!
    var x: Double!
    var y: Double!
    var description: String!
    var priceBike: String?
    var priceBikeLong: String?
    var priceMBike: String?
    var priceMBikeLong: String?
    
    init() {
        
    }
    init(json: JSON) {
        id = json["id"].stringValue
        switch json["type"].intValue {
            case 0: type = "park"
            case 1: type = "rent"
            case 2: type = "gas"
        default: type = "unknown"
        }
        address = json["address"].stringValue
        phone = json["phone"].stringValue
        x = json["x"].doubleValue
        y = json["y"].doubleValue
        description = json["description"].stringValue
        if type != "gas" {
            let priceJson = json["price"]
            priceBike = priceJson["price_bike"].stringValue
            priceBikeLong = priceJson["price_bike_detail"].stringValue
            priceMBike = priceJson["price_mbike"].stringValue
            priceMBikeLong = priceJson["price_mbike_detail"].stringValue
        }
    }
}
