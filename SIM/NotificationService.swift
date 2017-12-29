////
////  NotificationService.swift
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
//class NotificationService {
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
//func Save(walletNotification:WalletNotification,onComplete:@escaping (Int) -> Void){
//    walletNotification.uuid = UUID().uuidString
//    setNilValueToObject(notification: walletNotification)
//    dynamoDBObjectMapper?.save(walletNotification,configuration: updateMapperConfig, completionHandler: { (err) in
//        if err == nil {
//            onComplete(1)
//        }else{
//            print(err.debugDescription)
//            onComplete(0)
//        }
//    })
//}
//
//func load(hashKey:String,onComplete:@escaping (WalletNotification?,Int) -> Void) {
//    dynamoDBObjectMapper?.load(WalletNotification.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//        if err != nil {
//            onComplete(nil,0)
//        } else {
//            if let resultWallerNotification = result as? WalletNotification {
//                onComplete(resultWallerNotification,1)
//            }else{
//                onComplete(nil,0)
//            }
//        }
//    })
//}
//
//func update(hashKey:String,updatedNotificationObject:WalletNotification,onComplete:@escaping (Int) -> Void)  {
//    self.load(hashKey: hashKey) { (oldNotification,status) in
//        if status == 1{
//            let updatedNotification = oldNotification
//            updatedNotification?.notificationTime = updatedNotificationObject.notificationTime
//            updatedNotification?.text = updatedNotificationObject.text
//            updatedNotification?.title = updatedNotificationObject.title
//            updatedNotification?.transaction = updatedNotificationObject.transaction
//            self.Save(walletNotification: updatedNotification! , onComplete: { (state) in
//                if state == 1 {
//                    onComplete(1)
//                }else{
//                    onComplete(0)
//                }
//            })
//        }else{
//            onComplete(0)
//        }
//    }
//}
//    func setNilValueToObject(notification:WalletNotification) {
//        if notification.notificationTime == "" {
//            notification.notificationTime = nil
//        }
//        if notification.text == "" {
//            notification.text = nil
//        }
//        if notification.title == "" {
//            notification.title = nil
//        }
//        if (notification.transaction["uuid"] as! String) == "" {
//            notification.transaction = nil
//        }
//    }
//    
//}
