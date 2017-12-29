//
//  Bank.swift
//  SIM
//
//  Created by Rimon on 11/6/17.
//  Copyright © 2017 SSS. All rights reserved.
//


import Foundation
import AWSDynamoDB


class  Bank:AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var uuid :String!
    
    var BankName:String!
    
    
    public static func dynamoDBTableName() -> String {
        return "Bank"
    }
    
    class func hashKeyAttribute() -> String {
        return "uuid"
    }
}
