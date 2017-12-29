//
//  Country.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class Country:Object {

     @objc dynamic  var uuid:String!
     @objc dynamic var countryName:String!
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    func toDictionary(country:Country) -> [String:Any] {
        
        return ["uuid":country.uuid  as AnyObject ,"countryName":country.countryName  as AnyObject]
    }
    
    func toObject(countryDictionary:[String:Any]) -> Country {
        
        let country = Country()
        country.uuid = countryDictionary["uuid"] as! String!
        country.countryName = countryDictionary["countryName"] as! String!
        return country
    }
    
}
