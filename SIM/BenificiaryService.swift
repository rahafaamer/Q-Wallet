////
////  BenificiaryService.swift
////  SIM
////
////  Created by SSS on 10/19/17.
////  Copyright © 2017 SSS. All rights reserved.
////
//
//import Foundation
//import AWSDynamoDB
//import AWSS3
//import AWSSQS
//import AWSSNS
//
//class BeneficiaryService {
//    
//    let updateMapperConfig : AWSDynamoDBObjectMapperConfiguration?
//    let dynamoDBObjectMapper : AWSDynamoDBObjectMapper?
//    
//    init() {
//        dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
//        updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
//        updateMapperConfig?.saveBehavior = .updateSkipNullAttributes
//    }
//    
//    func Save(beneficiary:Beneficiary,onComplete:@escaping (Int) -> Void){
//        beneficiary.uuid = UUID().uuidString
//     //   setNilValueToObject(beneficiary: beneficiary)
//        dynamoDBObjectMapper?.save(beneficiary,configuration: updateMapperConfig, completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (Beneficiary?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(Beneficiary.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultTest = result as? Beneficiary {
//                    onComplete(resultTest,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updatedBeneficiaryObject:Beneficiary,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldBeneficiary,status) in
//            if status == 1{
//                let updatedBeneficiary = oldBeneficiary
//                updatedBeneficiary?.accountNumber = updatedBeneficiaryObject.accountNumber
//                updatedBeneficiary?.bankName = updatedBeneficiaryObject.bankName
//                updatedBeneficiary?.beneficiaryName = updatedBeneficiaryObject.beneficiaryName
//                updatedBeneficiary?.beneficiaryType = updatedBeneficiaryObject.beneficiaryType
//                updatedBeneficiary?.city = updatedBeneficiaryObject.city
//                updatedBeneficiary?.country = updatedBeneficiaryObject.country
//                updatedBeneficiary?.customer = updatedBeneficiaryObject.customer
//                updatedBeneficiary?.email = updatedBeneficiaryObject.email
//                updatedBeneficiary?.accountNumber = updatedBeneficiaryObject.accountNumber
//                updatedBeneficiary?.iban = updatedBeneficiaryObject.iban
//                updatedBeneficiary?.telecomProvider = updatedBeneficiaryObject.telecomProvider
//                updatedBeneficiary?.serviceProvider = updatedBeneficiaryObject.serviceProvider
//                updatedBeneficiary?.serviceNumber = updatedBeneficiaryObject.serviceNumber
//                updatedBeneficiary?.walletId = updatedBeneficiaryObject.walletId
//                self.Save(beneficiary: updatedBeneficiary! , onComplete: { (state) in
//                    if state == 1 {
//                        onComplete(1)
//                    }else{
//                        onComplete(0)
//                    }
//                })
//            }else{
//                onComplete(0)
//            }
//        }
//    }
//    func scanWithExpression(beneficiaryTypeName:String,customerName:String,onComplete:@escaping (Int,[Beneficiary]) -> Void) {
//        let scanExpression = AWSDynamoDBScanExpression()
//        scanExpression.filterExpression = "beneficiaryType.beneficiaryTypeName = :val AND customer.userName = :userVal"
//        scanExpression.expressionAttributeValues = [":val": beneficiaryTypeName,":userVal": customerName]
//        dynamoDBObjectMapper?.scan(Beneficiary.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
//            if let error = task.error as NSError? {
//                print("The request failed. Error: \(error)")
//                onComplete(0,[Beneficiary]())
//            }else if let paginatedOutput = task.result {
//                let beneficiaries = paginatedOutput.items as! [Beneficiary]
//                if beneficiaries.count != 0 {
//                    onComplete(1,beneficiaries)
//                }
//                else
//                {
//                    onComplete(0,[Beneficiary]())
//                }
//            }
//            return nil
//        })
//    }
//    
//    func setNilValueToObject(beneficiary:Beneficiary) {
//        if beneficiary.accountNumber != nil { if beneficiary.accountNumber == "" {
//            beneficiary.accountNumber = nil
//        }
//        }
//        if beneficiary.bankName != nil {if  beneficiary.bankName == "" {
//            beneficiary.bankName = nil
//        }
//        }
//        if beneficiary.beneficiaryName != nil { if beneficiary.beneficiaryName == "" {
//            beneficiary.beneficiaryName = nil
//        }
//        }
//        if beneficiary.beneficiaryType != nil {
//            if  beneficiary.beneficiaryType.count == 0  {
//                beneficiary.beneficiaryType = nil
//            }
//            else {
//                if ((beneficiary.beneficiaryType["beneficiaryTypeName"] as! String) == "") {
//                    beneficiary.beneficiaryType = nil
//                }
//            }
//        }
//      if beneficiary.city != nil {
//        if  beneficiary.city.count == 0  {
//            beneficiary.city = nil
//        }
//        else {
//            if ((beneficiary.city["cityName"] as! String) == "") {
//                beneficiary.city = nil
//            }
//        }
//            }
//              if beneficiary.country != nil {
//        if  beneficiary.country.count == 0   {
//            beneficiary.country = nil
//        }
//        else {
//            if ((beneficiary.country["countryName"] as! String) == "") {
//                beneficiary.country = nil
//            }
//        }
//            }
//        if beneficiary.customer != nil
//        {if  beneficiary.customer.count == 0  {
//            beneficiary.customer = nil
//        }
//        else {
//            if ((beneficiary.customer["uuid"] as! String) == "") {
//                beneficiary.customer = nil
//            }
//        }
//            }
//            if beneficiary.serviceProvider != nil
//            {if  beneficiary.serviceProvider.count == 0  {
//                beneficiary.serviceProvider = nil
//            }
//            else {
//                if ((beneficiary.serviceProvider["serviceProviderName"] as! String) == "") {
//                    beneficiary.serviceProvider = nil
//                }
//                }
//            }
//            
//        if beneficiary.email != nil {
//            if beneficiary.email == "" {
//                beneficiary.email = nil
//            
//        }
//        }
//        
//        if beneficiary.housePhone != nil {
//            if beneficiary.housePhone == "" {
//            beneficiary.housePhone = nil
//        }
//        }
//        if beneficiary.workPhone != nil { if  beneficiary.workPhone == "" {
//            beneficiary.workPhone = nil
//        }
//        }
//        if beneficiary.mobileNumber != nil { if  beneficiary.mobileNumber == "" {
//            beneficiary.mobileNumber = nil
//        }
//        }
//        if beneficiary.serviceNumber != nil {if beneficiary.serviceNumber == "" {
//            beneficiary.serviceNumber = nil
//        }
//        }
//        
//        if beneficiary.walletId != nil { if  beneficiary.walletId == "" {
//            beneficiary.walletId = nil
//        }
//        }
//        
//        if beneficiary.iban != nil { if  beneficiary.iban == "" {
//            beneficiary.iban = nil
//            }
//        }
//    }
//    
//}
//
