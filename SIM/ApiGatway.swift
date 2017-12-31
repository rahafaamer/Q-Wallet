//
//  GenericServices.swift
//  SIM
//
//  Created by SSS on 12/2/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import AWSS3
import AWSSQS
import AWSSNS
import Alamofire
import SwiftyXMLParser

class ApiGatway {
    
    static let api:ApiGatway = ApiGatway()
    
    let serverUrl = "https://i8w3g773f5.execute-api.us-east-1.amazonaws.com/qwalletProd/qwalletdynamodbmanager/"
    
    func scan (params:[String:Any],onComplete:@escaping (Int,[NSDictionary]) -> Void){
        var request=URLRequest(url: URL(string: serverUrl)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")//Adds HTTP header to the receiver’s HTTP header dictionary.
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch _ as NSError {
            request.httpBody = nil
        }
        request.httpMethod = "POST" // Set the request method type
        Alamofire.request(request).validate().responseJSON{ (jsonObject) in
            switch jsonObject.result {
            case .success:
                if let result = jsonObject.result.value {
                    let responseDict = result as! [String : Any]
                    let resultsArray = responseDict["Items"] as? [NSDictionary]
                    if resultsArray?.count != 0 && resultsArray != nil {
                        onComplete(1,resultsArray!)
                    }
                    else {
                        onComplete(0,[])
                    }
                }
            case .failure(let _):
                onComplete(0,[])
            }
        }
    }
    
    func save (params:[String:Any],onComplete:@escaping (Int) -> Void){
        var request=URLRequest(url: URL(string: serverUrl)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")//Adds HTTP header to the receiver’s HTTP header dictionary.
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch _ as NSError {
            request.httpBody = nil
        }
        request.httpMethod = "POST" // Set the request method type
        Alamofire.request(request).validate().responseJSON{ (jsonObject) in
            switch jsonObject.result {
            case .success:
                onComplete(1)
            case .failure( _):
                onComplete(0)
            }
        }
    }
    func getInformationOfMobileNumber(mobileNumber:String, onComplete:@escaping(Int) -> Void) {
        let jsonObject = ["action":"msisdn_info","destination_msisdn":mobileNumber,"key":String(Date().ticks)]
        print(jsonObject)
        var request=URLRequest(url: URL(string: "https://m2hpjsju9l.execute-api.us-east-1.amazonaws.com/prod/trasfertoservicemanager")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")//Adds HTTP header to the receiver’s HTTP header dictionary.
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        } catch _ as NSError {
            request.httpBody = nil
        }
        request.httpMethod = "POST" // Set the request method type
        Alamofire.request(request).validate().responseString(completionHandler: { response in
            var text = String(describing: response)
            // trim the string
            var trimString = text.trimmingCharacters(in: CharacterSet.newlines)
            // replace occurences within the string
            while let rangeToReplace = trimString.range(of: "\n\n") {
                trimString.replaceSubrange(rangeToReplace, with: "\n")
            }
             print(trimString)
            let xml = try! XML.parse(response.description)
            print(xml) // outputs the top title of iTunes app raning.
            let element = xml["TransferTo"] // -> XML.Accessor
            onComplete(1)
            
            
        })
    }
}

