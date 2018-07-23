//
//  Serializable.swift
//  CommonLib
//
//  Created by Geetanjali M on 12/07/18.
//  Copyright © 2018 Quadlogix. All rights reserved.
//

import Foundation

//DO NOT USE THIS CLASS NOW
protocol Serializable {
    var properties:Array<String> { get }
    func valueForKey(key: String) -> Any?
    func toDictionary() -> [String:Any]
}

extension Serializable {
    func toDictionary() -> [String:Any] {
        var dict:[String:Any] = [:]
        
        for prop in self.properties {
            if let val = self.valueForKey(key: prop) as? String {
                dict[prop] = val
            } else if let val = self.valueForKey(key: prop) as? Int {
                dict[prop] = val
            } else if let val = self.valueForKey(key: prop) as? Double {
                dict[prop] = val
            } else if let val = self.valueForKey(key: prop) as? Array<String> {
                dict[prop] = val
            } else if let val = self.valueForKey(key: prop) as? Serializable {
                dict[prop] = val.toDictionary()
            } else if let val = self.valueForKey(key: prop) as? Array<Serializable> {
                var arr = Array<[String:Any]>()
                
                for item in (val as Array<Serializable>) {
                    arr.append(item.toDictionary())
                }
                
                dict[prop] = arr
            }
        }
        
        return dict
    }
}
