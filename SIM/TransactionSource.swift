//
//  TransactionSource.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB


class TransactionSource :AWSDynamoDBObjectModel, AWSDynamoDBModeling{

    var uuid:String!
    
    var transactionSourceName:String!
    
    
    public static func dynamoDBTableName() -> String {
        
       
        return "TransactionSource"
    }
    
    class func hashKeyAttribute() -> String {
        return "uuid"
    }

}
