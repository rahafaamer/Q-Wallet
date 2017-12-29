////
////  RegionService.swift
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
//class RegionService {
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
//    func Save(region:Region,onComplete:@escaping (Int) -> Void){
//        region.uuid = UUID().uuidString
//        dynamoDBObjectMapper?.save(region,configuration: updateMapperConfig, completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (Region?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(Region.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultRegion = result as? Region {
//                    onComplete(resultRegion,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updatedRegionObject:Region,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldRegion,status) in
//            if status == 1{
//                let updatedRegion = oldRegion
//                updatedRegion?.regionName = updatedRegionObject.regionName
//        
//                self.Save(region:updatedRegion! , onComplete: { (state) in
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
//    
//    func scan(onComplete:@escaping (Int,[String]) -> Void){
//        let params:[String:Any] = [
//            "operation": "list" ,
//            "tableName":  "Region" ,
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
//                var regions = [String]()
//                if let resultsArray = jsonObject["Items"] as? [NSDictionary]{
//                    for result in resultsArray { // For each element in resultArray
//                        let region = result as? NSDictionary
//                        regions.append(region?["regionName"] as! String)
//                    }
//                    onComplete(1,regions)
//                    
//                }
//            }
//            catch {}
//        }).resume()
//    }
//
//    func setNilValueToObject(region:Region) {
//        if region.regionName == "" {
//            region.regionName = nil
//        }
//    }
//    
//}
