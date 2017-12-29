//
//  TransactionType.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB


class  TransactionType:AWSDynamoDBObjectModel, AWSDynamoDBModeling {

    var uuid :String!
    
    var transactionTypeName:String!
    
   
    public static func dynamoDBTableName() -> String {
        return "TransactionType"
    }
    
    class func hashKeyAttribute() -> String {
        return "uuid"
    }
}
