//
//  City.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class City :Object {

    @objc dynamic var uuid:String!
    @objc dynamic var cityName:String!
    @objc dynamic var country:Country!
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    func toDictionary(city:City) -> [String:Any] {
        return ["uuid":city.uuid as AnyObject,"cityName":city.cityName as AnyObject, "country":city.country.toDictionary(country: city.country) as AnyObject]
    }
    
    func toObject(cityDictionary:[String:Any]) -> City {
        let city = City()
        city.uuid = cityDictionary["uuid"] as! String!
        city.cityName = cityDictionary["cityName"] as! String!
        city.country = Country().toObject(countryDictionary: cityDictionary["country"] as! [String : AnyObject]!)
        return city
    }
}
