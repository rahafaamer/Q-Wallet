//
//  ExchangeHouseCity.swift
//  SIM
//
//  Created by Rimon on 11/6/17.
//  Copyright © 2017 SSS. All rights reserved.
//


import Foundation
import AWSDynamoDB


class  CityExchangeHouse:AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var uuid :String!
    
    var city:[String:AnyObject]!
    var exchangeHouse:[String:AnyObject]!
    
    public static func dynamoDBTableName() -> String {
        return "CityExchangeHouse"
    }
    
    class func hashKeyAttribute() -> String {
        return "uuid"
    }
}
