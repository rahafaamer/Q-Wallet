//
//  CustomerService.swift
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
import Alamofire
//class CustomerService {
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
//    func Save(customer:Customer,onComplete:@escaping (Int) -> Void){
//        customer.uuid = UUID().uuidString
//        setNilValueToObject(customer: customer)
//        var customerJson :[String:AnyObject] = objectToJson(customer: customer)
//        
//        let params:[String:Any] = [
//            "operation": "create" ,
//            "tableName":  "Customer" ,
//            "payload": ["Item":customerJson]
//        ]
//        
//        var request=URLRequest(url: URL(string: "https://i8w3g773f5.execute-api.us-east-1.amazonaws.com/qwalletProd/qwalletdynamodbmanager")!)
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")//Adds HTTP header to the receiver’s HTTP header dictionary.
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
//        } catch _ as NSError {
//            //err = error
//            request.httpBody = nil
//        }
//        // Define the request of the approveDocument service
//        let session = URLSession.shared
//        request.httpMethod = "POST" // Set the request method type
//        Alamofire.request(request).responseJSON{ (dataVal:DataResponse<Any>) in
//            print(dataVal)
//        }
//        
//        session.dataTask(with: request, completionHandler: {
//            (dataVal, response, error) in
//            guard let realResponse = response as? HTTPURLResponse,
//                realResponse.statusCode == 200 else {
//                    print("Not a 200 response")
//                    onComplete(0)
//                    return
//            }
//            do {
//                let jsonObject : NSDictionary = try JSONSerialization.jsonObject(with: dataVal!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                onComplete(1)
//                
//            }
//            catch {}
//            
//            
//            
//        }).resume()
//
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (Customer?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(Customer.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultCustomer = result as? Customer {
//                    onComplete(resultCustomer,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updatedCustomerObject:Customer,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldCustomer,status) in
//            if status == 1{
//                let updatedCustomer = oldCustomer
//                updatedCustomer?.address = updatedCustomerObject.address
//                
//                updatedCustomer?.birthDay = updatedCustomerObject.birthDay
//                updatedCustomer?.city = updatedCustomerObject.city
//                updatedCustomer?.country = updatedCustomerObject.country
//                updatedCustomer?.customerName = updatedCustomerObject.customerName
//                updatedCustomer?.email = updatedCustomerObject.email
//                updatedCustomer?.gender = updatedCustomerObject.gender
//                updatedCustomer?.housePhone = updatedCustomerObject.housePhone
//                updatedCustomer?.mailBox = updatedCustomerObject.mailBox
//                updatedCustomer?.maritalStatus = updatedCustomerObject.maritalStatus
//                updatedCustomer?.mobileNumber = updatedCustomerObject.mobileNumber
//                updatedCustomer?.nationality = updatedCustomerObject.nationality
//                updatedCustomer?.preferredLanguage = updatedCustomerObject.preferredLanguage
//                updatedCustomer?.qid = updatedCustomerObject.qid
//                updatedCustomer?.region = updatedCustomerObject.region
//                updatedCustomer?.rewardLocation = updatedCustomerObject.rewardLocation
//                updatedCustomer?.walletBalance = updatedCustomerObject.walletBalance
//                updatedCustomer?.workPhone = updatedCustomerObject.workPhone
//                updatedCustomer?.walletId = updatedCustomerObject.walletId
//                self.Save(customer: updatedCustomer! , onComplete: { (state) in
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
//    func scanWithExpression(userName:String,onComplete:@escaping (Int,Customer) -> Void) {
//        let scanExpression = AWSDynamoDBScanExpression()
//        scanExpression.filterExpression = "userName = :val"
//        scanExpression.expressionAttributeValues = [":val": userName]
//        
//        dynamoDBObjectMapper?.scan(Customer.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
//            if let error = task.error as NSError? {
//                print("The request failed. Error: \(error)")
//                let customer = Customer()
//                onComplete(0,customer!)
//            }else if let paginatedOutput = task.result {
//                let customers = paginatedOutput.items as! [Customer]
//                if customers.count != 0 {
//                onComplete(1,customers[0])
//                }
//                else
//                {
//                    let customer = Customer()
//                    onComplete(0,customer!)
//                }
//            }
//            return nil
//        })
//        
//    }
//    
//    func setNilValueToObject(customer:Customer) {
//        if customer.customerName == "" {
//            customer.customerName = nil
//        }
//        if customer.address == "" {
//            customer.address = nil
//        }
//        if customer.birthDay == "" {
//            customer.birthDay = nil
//        }
//        if customer.city.count == 0  {
//            customer.city = nil
//        }
//        else {
//            if ((customer.city["cityName"] as! String) == "") {
//                customer.city = nil
//            }
//        }
//        if customer.country.count == 0   {
//            customer.country = nil
//        }
//        else {
//            if ((customer.country["countryName"] as! String) == "") {
//                customer.country = nil
//            }
//        }
//        if customer.gender.count == 0 {
//            customer.gender = nil
//        }
//        else {
//            if ((customer.gender["genderName"] as! String) == "") {
//                customer.gender = nil
//            }
//        }
//        if customer.maritalStatus.count == 0 {
//            customer.maritalStatus = nil
//        }
//        else {
//            if ((customer.maritalStatus["maritalStatusName"] as! String) == "") {
//                customer.maritalStatus = nil
//            }
//        }
//        if customer.nationality.count == 0 {
//            customer.nationality = nil
//        }
//        else {
//            if ((customer.nationality["nationalityName"] as! String) == "") {
//                customer.nationality = nil
//            }
//        }
//        if customer.housePhone == "" {
//            customer.housePhone = nil
//        }
//        if customer.mailBox ==  "" {
//            customer.mailBox = nil
//        }
//        if customer.mobileNumber == "" {
//            customer.mobileNumber = nil
//        }
//        if customer.qid == "" {
//            customer.qid = nil
//        }
//        if customer.walletBalance == "" {
//            customer.walletBalance = nil
//        }
//        if customer.walletId == "" {
//            customer.walletId = nil
//        }
//        if customer.workPhone == "" {
//            customer.workPhone = nil
//        }
//        if customer.preferredLanguage.count == 0 {
//            customer.preferredLanguage = nil
//        }
//        else {
//            if ((customer.preferredLanguage["preferredLanguageName"] as! String) == "") {
//                customer.preferredLanguage = nil
//            }
//        }
//        if customer.rewardLocation.count == 0 {
//            customer.rewardLocation = nil
//        }
//        else {
//            if ((customer.rewardLocation["rewardLocationName"] as! String) == "") {
//                customer.rewardLocation = nil
//            }
//        }
//        if customer.region.count == 0 {
//            customer.region = nil
//        }
//        else {
//            if ((customer.region["regionName"] as! String) == "") {
//                customer.region = nil
//            }
//        }
//        
//        
//        
//    }
//    
//    func objectToJson(customer:Customer) -> [String:AnyObject] {
//        var customerJson =  ["uuid":customer.uuid as AnyObject ,"userName":customer.userName as AnyObject]
//        customerJson["qid"] = customer.qid as AnyObject?
//        customerJson["customerName"] = customer.customerName as AnyObject?
//        customerJson["gender"] = customer.gender as AnyObject?
//        customerJson["birthDay"] = customer.birthDay as AnyObject?
//        customerJson["nationality"] = customer.nationality as AnyObject?
//        customerJson["maritalStatus"] = customer.maritalStatus as AnyObject?
//        customerJson["mobileNumber"] = customer.mobileNumber as AnyObject?
//        customerJson["workPhone"] = customer.workPhone as AnyObject?
//        customerJson["housePhone"] = customer.housePhone as AnyObject?
//        customerJson["email"] = customer.email as AnyObject?
//        customerJson["preferredLanguage"] = customer.preferredLanguage as AnyObject?
//        customerJson["address"] = customer.address as AnyObject?
//        customerJson["country"] = customer.country as AnyObject?
//        customerJson["city"] = customer.city as AnyObject?
//        customerJson["mailBox"] = customer.mailBox as AnyObject?
//        customerJson["region"] = customer.region as AnyObject?
//        customerJson["rewardLocation"] = customer.rewardLocation as AnyObject?
//        customerJson["walletBalance"] = customer.walletBalance as AnyObject?
//        customerJson["walletId"] = customer.walletId as AnyObject?
//        return customerJson
//    }
//    
//    func scanEmail(userMail: String,onComplete:@escaping (Int) -> Void){
//       
//        let params:[String:Any] = [
//            "operation": "list" ,
//            "tableName":  "Customer" ,
//            "payload": [
//                "FilterExpression": "email = :val",
//                "ExpressionAttributeValues": [
//                    ":val": userMail
//                ]
//        ]
//        ]
//        var request=URLRequest(url: URL(string: "https://i8w3g773f5.execute-api.us-east-1.amazonaws.com/qwalletProd/qwalletdynamodbmanager")!)
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")//Adds HTTP header to the receiver’s HTTP header dictionary.
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
//        } catch _ as NSError {
//            //err = error
//            request.httpBody = nil
//        }
//        // Define the request of the approveDocument service
//        let session = URLSession.shared
//        request.httpMethod = "POST" // Set the request method type
//        session.dataTask(with: request, completionHandler: {
//            (dataVal, response, error) in
//            guard let realResponse = response as? HTTPURLResponse,
//                realResponse.statusCode == 200 else {
//                    print("Not a 200 response")
//                    onComplete(0)
//                    return
//            }
//            do {
//                let jsonObject : NSDictionary = try JSONSerialization.jsonObject(with: dataVal!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//    
//                if let resultsArray = jsonObject["Items"] as? [NSDictionary]{
//                    if(resultsArray.count != 0){
//                        onComplete(1)
//                    }
//                    else {
//                        onComplete(0)
//                    }
//                }
//            }
//            catch {}
//        }).resume()
//    }
//    

//}
