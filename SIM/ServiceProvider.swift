//
//  ServiceProvider.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class ServiceProvider : Object {

    @objc dynamic var uuid:String!
    @objc dynamic var serviceProviderName:String!
    
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    func toDictionary(serviceProvider:ServiceProvider) -> [String:Any] {
        return ["uuid":serviceProvider.uuid as String ,"serviceProviderName":serviceProvider.serviceProviderName as String ]
    }
    
    func toObject(serviceProviderDictionary:[String:Any]) -> ServiceProvider {
        let serviceProvider = ServiceProvider()
        serviceProvider.uuid = serviceProviderDictionary["uuid"] as! String!
        serviceProvider.serviceProviderName = serviceProviderDictionary["serviceProvider"] as! String!
        return serviceProvider
    }
}
