//
//  RemittanceChannel.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB


class RemittanceChannel :AWSDynamoDBObjectModel, AWSDynamoDBModeling{
    
    var uuid:String!
    var remittanceChannelName:String!
 
    
    
    public static func dynamoDBTableName() -> String {
        return "RemittanceChannel"
    }
    
    class func hashKeyAttribute() -> String {
        return "uuid"
    }
    
}
