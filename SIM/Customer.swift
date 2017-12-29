//
//  Customer.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class Customer : Object {
    
    @objc dynamic  var uuid:String!
    @objc dynamic  var qid:String!
    @objc dynamic  var customerName:String!
    @objc dynamic  var gender:Gender!
    @objc dynamic  var birthDay:String!
    @objc dynamic  var nationality:Nationality!
    @objc dynamic  var maritalStatus:MaritalStatus!
    @objc dynamic  var mobileNumber:String!
    @objc dynamic  var workPhone:String!
    @objc dynamic  var housePhone:String!
    @objc dynamic  var email:String!
    @objc dynamic  var preferredLanguage:Languages!
    @objc dynamic  var address:String!
    @objc dynamic  var country:Country!
    @objc dynamic  var city:City!
    @objc dynamic  var mailBox:String!
    @objc dynamic  var region:Region!
    @objc dynamic  var rewardLocation:RewardLocation!
    @objc dynamic  var walletBalance:String!
    @objc dynamic  var walletId:String!
    @objc dynamic  var userName:String!
    
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    func toJson(customer:Customer) -> [String:AnyObject] {
        var customerJson =  ["uuid":customer.uuid as AnyObject ,"userName":customer.userName as AnyObject]
        customerJson["qid"] = customer.qid as AnyObject?
        customerJson["customerName"] = customer.customerName as AnyObject?
        if customer.gender != nil {
            customerJson["gender"] = Gender().toDictionary(gender:customer.gender) as AnyObject?
        }
        customerJson["birthDay"] = customer.birthDay as AnyObject?
        if customer.nationality != nil {
            customerJson["nationality"] = Nationality().toDictionary(nationality:customer.nationality) as AnyObject?
        }
        if customer.maritalStatus != nil {
            customerJson["maritalStatus"] = MaritalStatus().toDictionary(maritalStatus: customer.maritalStatus) as AnyObject
        }
        customerJson["mobileNumber"] = customer.mobileNumber as AnyObject?
        customerJson["workPhone"] = customer.workPhone as AnyObject?
        customerJson["housePhone"] = customer.housePhone as AnyObject?
        customerJson["email"] = customer.email as AnyObject?
        if customer.preferredLanguage != nil {
            customerJson["preferredLanguage"] = Languages().toDictionary(languages: customer.preferredLanguage) as AnyObject?
        }
        customerJson["address"] = customer.address as AnyObject?
        if customer.country != nil {
            customerJson["country"] = Country().toDictionary(country: customer.country ) as AnyObject?
        }
        if customer.city != nil {
            customerJson["city"] = City().toDictionary(city: customer.city) as AnyObject?
        }
        customerJson["mailBox"] = customer.mailBox as AnyObject?
        if customer.region != nil {
            customerJson["region"] = Region().toDictionary(region: customer.region) as AnyObject?
        }
        if customer.rewardLocation != nil {
            customerJson["rewardLocation"] = RewardLocation().toDictionary(rewardLocation: customer.rewardLocation) as AnyObject?
        }
        customerJson["walletBalance"] = customer.walletBalance as AnyObject?
        customerJson["walletId"] = customer.walletId as AnyObject?
        return customerJson
        
        
    }
    func toObject(customerJson:[String:AnyObject]) -> Customer {
        let customer = Customer()
        customer.uuid = customerJson["uuid"] as? String
        customer.userName = customerJson["userName"] as? String
        customer.qid  = customerJson["qid"] as? String
        customer.customerName = customerJson["customerName"] as? String
        if customerJson["gender"] != nil {
            customer.gender = Gender().toObject(genderDictionary: (customerJson["gender"]  as? [String:AnyObject])!)
        }
        customer.birthDay = customerJson["birthDay"] as? String
        if customerJson["nationality"] != nil {
            customer.nationality = Nationality().toObject(nationlityDictionary: (customerJson["nationality"] as? [String:AnyObject])!)
        }
        if customerJson["maritalStatus"] != nil {
            customer.maritalStatus = MaritalStatus().toObject(maritalStatusDictionary: (customerJson["maritalStatus"] as? [String:AnyObject])!)
        }
        customer.mobileNumber = customerJson["mobileNumber"]  as? String
        customer.workPhone = customerJson["workPhone"] as? String
        customer.housePhone  = customerJson["housePhone"] as? String
        customer.email  = customerJson["email"] as? String
        if customerJson["preferredLanguage"] != nil {
            customer.preferredLanguage = Languages().toObject(languagesDictionary: (customerJson["preferredLanguage"] as? [String:AnyObject])!)
        }
        customer.address = customerJson["address"]  as? String
        if customerJson["country"] != nil {
            customer.country = Country().toObject(countryDictionary: (customerJson["country"]  as? [String:AnyObject])!) }
        if customerJson["city"] != nil {
            customer.city = City().toObject(cityDictionary: (customerJson["city"] as? [String:AnyObject])!)
        }
        customer.mailBox = customerJson["mailBox"]  as? String
        if customerJson["region"] != nil{
            customer.region = Region().toObject(regionDictionary: (customerJson["region"] as? [String:AnyObject])!)
        }
        if customerJson["rewardLocation"] != nil {
            customer.rewardLocation = RewardLocation().toObject(rewardLocationDictionary: (customerJson["rewardLocation"] as? [String:AnyObject])!) }
        customer.walletBalance  = customerJson["walletBalance"] as? String
        customer.walletId  = customerJson["walletId"] as? String
        return customer
        
    }
    
    func setNilValueToObject(customer:Customer) {
        if customer.customerName == "" {
            customer.customerName = nil
        }
        if customer.address == "" {
            customer.address = nil
        }
        if customer.birthDay == "" {
            customer.birthDay = nil
        }
        if customer.city != nil {
            if customer.city.cityName == nil || customer.city.cityName == "" {
                customer.city = nil
            }
        }
        if customer.country != nil {
            if customer.country.countryName == nil || customer.country.countryName == "" {
                customer.country = nil
            }
        }
        if customer.gender != nil  {
            if customer.gender.genderName == nil || customer.gender.genderName == "" {
                customer.gender = nil
            }
            
        }
        if customer.maritalStatus != nil  {
            
            if  customer.maritalStatus.maritalStatusName == nil || customer.maritalStatus.maritalStatusName == "" {
                customer.maritalStatus = nil
            }
        }
        if customer.nationality != nil {
            if customer.nationality.nationalityName == nil || customer.nationality.nationalityName == ""{
                customer.nationality = nil
            }
        }
        
        if customer.housePhone == "" {
            customer.housePhone = nil
        }
        if customer.mailBox ==  "" {
            customer.mailBox = nil
        }
        if customer.mobileNumber == "" {
            customer.mobileNumber = nil
        }
        if customer.qid == "" {
            customer.qid = nil
        }
        if customer.walletBalance == "" {
            customer.walletBalance = nil
        }
        if customer.walletId == "" {
            customer.walletId = nil
        }
        if customer.workPhone == "" {
            customer.workPhone = nil
        }
        if customer.preferredLanguage != nil  {
            if customer.preferredLanguage.preferredLanguageName == nil || customer.preferredLanguage.preferredLanguageName == "" {
                customer.preferredLanguage = nil
            }
        }
        if customer.rewardLocation != nil {
            if customer.rewardLocation.rewardLocationName == nil  || customer.rewardLocation.rewardLocationName == "" {
                customer.rewardLocation = nil
            }
            
        }
        if customer.region != nil  {
            if customer.region.regionName == nil || customer.region.regionName == "" {
                customer.region = nil
            }
        }
        
        
    }
    
}
