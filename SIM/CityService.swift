////
////  CityService.swift
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
//class CityService {
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
//    func Save(city:City,onComplete:@escaping (Int) -> Void){
//        city.uuid = UUID().uuidString
//        setNilValueToObject(city: city)
//        dynamoDBObjectMapper?.save(city, configuration: updateMapperConfig,completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (City?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(City.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultCity = result as? City {
//                    onComplete(resultCity,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updatedCityObject:City,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldCity,status) in
//            if status == 1{
//                let updatedCity = oldCity
//                updatedCity?.cityName = updatedCityObject.cityName
//                updatedCity?.country = updatedCity?.country
//                self.Save(city: updatedCity! , onComplete: { (state) in
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
//    func scan(onComplete:@escaping (Int,[String]) -> Void){
//        let params:[String:Any] = [
//            "operation": "list" ,
//            "tableName":  "City" ,
//            "payload": []
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
//                    onComplete(0,[])
//                    return
//            }
//            do {
//                let jsonObject : NSDictionary = try JSONSerialization.jsonObject(with: dataVal!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                var cities = [String]()
//                if let resultsArray = jsonObject["Items"] as? [NSDictionary]{
//                    for result in resultsArray { // For each element in resultArray
//                        let city = result as? NSDictionary
//                        cities.append(city?["cityName"] as! String)
//                    }
//                    onComplete(1,cities)
//                    
//                }
//            }
//            catch {}
//        }).resume()
//    }
//
//    func setNilValueToObject(city:City) {
//        if city.cityName == "" {
//            city.cityName = nil
//        }
//        
//    }
//  
//    func scanWithExpression(countryName:String,onComplete:@escaping (Int,[City]) -> Void) {
//        let scanExpression = AWSDynamoDBScanExpression()
//        scanExpression.filterExpression = "country.countryName = :val"
//        scanExpression.expressionAttributeValues = [":val": countryName]
//        
//        dynamoDBObjectMapper?.scan(City.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
//            if let error = task.error as NSError? {
//                print("The request failed. Error: \(error)")
//                onComplete(0,[City]())
//            }else if let paginatedOutput = task.result {
//                let cities = paginatedOutput.items as! [City]
//                if cities.count != 0 {
//                    onComplete(1,cities)
//                }
//                else
//                {
//                    onComplete(0,[City]())
//                }
//            }
//            return nil
//        })
//    }
//}
