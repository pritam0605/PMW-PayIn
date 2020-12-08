//
//  LevyModel.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 01/10/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation

struct LevyModelData : Codable {
    let status : Int?
    let message : String?
    let levy_list : [LevyList]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case levy_list = "levy_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        levy_list = try values.decodeIfPresent([LevyList].self, forKey: .levy_list)
    }
    
}

struct LevyList : Codable {
    let payin_id : String?
    let shift_no : String?
    let payin_date : String?
    let no_of_run : String?
    let levy : String?
    
    enum CodingKeys: String, CodingKey {
        
        case payin_id = "payin_id"
        case shift_no = "shift_no"
        case payin_date = "payin_date"
        case no_of_run = "no_of_run"
        case levy = "levy"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        payin_id = try values.decodeIfPresent(String.self, forKey: .payin_id)
        shift_no = try values.decodeIfPresent(String.self, forKey: .shift_no)
        payin_date = try values.decodeIfPresent(String.self, forKey: .payin_date)
        no_of_run = try values.decodeIfPresent(String.self, forKey: .no_of_run)
        levy = try values.decodeIfPresent(String.self, forKey: .levy)
    }
    
}

class LevyModelClass: NSObject {
    
    var levyModel:LevyModelData?
    
    func getLevyListDatas(driverId: String, startDate:String, endDate: String, token: String,completionHandler: @escaping(_ status:Int, _ message:String) ->()) {
        
        
        var param:[String: AnyObject] = [:]
        param["token_key"] = token as AnyObject
        param["device_type"] = "1" as AnyObject
        param["driver_id"] = driverId as AnyObject
        param["start_date"] = startDate as AnyObject
        param["end_date"] = endDate as AnyObject

        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.LevyReportAPI.url, callMethod: .post, param: param, responseModel: LevyModelData.self, success: { (status,message,dict) -> (Void) in
            if (status == 0) {
                self.levyModel = dict as? LevyModelData
                completionHandler(status,message)
            }else if (status == 2){
                //force logout
                completionHandler(status, message)
            }else{
                completionHandler(status, message)
            }
            
        }) { (error) in
            print(error as Any)
            completionHandler(1, error)
        }
        
        
    }
    
    
    
}


