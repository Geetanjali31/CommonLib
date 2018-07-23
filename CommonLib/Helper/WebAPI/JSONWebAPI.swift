//
//  JSONWebAPI.swift
//  CommonLib
//
//  Created by Geetanjali M on 13/07/18.
//  Copyright © 2018 Appino. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import Reachability

open class MultipartImage: NSObject {
    open var image:UIImage?
    open var name:String?
    open var fileName:String?
    
    public init(_image: UIImage, _name:String, _fileName:String) {
        image = _image
        name = _name
        fileName = _fileName
    }
}

open class JSONWebAPI: PWebAPI {
    public init() {
    }
    
    open func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach {
                $0.cancel()
            }
        }
    }
    
    /// Fetch data from server.
    ///
    /// - Parameters:
    ///   - urlString: Api url.
    ///   - apiHeaders: Header dictionary in API.
    ///   - postCompleted: Returns success/failure status and api response.
    open func get(urlString:String, apiHeaders:HTTPHeaders, postCompleted : @escaping (_ succeeded: Bool, _ responseDict: NSDictionary) -> ()) {
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 120
        let url = URL(string : urlString)
        
        Alamofire.request(url!, method: .get, encoding: JSONEncoding.default, headers: apiHeaders)
            .responseJSON
            { response in switch response.result {
            case .success(let JSON ):
                let json = JSON as? NSDictionary
                if json != nil {
                    let issucceeded : Bool = (json!.value(forKey: "StatusCode") != nil) ? true : false
                    postCompleted(issucceeded, json!)
                }
                else { // Responce is not in proper JSON format
                    let respDic = NSDictionary()
                    postCompleted(false, respDic)
                }
                
            case .failure(let error):
                if error.localizedDescription == "cancelled" {
                    let respDic = ["StatusCode" : "\(NSURLErrorCancelled)"]
                    postCompleted(false, respDic as NSDictionary)
                }
                else {
                    let  respDic = NSDictionary()
                    postCompleted(false, respDic as NSDictionary)
                }
            }
        }
    }

    /// Save or post data from server.
    ///
    /// - Parameters:
    ///   - urlString: Api url.
    ///   - params: Data dictionary to be saved or changed on server.
    ///   - apiHeaders: Header dictionary in API.
    ///   - postCompleted: Returns success/failure status and api response.
    open func post(urlString:String, params : [String:Any], apiHeaders:HTTPHeaders, postCompleted : @escaping (_ succeeded: Bool, _ responseDict: NSDictionary) -> ()) {
        let url = URL(string : urlString)
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 120
        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: apiHeaders)
            .responseJSON
            { response in switch response.result {
            case .success(let JSON ):
                let json = JSON as? NSDictionary
                if json != nil {
                    let issucceeded : Bool = (json!.value(forKey: "StatusCode") != nil) ? true : false
                    postCompleted(issucceeded, json!)
                }
                else { // Responce is not in proper JSON format
                    let respDic = NSDictionary()
                    postCompleted(false, respDic)
                }
                
            case .failure(let error):
                if error.localizedDescription == "cancelled" {
                    let respDic = ["StatusCode" : "\(NSURLErrorCancelled)"]
                    postCompleted(false, respDic as NSDictionary)
                }
                else {
                    let  respDic = NSDictionary()
                    postCompleted(false, respDic as NSDictionary)
                }
            }
        }
    }
    
    /// Save images on server in multipart format.
    ///
    /// - Parameters:
    ///   - urlString: Api url.
    ///   - params: Data dictionary to be saved or changed on server.
    ///   - arrayImages: Array of MultipartImage object.
    ///   - apiHeaders: Header dictionary in API.
    ///   - postCompleted: Returns success/failure status and api response.
    open func postMultipartImage(urlString:String, params : [String:Any], arrayImages : [MultipartImage], apiHeaders:HTTPHeaders, postCompleted : @escaping (_ succeeded: Bool, _ responseDict: NSDictionary) -> ()) {
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 120
        let url = URL(string : urlString)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for multipartImageObj in arrayImages {
                if let imageObj = multipartImageObj.image, !(imageObj.size.equalTo(CGSize.zero)), let imageName = multipartImageObj.name, let fileName = multipartImageObj.fileName {
                    multipartFormData.append(UIImageJPEGRepresentation(imageObj, 0.5)!, withName: imageName, fileName: "\(fileName).jpeg", mimeType: "image/jpeg")
                }
            }
            for (keyStr, valueStr) in params {
                multipartFormData.append((valueStr as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: keyStr)
            }
        }, to: url!, headers: apiHeaders) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if let JSON = response.result.value {
                        let json = JSON as? NSDictionary
                        if json != nil {
                            let issucceeded : Bool = (json!.value(forKey: "StatusCode") != nil) ? true : false
                            postCompleted(issucceeded, json!)
                        }
                        else { // Responce is not in proper JSON format
                            let respDic = NSDictionary()
                            postCompleted(false, respDic)
                        }
                    }
                }
                
            case .failure(let error):
                if error.localizedDescription == "cancelled" {
                    let respDic = ["StatusCode" : "\(NSURLErrorCancelled)"]
                    postCompleted(false, respDic as NSDictionary)
                }
                else {
                    let  respDic = NSDictionary()
                    postCompleted(false, respDic as NSDictionary)
                }
            }
        }
    }
}
