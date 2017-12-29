//
//  Benificiary.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift



class Beneficiary :Object{

    var uuid:String!
    var customer:Customer!
    var beneficiaryType:BeneficiaryType!
    var beneficiaryName:String!
    var mobileNumber:String!
    var workPhone:String!
    var housePhone:String!
    var email:String!
    var country:Country!
    var city:City!
    var bankName:String!
    var accountNumber:String!
    var iban:String!
    var serviceNumber:String!
    var serviceProvider:ServiceProvider!
    var walletId:String!    
    var telecomProvider:TelecomProvider!
    
    
    func toJson(beneficiary:Beneficiary) -> [String:Any] {
        
        var beneficiaryJson = [String:Any]()
        beneficiaryJson["uuid"]  = beneficiary.uuid as String?
        if beneficiary.customer != nil {
        beneficiaryJson["customer"] = Customer().toJson(customer: beneficiary.customer)  as AnyObject
        }
        if beneficiary.beneficiaryType != nil {
        beneficiaryJson["beneficiaryType"] = BeneficiaryType().toDictionary(beneficiaryType: beneficiary.beneficiaryType) as AnyObject
        }
        beneficiaryJson["beneficiaryName"] = beneficiary.beneficiaryName as String?
        beneficiaryJson["mobileNumber"] = beneficiary.mobileNumber as String?
        beneficiaryJson["workPhone"] = beneficiary.workPhone as String?
        beneficiaryJson["housePhone"] = beneficiary.housePhone as String?
        beneficiaryJson["email"] = beneficiary.email as String?
        if beneficiary.country != nil {
        beneficiaryJson["country"] = Country().toDictionary(country: beneficiary.country ) as AnyObject
        }
        if beneficiary.city != nil {

        beneficiaryJson["city"] = City().toDictionary(city:beneficiary.city ) as AnyObject
        }
        beneficiaryJson["bankName"] = beneficiary.bankName as String?
        beneficiaryJson["accountNumber"] = beneficiary.accountNumber as String?
        beneficiaryJson["iban"] = beneficiary.iban as String?
        beneficiaryJson["serviceNumber"] = beneficiary.serviceNumber as String?
        if beneficiary.serviceProvider != nil {
        beneficiaryJson["serviceProvider"] = ServiceProvider().toDictionary(serviceProvider: beneficiary.serviceProvider) as AnyObject
        }
        beneficiaryJson["walletId"] = beneficiary.walletId as String?
        if beneficiary.telecomProvider != nil {

        beneficiaryJson["telecomProvider"] = TelecomProvider().toDictionary(telecomProvider: beneficiary.telecomProvider) as AnyObject
        }
        return beneficiaryJson
    }
        

    func toObject(beneficiaryJson:[String:Any]) -> Beneficiary {
        let beneficiary = Beneficiary()
        beneficiary.uuid = beneficiaryJson["uuid"] as? String
        beneficiary.customer = Customer().toObject(customerJson:(beneficiaryJson["customer"] as? [String:AnyObject])!)
        beneficiary.beneficiaryType  = BeneficiaryType().toObject(BeneficiaryTypeDictionary: (beneficiaryJson["beneficiaryType"] as? [String:Any])!)
        beneficiary.beneficiaryName = beneficiaryJson["beneficiaryName"] as? String
        beneficiary.mobileNumber = beneficiaryJson["mobileNumber"] as? String
        beneficiary.workPhone = beneficiaryJson["workPhone"] as? String
        beneficiary.housePhone = beneficiaryJson["housePhone"] as? String
        beneficiary.email = beneficiaryJson["email"] as? String
        beneficiary.country = Country().toObject(countryDictionary:(beneficiaryJson["country"]  as? [String:Any])!)
        beneficiary.city = City().toObject(cityDictionary:(beneficiaryJson["city"] as? [String:Any])!)
        beneficiary.bankName  = beneficiaryJson["bankName"] as? String
        beneficiary.accountNumber  = beneficiaryJson["accountNumber"] as? String
        beneficiary.iban  = beneficiaryJson["iban"] as? String
        beneficiary.serviceNumber  = beneficiaryJson["serviceNumber"] as? String
        beneficiary.telecomProvider  = TelecomProvider().toObject(telecomProviderDictionary: (beneficiaryJson["telecomProvider"] as? [String:Any])!)
        beneficiary.serviceProvider  = ServiceProvider().toObject(serviceProviderDictionary: (beneficiaryJson["serviceProvider"] as? [String:Any])!)
        return beneficiary
    }
    
    func setNilValueToObject(beneficiary:Beneficiary) {
        if beneficiary.accountNumber != nil {
            if beneficiary.accountNumber == "" {
            beneficiary.accountNumber = nil
            }
        }
        if beneficiary.bankName != nil {
            if  beneficiary.bankName == "" {
            beneficiary.bankName = nil
            }
        }
        if beneficiary.beneficiaryName != nil { if beneficiary.beneficiaryName == "" {
            beneficiary.beneficiaryName = nil
            }
        }
        if beneficiary.beneficiaryType != nil {
            if beneficiary.beneficiaryType.beneficiaryTypeName == nil || beneficiary.beneficiaryType.beneficiaryTypeName == "" {
                beneficiary.beneficiaryType = nil
            }
        }

        if beneficiary.city != nil {
            if beneficiary.city.cityName == nil || beneficiary.city.cityName == "" {
                beneficiary.city = nil
            }
        }
        if beneficiary.country != nil {
            if beneficiary.country.countryName == nil || beneficiary.country.countryName == "" {
                beneficiary.country = nil
            }
        }
        if beneficiary.customer != nil {
            if beneficiary.customer.uuid == nil || beneficiary.customer.uuid == "" {
                beneficiary.customer = nil
            }
        }
        if beneficiary.serviceProvider != nil {
            if beneficiary.serviceProvider.serviceProviderName == nil || beneficiary.serviceProvider.serviceProviderName == "" {
                beneficiary.serviceProvider = nil
            }
        }
        
       
        if beneficiary.email != nil {
            if beneficiary.email == "" {
                beneficiary.email = nil
                
            }
        }
        if beneficiary.housePhone != nil {
            if beneficiary.housePhone == "" {
                beneficiary.housePhone = nil
            }
        }
        if beneficiary.workPhone != nil {
            if  beneficiary.workPhone == "" {
            beneficiary.workPhone = nil
            }
        }
        if beneficiary.mobileNumber != nil {
         if  beneficiary.mobileNumber == "" {
            beneficiary.mobileNumber = nil
            }
        }
        if beneficiary.serviceNumber != nil {
            if beneficiary.serviceNumber == "" {
            beneficiary.serviceNumber = nil
            }
        }
        if beneficiary.walletId != nil { if  beneficiary.walletId == "" {
            beneficiary.walletId = nil
            }
        }
        if beneficiary.iban != nil { if  beneficiary.iban == "" {
            beneficiary.iban = nil
            }
        }
    }
    
   
}
