//
//  DeviceService.swift
//  SIM
//
//  Created by SSS on 10/19/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import AWSS3
import AWSSQS
import AWSSNS

//class DeviceService {
//    let updateMapperConfig : AWSDynamoDBObjectMapperConfiguration?
//    let dynamoDBObjectMapper : AWSDynamoDBObjectMapper?
//    
//    init() {
//        dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
//        updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
//        updateMapperConfig?.saveBehavior = .updateSkipNullAttributes
//    }
//    
//    func Save(device:Device,onComplete:@escaping (Int) -> Void){
//        device.uuid = UUID().uuidString
//        setNilValueToObject(device: device)
//        dynamoDBObjectMapper?.save(device,configuration: updateMapperConfig,completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (Device?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(Device.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultDevice = result as? Device {
//                    onComplete(resultDevice,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updatedDeviceObject:Device,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldDevice,status) in
//            if status == 1{
//                let updatedDevice = oldDevice
//                updatedDevice?.customer = updatedDeviceObject.customer
//                updatedDevice?.deviceToken = updatedDeviceObject.deviceToken
//                updatedDevice?.isMainDevice = updatedDeviceObject.isMainDevice
//                self.Save(device: updatedDevice! , onComplete: { (state) in
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
//    func setNilValueToObject(device:Device) {
//        if device.deviceToken == "" {
//            device.deviceToken = nil
//        }
//        if (device.customer["userName"] as! String) == "" {
//         device.customer = nil
//        }
//        if device.isMainDevice == "" {
//            device.isMainDevice = nil
//        }
//    }
//    
//}
