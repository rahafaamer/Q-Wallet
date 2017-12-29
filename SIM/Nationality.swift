//
//  Nationality.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import RealmSwift


class Nationality:Object {

    @objc dynamic var uuid:String!
    @objc dynamic var nationalityName:String!
    
    override static func primaryKey() -> String? {
    return "uuid"
  }
    func toDictionary(nationality:Nationality) -> [String:Any] {
        return ["uuid":nationality.uuid as AnyObject ,"nationalityName":nationality.nationalityName as AnyObject]
    }
    
    func toObject(nationlityDictionary:[String:Any]) -> Nationality {
        
        let nationality = Nationality()
        nationality.uuid = nationlityDictionary["uuid"] as! String!
        nationality.nationalityName = nationlityDictionary["nationalityName"] as! String!

        return nationality
    }

    
    
}
