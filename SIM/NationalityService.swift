//
//  NationalityService.swift
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
class NationalityService {
    
    let updateMapperConfig : AWSDynamoDBObjectMapperConfiguration?
    let dynamoDBObjectMapper : AWSDynamoDBObjectMapper?
    
    init() {
        dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
        updateMapperConfig?.saveBehavior = .updateSkipNullAttributes
    }
    
    
    func Save(nationality:Nationality,onComplete:@escaping (Int) -> Void){
//        nationality.uuid = UUID().uuidString
//        setNilValueToObject(nationality: nationality)
//        dynamoDBObjectMapper?.save(nationality,configuration: updateMapperConfig, completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
}
    
    func load(hashKey:String,onComplete:@escaping (Nationality?,Int) -> Void) {
        dynamoDBObjectMapper?.load(Nationality.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
            if err != nil {
                onComplete(nil,0)
            } else {
                if let resultNationality = result as? Nationality {
                    onComplete(resultNationality,1)
                }else{
                    onComplete(nil,0)
                }
            }
        })
    }
    
    func update(hashKey:String,updatedNationalityObject:Nationality,onComplete:@escaping (Int) -> Void)  {
        self.load(hashKey: hashKey) { (oldNationality,status) in
            if status == 1{
                let updatedNationality = oldNationality
                updatedNationality?.nationalityName = updatedNationalityObject.nationalityName
                self.Save(nationality:updatedNationality! , onComplete: { (state) in
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
    func setNilValueToObject(nationality:Nationality) {
       if  nationality.nationalityName == "" {
            nationality.nationalityName = nil
        }
    }
    
    func scan(onComplete:@escaping (Int,[String]) -> Void){
        let params:[String:Any] = [
            "operation": "list" ,
            "tableName":  "Nationality" ,
            "payload": []
        ]
        var request=URLRequest(url: URL(string: "https://i8w3g773f5.execute-api.us-east-1.amazonaws.com/qwalletProd/qwalletdynamodbmanager")!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")//Adds HTTP header to the receiver’s HTTP header dictionary.
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch _ as NSError {
            //err = error
            request.httpBody = nil
        }
        // Define the request of the approveDocument service
        request.httpMethod = "POST" // Set the request method type
        Alamofire.request(request).validate().responseJSON{ (jsonObject) in
            switch jsonObject.result {
                case .success:
                    
                if let result = jsonObject.result.value {
                    let responseDict = result as! [String : Any]
                    var nationalities = [String]()
                    let resultsArray = responseDict["Items"] as? [NSDictionary]
                        for result in resultsArray! { // For each element in resultArray
                            let nationality = result
                            nationalities.append(nationality["nationalityName"] as! String)
                        }
                        onComplete(1,nationalities)
                   
                }
                case .failure(let error):
                print(error)
            
            }
            
        }
        
}

}
