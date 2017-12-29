////
////  RewardLocationService.swift
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
//class RewardLocationService  {
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
//    func Save(rewaredLocation :RewardLocation,onComplete:@escaping (Int) -> Void){
//        rewaredLocation.uuid = UUID().uuidString
//        setNilValueToObject(rewardLocation: rewaredLocation)
//        dynamoDBObjectMapper?.save(rewaredLocation,configuration: updateMapperConfig, completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (RewardLocation?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(RewardLocation.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultRewardLocation = result as? RewardLocation {
//                    onComplete(resultRewardLocation,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//
//
//    func update(hashKey:String,updatedRewardLocationObject:RewardLocation,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldRewardLocation,status) in
//            if status == 1{
//                let updateRewardLoacation = oldRewardLocation
//                updateRewardLoacation?.rewardLocationName = updatedRewardLocationObject.rewardLocationName
//                self.Save(rewaredLocation : updateRewardLoacation! , onComplete: { (status) in
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
//    func setNilValueToObject(rewardLocation:RewardLocation) {
//        if rewardLocation.rewardLocationName == "" {
//            rewardLocation.rewardLocationName = nil
//        }
//    }
//    
//    
//    
//}
