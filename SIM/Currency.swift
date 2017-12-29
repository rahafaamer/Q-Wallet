//
//  Currency.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB


class Currency {
    
    var uuid:String!
    var currencyName:String!

    func toDictionary(currency:Currency) -> [String:Any] {
        return ["uuid":currency.uuid  as AnyObject ,"currencyName":currency.currencyName  as AnyObject]
    }
    
    func toObject(currencyDictionary:[String:Any]) -> Currency {
        let currency = Currency()
        currency.uuid = currencyDictionary["uuid"] as! String!
        currency.currencyName = currencyDictionary["currencyName"] as! String!
        return currency
    }

}
