//
//  BankService.swift
//  SIM
//
//  Created by Rimon on 11/6/17.
//  Copyright © 2017 SSS. All rights reserved.
//


import Foundation
import AWSDynamoDB
import AWSS3
import AWSSQS
import AWSSNS


class BankService  {
    let updateMapperConfig : AWSDynamoDBObjectMapperConfiguration?
    let dynamoDBObjectMapper : AWSDynamoDBObjectMapper?
    
    init() {
        dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
        updateMapperConfig?.saveBehavior = .updateSkipNullAttributes
    }
    
    
    func Save(bank :Bank,onComplete:@escaping (Int) -> Void){
        bank.uuid = UUID().uuidString
        setNilValueToObject(bank: bank)
        dynamoDBObjectMapper?.save(bank, configuration: updateMapperConfig,completionHandler: { (err) in
            if err == nil {
                onComplete(1)
            }else{
                print(err.debugDescription)
                onComplete(0)
            }
        })
    }
    
    func load(hashKey:String,onComplete:@escaping (Bank?,Int) -> Void) {
        dynamoDBObjectMapper?.load(Bank.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
            if err != nil {
                onComplete(nil,0)
            } else {
                if let resultBank = result as? Bank {
                    onComplete(resultBank,1)
                }else{
                    onComplete(nil,0)
                }
            }
        })
    }
    
    func update(hashKey:String,bankObject:Bank,onComplete:@escaping (Int) -> Void)  {
        self.load(hashKey: hashKey) { (oldBank,status) in
            if status == 1{
                let updateBank = oldBank
                updateBank?.BankName = bankObject.BankName
                self.Save(bank: updateBank! , onComplete: { (status) in
                    if status == 1 {
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
    
    
    func scan(onComplete:@escaping (Int,[String]) -> Void){
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
        
        dynamoDBObjectMapper?.scan(Bank.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
                onComplete(0,[])
            } else if let paginatedOutput = task.result {
                var bankNames = [String]()
                for bank in paginatedOutput.items as! [Bank] {
                    // Do something with book.
                    bankNames.append(bank.BankName)
                }
                onComplete(1,bankNames)
            }
            return nil
        })
        
    }
    func setNilValueToObject(bank:Bank) {
       if  bank.BankName == "" {
            bank.BankName = nil
        }
    }
    
    
}
