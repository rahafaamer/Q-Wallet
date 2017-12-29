//
//  RemittanceChannelService.swift
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

class RemittanceChannelService {
    
    let updateMapperConfig : AWSDynamoDBObjectMapperConfiguration?
    let dynamoDBObjectMapper : AWSDynamoDBObjectMapper?
    
    init() {
        dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
        updateMapperConfig?.saveBehavior = .updateSkipNullAttributes
    }
    
    
    func Save(remittanceChannel:RemittanceChannel,onComplete:@escaping (Int) -> Void){
        remittanceChannel.uuid = UUID().uuidString
        setNilValueToObject(remittanceChannel: remittanceChannel)
        dynamoDBObjectMapper?.save(remittanceChannel,configuration: updateMapperConfig, completionHandler: { (err) in
            if err == nil {
                onComplete(1)
            }else{
                print(err.debugDescription)
                onComplete(0)
            }
        })
    }
    
    func load(hashKey:String,onComplete:@escaping (RemittanceChannel?,Int) -> Void) {
        dynamoDBObjectMapper?.load(RemittanceChannel.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
            if err != nil {
                onComplete(nil,0)
            } else {
                if let resultRemittanceChannel = result as? RemittanceChannel {
                    onComplete(resultRemittanceChannel,1)
                }else{
                    onComplete(nil,0)
                }
            }
        })
    }
    
    func update(hashKey:String,updatedRemittanceChannelObject:RemittanceChannel,onComplete:@escaping (Int) -> Void)  {
        self.load(hashKey: hashKey) { (oldRemittanceChannel,status) in
            if status == 1{
                let updatedRemittanceChannel = oldRemittanceChannel
                updatedRemittanceChannel?.remittanceChannelName = updatedRemittanceChannelObject.remittanceChannelName
                self.Save(remittanceChannel:updatedRemittanceChannel! , onComplete: { (state) in
                    if state == 1 {
                        onComplete(1)
                    }else{
                        onComplete(0)
                    }
                })
            }else{
                onComplete(0)
            }
        }
    }
    func setNilValueToObject(remittanceChannel:RemittanceChannel) {
        if remittanceChannel.remittanceChannelName == "" {
            remittanceChannel.remittanceChannelName = nil
        }
    }

}
