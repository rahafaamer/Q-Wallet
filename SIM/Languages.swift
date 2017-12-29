//
//  PrefferedLanguage.swift
//  SIM
//
//  Created by SSS on 10/18/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import AWSDynamoDB
import RealmSwift

class Languages:Object {

    @objc dynamic var uuid:String!
    
    @objc dynamic var preferredLanguageName:String!
    override static func primaryKey() -> String? {
        return "uuid"
    }
    func toDictionary(languages:Languages) -> [String:Any] {
        return ["uuid":languages.uuid as AnyObject  ,"preferredLanguageName":languages.preferredLanguageName  as AnyObject]
    }
    
    func toObject(languagesDictionary:[String:Any]) -> Languages {
        let languages = Languages()
        languages.uuid = languagesDictionary["uuid"] as! String!
        languages.preferredLanguageName = languagesDictionary["preferredLanguageName"] as! String!
        return languages
    }

}
