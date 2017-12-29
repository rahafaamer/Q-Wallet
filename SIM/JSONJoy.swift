//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  JSONJoy.swift
//
//  Created by Dalton Cherry on 9/17/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class JSONDecoder {
    var value: AnyObject?
    
    //convert the value to a String
    open var string: String? {
        return value as? String
    }
    //convert the value to an Int
    open var integer: Int? {
        return value as? Int
    }
    //convert the value to a Double
    open var double: Double? {
        return value as? Double
    }
    //convert the value to a float
    open var float: Float? {
        return value as? Float
    }
    //treat the value as! a bool
    open var bool: Bool {
        if let str = self.string {
            let lower = str.lowercased()
            if lower == "true" || Int(lower) > 0 {
                return true
            }
        } else if let num = self.integer {
            return num > 0
        } else if let num = self.double {
            return num > 0.99
        } else if let num = self.float {
            return num > 0.99
        }
        return false
    }
    //get  the value if it is an error
    open var error: NSError? {
        return value as? NSError
    }
    //get  the value if it is a dictionary
    open var dictionary: Dictionary<String,JSONDecoder>? {
        return value as? Dictionary<String,JSONDecoder>
    }
    //get  the value if it is an array
    open var array: Array<JSONDecoder>? {
        return value as? Array<JSONDecoder>
    }
    //pull the raw values out of an array
    open func getArray<T>(_ collect: inout Array<T>?) {
        if let array = value as? Array<JSONDecoder> {
            if collect == nil {
                collect = Array<T>()
            }
            for decoder in array {
                if let obj = decoder.value as? T {
                    collect?.append(obj)
                }
            }
        }
    }
    //pull the raw values out of a dictionary.
    open func getDictionary<T>(_ collect: inout Dictionary<String,T>?) {
        if let dictionary = value as? Dictionary<String,JSONDecoder> {
            if collect == nil {
                collect = Dictionary<String,T>()
            }
            for (key,decoder) in dictionary {
                if let obj = decoder.value as? T {
                    collect?[key] = obj
                }
            }
        }
    }
    //the init that converts everything to something nice
    public init(_ raw: AnyObject) {
        var rawObject: AnyObject = raw
        if let data = rawObject as? Data {
            var error: NSError?
            var response: AnyObject?
            do {
                response = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as AnyObject
            } catch let error1 as NSError {
                error = error1
                response = nil
            }
            if error != nil || response == nil {
                value = error
                return
            }
            rawObject = response!
        }
        if let array = rawObject as? NSArray {
            var collect = [JSONDecoder]()
            for val: Any in array {
                collect.append(JSONDecoder(val as AnyObject))
            }
            value = collect as AnyObject?
        } else if let dict = rawObject as? NSDictionary {
            var collect = Dictionary<String,JSONDecoder>()
            for (key, val) in dict {
                collect[key as! String] = JSONDecoder(val as AnyObject)
            }
            value = collect as AnyObject?
        } else {
            value = rawObject
        }
    }
    //Array access support
    open subscript(index: Int) -> JSONDecoder {
        get {
            if let array = self.value as? NSArray {
                if array.count > index {
                    return array[index] as! JSONDecoder
                }
            }
            return JSONDecoder(createError("index: \(index) is greater than array or this is not an Array type."))
        }
    }
    //Dictionary access support
    open subscript(key: String) -> JSONDecoder {
        get {
            if let dict = self.value as? NSDictionary {
                if let value: Any = dict[key] {
                    return value as! JSONDecoder
                }
            }
            return JSONDecoder(createError("key: \(key) does not exist or this is not a Dictionary type"))
        }
    }
    func createError(_ text: String) -> NSError {
        return NSError(domain: "JSONJoy", code: 1002, userInfo: [NSLocalizedDescriptionKey: text]);
    }
}

//Implement this protocol on all objects you want to use JSONJoy with
public protocol JSONJoy {
    init(_ decoder: JSONDecoder)
}
