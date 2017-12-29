//
//  TelecomProvider.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class TelecomProvider :Object{

    @objc dynamic var  uuid:String!
    @objc dynamic var telecomProviderName:String!
    
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    func toDictionary(telecomProvider:TelecomProvider) -> [String:Any] {
        return ["uuid":telecomProvider.uuid as String ,"telecomProviderName":telecomProvider.telecomProviderName as String ]
    }
    
    func toObject(telecomProviderDictionary:[String:Any]) -> TelecomProvider {
        let telecomProvider = TelecomProvider()
        telecomProvider.uuid = telecomProviderDictionary["uuid"] as! String!
        telecomProvider.telecomProviderName = telecomProviderDictionary["serviceProvider"] as! String!
        return telecomProvider
    }
}
