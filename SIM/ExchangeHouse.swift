//
//  ExchangeHouse.swift
//  SIM
//
//  Created by Rimon on 11/6/17.
//  Copyright © 2017 SSS. All rights reserved.
//


import Foundation
import AWSDynamoDB


class  ExchangeHouse:AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var uuid :String!
    
    var exchangeHouseName:String!
    
    
    public static func dynamoDBTableName() -> String {
        return "ExchangeHouse"
    }
    
    class func hashKeyAttribute() -> String {
        return "uuid"
    }
}
