//
//  PWebAPI.swift
//  CommonLib
//
//  Created by Geetanjali M on 13/07/18.
//  Copyright © 2018 Quadlogix. All rights reserved.
//

import Foundation
import Alamofire

//This protocol defines the rules for the API managers to get the data from server.

public protocol PWebAPI
{
    /// Cancel all URLSession tasks.
    func cancelAllRequests()
    
    /// Fetch data from server.
    ///
    /// - Parameters:
    ///   - urlString: Api url.
    ///   - apiHeaders: Header dictionary in API.
    ///   - postCompleted: Returns success/failure status and api response.
    func get(urlString:String, apiHeaders:HTTPHeaders, postCompleted : @escaping (_ succeeded: Bool, _ responseDict: NSDictionary) -> ())
    
    /// Save or post data from server.
    ///
    /// - Parameters:
    ///   - urlString: Api url.
    ///   - params: Data dictionary to be saved or changed on server.
    ///   - apiHeaders: Header dictionary in API.
    ///   - postCompleted: Returns success/failure status and api response.
    func post(urlString:String, params : [String:Any], apiHeaders:HTTPHeaders, postCompleted : @escaping (_ succeeded: Bool, _ responseDict: NSDictionary) -> ())

    /// Save images on server in multipart format.
    ///
    /// - Parameters:
    ///   - urlString: Api url.
    ///   - params: Data dictionary to be saved or changed on server.
    ///   - arrayImages: Array of MultipartImage object.
    ///   - apiHeaders: Header dictionary in API.
    ///   - postCompleted: Returns success/failure status and api response.
    func postMultipartImage(urlString:String, params : [String:Any], arrayImages : [MultipartImage], apiHeaders:HTTPHeaders, postCompleted : @escaping (_ succeeded: Bool, _ responseDict: NSDictionary) -> ())
}

