////
////  TelecomProviderService.swift
////  SIM
////
////  Created by SSS on 10/19/17.
////  Copyright © 2017 SSS. All rights reserved.
////
//
//
//import Foundation
//import AWSDynamoDB
//import AWSS3
//import AWSSQS
//import AWSSNS
//
//
//class TelecomProviderService  {
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
//    func Save(telecomProvider :TelecomProvider,onComplete:@escaping (Int) -> Void){
//        telecomProvider.uuid = UUID().uuidString
//        setNilValueToObject(telecomProvider: telecomProvider)
//        dynamoDBObjectMapper?.save(telecomProvider, configuration: updateMapperConfig,completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (TelecomProvider?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(TelecomProvider.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultTelecomProvider = result as? TelecomProvider {
//                    onComplete(resultTelecomProvider,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updateTelecomProviderObject:TelecomProvider,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldTelecomProvider,status) in
//            if status == 1{
//                let updateTelecomProvider = oldTelecomProvider
//                updateTelecomProvider?.telecomProviderName = updateTelecomProviderObject.telecomProviderName
//                self.Save(telecomProvider : updateTelecomProvider! , onComplete: { (status) in
//                    if status == 1 {
//                        onComplete(1)
//                    }else{
//                        onComplete(0)
//                        
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
//        dynamoDBObjectMapper?.scan(TelecomProvider.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
//            if let error = task.error as? NSError {
//                print("The request failed. Error: \(error)")
//                onComplete(0,[])
//            } else if let paginatedOutput = task.result {
//                var telecomProviderNames = [String]()
//                for telecomProvider in paginatedOutput.items as! [TelecomProvider] {
//                    // Do something with book.
//                    telecomProviderNames.append(telecomProvider.telecomProviderName)
//                }
//                onComplete(1,telecomProviderNames)
//            }
//            return nil
//        })
//        
//    }
//
//    func setNilValueToObject(telecomProvider:TelecomProvider) {
//       if  telecomProvider.telecomProviderName == "" {
//            telecomProvider.telecomProviderName = nil
//        }
//    }
//    
//    
//    
//}
