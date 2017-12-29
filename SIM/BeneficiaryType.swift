//
//  BenificiaryType.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB

class BeneficiaryType {
    var uuid:String!
    var beneficiaryTypeName:String!
    
    
    func toDictionary(beneficiaryType:BeneficiaryType) -> [String:Any] {
        return ["uuid":beneficiaryType.uuid as String ,"beneficiaryTypeName":beneficiaryType.beneficiaryTypeName as String]
    }
    
    func toObject(BeneficiaryTypeDictionary:[String:Any]) -> BeneficiaryType {
        let beneficiaryType = BeneficiaryType()
        beneficiaryType.uuid = BeneficiaryTypeDictionary["uuid"] as! String!
        beneficiaryType.beneficiaryTypeName = BeneficiaryTypeDictionary["beneficiaryTypeName"] as! String!
        return beneficiaryType
    }
    
}
