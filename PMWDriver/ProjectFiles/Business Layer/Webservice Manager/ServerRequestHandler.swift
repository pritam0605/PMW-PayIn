//
//  ServerRequestHandler.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 10/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

enum APIManagerRequestMethod:Int {
    case post
    case get
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}


class ServerRequestHandler {
    let header:[String:String] = [:]
    func callWebServiceApi<T: Decodable>(url:URL?, callMethod:APIManagerRequestMethod,param: Dictionary<String, AnyObject>, responseModel: T.Type,
                                         success: @escaping(Int,String, Any?) -> (Void),
                                         failed: @escaping (String) -> Void) {
        
        if Connectivity.isConnectedToInternet {
            
            Alamofire.request(url!, method: callMethod == .post ? .post : .get ,   parameters: param, encoding:   JSONEncoding.default, headers: header).responseJSON { response in
                
                switch response.result {
                case .success:
                    do {
                        let p =  (response.result.value) as! Dictionary<String, AnyObject>
                        print("profile details", p)
                        
                        let status:Int = p["status"] as! Int
                        let message:String = p["message"] as! String
                        if status == 0 { //Success
                            let gitData = try JSONDecoder().decode(responseModel.self, from: response.data!)
                            success(status ,message, gitData)
                        }else if status == 1 {
                            success(status ,message, nil)
                        }else {
                            success(status ,message, nil)
                        }
                    } catch let error {
                        failed("Some thing error")
                        print("Error", error)
                    }
                case .failure(let error):
                    print(error)
                    failed("Some thing error")
                }
                
            }
            
        }else{
            failed("No internet connection")
        }
    }
    
    
    func uploadimageWithParamiter(url: URL?, parm: Dictionary<String, AnyObject>, imagedate:[MultipartInfo],
                                  success: @escaping(Any?) -> (Void),
                                  failed: @escaping (Any?) -> Void) {
        if Connectivity.isConnectedToInternet {
            
            
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                for (key, value) in parm {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
                for imgdata in imagedate {
                    let data = Data()
                    multipartFormData.append(imgdata.data ?? data , withName: imgdata.strKey!, fileName: imgdata.strFileName!, mimeType: (imgdata.mimeType?.getMimeType())!)
                }
                
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url!, method: .post, headers: headers) { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response.result)
                        success(response.result.value)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    failed("Failde to upload ")
                }
            }
            
            //if
        }else{
            failed("No internet connection")
        }
        
    }
    
    
    
}



