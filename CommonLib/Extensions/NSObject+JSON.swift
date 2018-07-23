//
//  NSObject+JSON.swift
//  CommonLib
//
//  Created by Geetanjali M on 12/07/18.
//  Copyright © 2018 Quadlogix. All rights reserved.
//

import Foundation


public extension NSObject
{
    //MARK -Introspection Methods
    open func toJSON() -> String?
    {
        //FIXME - Fix the JSON String conversion
        do {
            let dictionary = self.toDictionary()
            
            if let jsonData = try?  JSONSerialization.data(
                withJSONObject: dictionary,
                options: .prettyPrinted
                ),
                let jsonString = String(data: jsonData,
                                        encoding: String.Encoding.ascii) {
                print("JSON string = \n\(jsonString)")
                return jsonString
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    open func toDictionary() -> [String: Any]?
    {
        var dictionary: [String: Any]? = [String: Any]()
        
        let mirrored = Mirror(reflecting: self)
        for (name, value) in mirrored.children {
            guard let name = name else { continue }
            
            //Check if the Type of Value is primary type if now try to get the dictionary for that value// This setting is for the nested objects
            let metatype = "\(type(of: value))";
            
            if isPrimaryType(metatype: metatype)
            {
                dictionary?.updateValue(value, forKey: name);
            }
            else
            {
                //dictionary?.updateValue((value as! NSObject).toDictionary(), forKey: name);
            }
        }
        return dictionary;
    }
    
    func isPrimaryType(metatype: String) -> Bool
    {
        let allowedTypes = ["Int", "Int16", "Int8", "Int32","Int64", "Bool", "Float", "Double", "String", "Character", "Date"]
        var success : Bool = false;
        
        for allowedType in allowedTypes
        {
            if(metatype == allowedType || metatype.contains("<\(allowedType)>"))
            {
                success = true;
                break;
            }
        }
        return success
    }
    
    
}

