//
//  GenderService.swift
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

class GenderService {

    let updateMapperConfig : AWSDynamoDBObjectMapperConfiguration?
    let dynamoDBObjectMapper : AWSDynamoDBObjectMapper?
    
    init() {
        dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
        updateMapperConfig?.saveBehavior = .updateSkipNullAttributes
    }
    
//    func Save(gender:Gender,onComplete:@escaping (Int) -> Void){
//        gender.uuid = UUID().uuidString
//        setNilValueToObject(gender: gender)
//        dynamoDBObjectMapper?.save(gender,configuration: updateMapperConfig,completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
    
//    func load(hashKey:String,onComplete:@escaping (Gender?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(Gender.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultGender = result as? Gender {
//                    onComplete(resultGender,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updatedGenderObject:Gender,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldGender,status) in
//            if status == 1{
//                let updatedGender = oldGender
//                updatedGender?.ganderName = updatedGenderObject.ganderName
//                self.Save(gender: updatedGender! , onComplete: { (state) in
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
//    func setNilValueToObject(gender:Gender) {
//        if gender.ganderName == "" {
//            gender.ganderName = nil
//        }
//
//    }

    
}
