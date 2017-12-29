//
//  Transaction.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB


class Transaction :AWSDynamoDBObjectModel, AWSDynamoDBModeling{

    var uuid:String!
    var walletId:String!
    var transactionType:[String:AnyObject]!
    var beneficiary:[String:AnyObject]!
    var remittanceChannel:[String:AnyObject]!
    var sentAmount:String!
    var exchangeRate:String!
    var fees:String!
    var receivedAmount:String!
    var receivedCurrency:[String:AnyObject]!
    var totalAmount:String!
    var transactionStatus:[String:AnyObject]!
    var customer:Customer!
    var transactionSource:[String:AnyObject]!
    var transactionDate:String!

    public static func dynamoDBTableName() -> String {
        return "Transaction"
    }
    
    class func hashKeyAttribute() -> String {
        return "uuid"
    }
}
