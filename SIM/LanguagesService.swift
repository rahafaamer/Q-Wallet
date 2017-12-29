////
////  LanguageService.swift
////  SIM
////
////  Created by SSS on 10/19/17.
////  Copyright © 2017 SSS. All rights reserved.
////
//
//
//import Foundation
//import AWSDynamoDB
//import AWSS3
//import AWSSQS
//import AWSSNS
//
//class LanguagesService {
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
//    func Save(languages:Languages,onComplete:@escaping (Int) -> Void){
//        languages.uuid = UUID().uuidString
//        setNilValueToObject(languages: languages)
//        dynamoDBObjectMapper?.save(languages,configuration: updateMapperConfig, completionHandler: { (err) in
//            if err == nil {
//                onComplete(1)
//            }else{
//                print(err.debugDescription)
//                onComplete(0)
//            }
//        })
//    }
//    
//    func load(hashKey:String,onComplete:@escaping (Languages?,Int) -> Void) {
//        dynamoDBObjectMapper?.load(Languages.self, hashKey: hashKey, rangeKey: nil, completionHandler: { (result, err) in
//            if err != nil {
//                onComplete(nil,0)
//            } else {
//                if let resultLanguages = result as? Languages {
//                    onComplete(resultLanguages,1)
//                }else{
//                    onComplete(nil,0)
//                }
//            }
//        })
//    }
//    
//    func update(hashKey:String,updatedLanguagesObject:Languages,onComplete:@escaping (Int) -> Void)  {
//        self.load(hashKey: hashKey) { (oldLanguages,status) in
//            if status == 1{
//                let updatedLanguages = oldLanguages
//                updatedLanguages?.preferredLanguageName = updatedLanguagesObject.preferredLanguageName
//                self.Save(languages:updatedLanguages! , onComplete: { (state) in
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
//    func setNilValueToObject(languages:Languages) {
//        if languages.preferredLanguageName == "" {
//            languages.preferredLanguageName = nil
//        }
//    }
//    
//func scan(onComplete:@escaping (Int,[String]) -> Void){
//        let params:[String:Any] = [
//            "operation": "list" ,
//            "tableName":  "Languages" ,
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
//                var jsonObject : NSDictionary = try JSONSerialization.jsonObject(with: dataVal!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                var languages = [String]()
//                if let resultsArray = jsonObject["Items"] as? [NSDictionary]{
//                    for result in resultsArray { // For each element in resultArray
//                        let language = result as? NSDictionary
//                        languages.append(language?["preferredLanguageName"] as! String)
//                    }
//                    onComplete(1,languages)
//                    
//                }
//            }
//            catch {}
//            
//        }).resume()
//    }
//}
