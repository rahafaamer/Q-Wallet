////
////  BenificiaryTypeService.swift
////  SIM
////
////  Created by SSS on 10/19/17.
////  Copyright © 2017 SSS. All rights reserved.
////
//import Foundation
//import AWSDynamoDB
//import AWSS3
//import AWSSQS
//import AWSSNS
//
//
//class BeneficiaryTypeService {
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
//    
//    func Save(beneficiaryType:BeneficiaryType,onComplete:@escaping (Int) -> Void){
//        
//        beneficiaryType.uuid = UUID().uuidString
//        setNilValueToObject(beneficiaryType:beneficiaryType)
//        dynamoDBObjectMapper?.save(beneficiaryType, completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (BeneficiaryType?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(BeneficiaryType.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultTest = result as? BeneficiaryType {
//                    onComplete(resultTest,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updatedBeneficiaryObject:BeneficiaryType,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldBeneficiaryType,status) in
//            if status == 1{
//                let updatedBeneficiaryType = oldBeneficiaryType
//                updatedBeneficiaryType?.beneficiaryTypeName = updatedBeneficiaryObject.beneficiaryTypeName
//                self.Save(beneficiaryType: updatedBeneficiaryType! , onComplete: { (state) in
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
//    
//    func scan(onComplete:@escaping (Int,[String]) -> Void){
//        let scanExpression = AWSDynamoDBScanExpression()
//        scanExpression.limit = 20
//        
//        dynamoDBObjectMapper?.scan(BeneficiaryType.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
//            if let error = task.error as? NSError {
//                print("The request failed. Error: \(error)")
//                onComplete(0,[])
//            } else if let paginatedOutput = task.result {
//                var beneficiaryTypeNames = [String]()
//                for beneficiaryType in paginatedOutput.items as! [BeneficiaryType] {
//                    // Do something with book.
//                    beneficiaryTypeNames.append(beneficiaryType.beneficiaryTypeName)
//                }
//                onComplete(1,beneficiaryTypeNames)
//            }
//            return nil
//        })
//        
//    }
//    func setNilValueToObject(beneficiaryType:BeneficiaryType) {
//        if beneficiaryType.beneficiaryTypeName == "" {
//            beneficiaryType.beneficiaryTypeName = nil
//        }
//        
//    }
//}
