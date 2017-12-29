//
//  TransactionStatus.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB


class TransactionStatus:AWSDynamoDBObjectModel, AWSDynamoDBModeling {

    var uuid:String!
    
    var transactionStatusName:String!

    
    
    public static func dynamoDBTableName() -> String {
        return "TransactionStatus"
    }
    
    class func hashKeyAttribute() -> String {
        return "uuid"
    }
}
