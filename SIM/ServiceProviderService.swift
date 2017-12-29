////
////  ServiceProviderService.swift
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
//
//class ServiceProviderService  {
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
//    func Save(serviceProvider :ServiceProvider,onComplete:@escaping (Int) -> Void){
//        serviceProvider.uuid = UUID().uuidString
//        setNilValueToObject(serviceProvider: serviceProvider)
//        dynamoDBObjectMapper?.save(serviceProvider,configuration: updateMapperConfig, completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (ServiceProvider?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(ServiceProvider.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultServiceProvider = result as? ServiceProvider {
//                    onComplete(resultServiceProvider,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updateServiceProviderObject:ServiceProvider,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldServiceProvider,status) in
//            if status == 1{
//                let updateServiceProvider = oldServiceProvider
//                updateServiceProvider?.serviceProviderName = updateServiceProviderObject.serviceProviderName
//                self.Save(serviceProvider : updateServiceProvider! , onComplete: { (status) in
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
//    
//    func scan(onComplete:@escaping (Int,[String]) -> Void){
//        let scanExpression = AWSDynamoDBScanExpression()
//        scanExpression.limit = 20
//        
//        dynamoDBObjectMapper?.scan(ServiceProvider.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
//            if let error = task.error as? NSError {
//                print("The request failed. Error: \(error)")
//                onComplete(0,[])
//            } else if let paginatedOutput = task.result {
//                var serviceProviderNames = [String]()
//                for serviceprovider in paginatedOutput.items as! [ServiceProvider] {
//                    // Do something with book.
//                    serviceProviderNames.append(serviceprovider.serviceProviderName)
//                }
//                onComplete(1,serviceProviderNames)
//            }
//            return nil
//        })
//        
//    }
//    func setNilValueToObject(serviceProvider:ServiceProvider) {
//        if serviceProvider.serviceProviderName == "" {
//            serviceProvider.serviceProviderName = nil
//        }
//    }
//    
//    
//}
