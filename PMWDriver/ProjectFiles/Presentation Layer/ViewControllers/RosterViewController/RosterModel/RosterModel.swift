//
//  RosterModel.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 24/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation
struct RosterDataModel : Codable {
    let status : Int?
    let message : String?
    let rosterList : [RosterList]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case rosterList = "roster_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        rosterList = try values.decodeIfPresent([RosterList].self, forKey: .rosterList)
    }
    
}

struct RosterList : Codable {
    let roster_id : String?
    let shift_name : String?
    let day_date : String?
    let dayname : String?
    let registration_no : String?
    
    enum CodingKeys: String, CodingKey {
        
        case roster_id = "roster_id"
        case shift_name = "shift_name"
        case day_date = "day_date"
        case dayname = "dayname"
        case registration_no = "registration_no"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        roster_id = try values.decodeIfPresent(String.self, forKey: .roster_id)
        shift_name = try values.decodeIfPresent(String.self, forKey: .shift_name)
        day_date = try values.decodeIfPresent(String.self, forKey: .day_date)
        dayname = try values.decodeIfPresent(String.self, forKey: .dayname)
        registration_no = try values.decodeIfPresent(String.self, forKey: .registration_no)
    }
    
}
class RosterModelClass {
    var rosterDataModel:RosterDataModel?
    func listOfRosterData(token: String, driver: String, completionHandler:@escaping(_ status: Int, _ message: String) -> () ) {
        let paramiter = ["device_type":"1","token_key":token, "driver_id":driver]
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.RosterListAPI.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: RosterDataModel.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.rosterDataModel = dict as? RosterDataModel
                completionHandler(status,message)
            }else if (status == 2){
                completionHandler(status,message)
            }else{
                completionHandler(status,message)
            }
        })
        { ( message) in //error block
            completionHandler(1,"Something error")
        }
    }
    
}


