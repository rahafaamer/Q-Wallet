//
//  Device.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB


class Device {
    var uuid:String!
    var customer:Customer!
    var deviceToken:String!
    var isMainDevice:String!
    
    func toDictionary(device:Device) -> [String:Any] {
        return ["uuid":device.uuid  as AnyObject ,"customer":Customer().toJson(customer:device.customer) as AnyObject, "deviceToken":device.deviceToken as AnyObject  ,"isMainDevice":device.isMainDevice as AnyObject ]
    }
    
    func toObject(deviceDictionary:[String:Any]) -> Device {
        let device = Device()
        device.uuid = deviceDictionary["uuid"] as! String!
        device.customer = Customer().toObject(customerJson: deviceDictionary["customer"] as! [String : Any] as [String : AnyObject])
        device.deviceToken = deviceDictionary["deviceToken"] as! String!
        device.isMainDevice = deviceDictionary["isMainDevice"] as! String!
        return device
    }



}
