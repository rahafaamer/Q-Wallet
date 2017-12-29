//
//  Gender.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class Gender:Object {

    @objc dynamic var uuid:String!
    @objc dynamic  var genderName:String!

     override static func primaryKey() -> String? {
        return "uuid"
    }
    func toDictionary(gender:Gender) -> [String:Any] {
        var genderJson = [String:Any]()
        genderJson["uuid"] = gender.uuid as AnyObject
        genderJson["genderName"] = gender.genderName as AnyObject
        return genderJson 
    }
    
    func toObject(genderDictionary:[String:Any]) -> Gender {
        let gender = Gender()
        gender.uuid = genderDictionary["uuid"] as! String!
        gender.genderName = genderDictionary["genderName"] as! String!
        return gender
    }
}
