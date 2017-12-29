//
//  RewardLocation.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class RewardLocation:Object {

    @objc dynamic var uuid:String!
    @objc dynamic var rewardLocationName:String!
    
   
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    func toDictionary(rewardLocation:RewardLocation) -> [String:Any] {
        return ["uuid":rewardLocation.uuid as String ,"rewardLocationName":rewardLocation.rewardLocationName as String ]
    }
    
    func toObject(rewardLocationDictionary:[String:Any]) -> RewardLocation {
        let rewardLocation = RewardLocation()
        rewardLocation.uuid = rewardLocationDictionary["uuid"] as! String!
        rewardLocation.rewardLocationName = rewardLocationDictionary["rewardLocationName"] as! String!
        return rewardLocation
    }
    

}
