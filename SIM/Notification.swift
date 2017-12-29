//
//  Notification.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB


class WalletNotification {

    var uuid:String!
    var text:String!
    var title:String!
    var notificationTime:String!
    var transaction:[String:AnyObject]!
    
    func toDictionary() -> [String:Any] {
        return ["uuid":self.uuid as AnyObject ,"text":self.text as AnyObject , "title" : self.title as String ,"notificationTime" :self.notificationTime as AnyObject , "transaction" : self.transaction as AnyObject ]
    }
    
    func toObject(walletNotificationDictionary:[String:Any]) -> WalletNotification {
        
        let walletNotification = WalletNotification()
        walletNotification.uuid = walletNotificationDictionary["uuid"] as! String!
        walletNotification.text = walletNotificationDictionary["text"] as! String!
        walletNotification.title = walletNotificationDictionary["title"] as! String!
        walletNotification.notificationTime = walletNotificationDictionary["notificationTime"] as! String!
        walletNotification.transaction = walletNotificationDictionary["transaction"] as! [String : AnyObject]!

        return walletNotification
    }


    
}
