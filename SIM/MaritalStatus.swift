//
//  MartialStatus.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class MaritalStatus :Object {

    @objc dynamic var uuid:String!
    @objc dynamic var maritalStatusName:String!
    
    

    override static func primaryKey() -> String? {
        return "uuid"
    }
    func toDictionary(maritalStatus:MaritalStatus) -> [String:Any] {
        return ["uuid":maritalStatus.uuid as AnyObject ,"maritalStatusName":maritalStatus.maritalStatusName  as AnyObject ]
    }
    
    func toObject(maritalStatusDictionary:[String:Any]) -> MaritalStatus {
        let maritalStatus = MaritalStatus()
        maritalStatus.uuid = maritalStatusDictionary["uuid"] as! String!
        maritalStatus.maritalStatusName = maritalStatusDictionary["maritalStatusName"] as! String!
        return maritalStatus
    }
}
