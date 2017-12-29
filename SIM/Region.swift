//
//  Region.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class Region :Object {

    @objc dynamic var uuid:String!
    @objc dynamic var regionName:String!
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    func toDictionary(region:Region) -> [String:Any] {
        return ["uuid":region.uuid as AnyObject,"regionName":region.regionName as AnyObject]
    }
    
    func toObject(regionDictionary:[String:Any]) -> Region {
        let region = Region()
        region.uuid = regionDictionary["uuid"] as! String!
        region.regionName = regionDictionary["regionName"] as! String!
        return region
    }
}
