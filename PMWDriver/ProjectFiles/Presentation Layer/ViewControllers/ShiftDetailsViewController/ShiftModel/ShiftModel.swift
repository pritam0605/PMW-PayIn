//
//  ShiftModel.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 25/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation

struct ShiftDetailsResponce : Codable {
    let status : Int?
    let message : String?
    let shiftDetails : ShiftDetailsModel? 
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case shiftDetails = "shift_details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        shiftDetails = try values.decodeIfPresent(ShiftDetailsModel.self, forKey: .shiftDetails)
    }
    
}

struct ShiftDetailsModel : Codable {
  
    let status_code : Int?
    let statusMessage : String?
    let roster_id : String?
    let roster_driver_id : String?
    let shift_name : String?
    let day_date : String?
    let dayname : String?
    let car_no : String?
    let car_id : String?
    
    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case statusMessage = "status"
        case roster_id = "roster_id"
        case roster_driver_id = "roster_driver_id"
        case shift_name = "shift_name"
        case day_date = "day_date"
        case dayname = "dayname"
        case car_no = "car_no"
        case car_id = "car_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        statusMessage = try values.decodeIfPresent(String.self, forKey: .statusMessage)
        
        roster_id = try values.decodeIfPresent(String.self, forKey: .roster_id)
        roster_driver_id = try values.decodeIfPresent(String.self, forKey: .roster_driver_id)
        shift_name = try values.decodeIfPresent(String.self, forKey: .shift_name)
        day_date = try values.decodeIfPresent(String.self, forKey: .day_date)
        dayname = try values.decodeIfPresent(String.self, forKey: .dayname)
        car_no = try values.decodeIfPresent(String.self, forKey: .car_no)
        car_id = try values.decodeIfPresent(String.self, forKey: .car_id)
    }
    
}




struct StartShiftDataModel : Codable {
    let status : Int?
    let message : String?
    let shift_details : ShiftDetails?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case shift_details = "shift_details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        shift_details = try values.decodeIfPresent(ShiftDetails.self, forKey: .shift_details)
    }
    
}

struct ShiftDetails : Codable {
    let shiftId : Int?
    let shift_no : String?
    enum CodingKeys: String, CodingKey {
        case shiftId = "shift_id"
        case shift_no = "shift_no"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shiftId = try values.decodeIfPresent(Int.self, forKey: .shiftId)
        shift_no = try values.decodeIfPresent(String.self, forKey: .shift_no)
    }
}

class ShiftDetailsClass {
    var shiftDataModel:ShiftDetailsResponce?
    var startShiftModel: StartShiftDataModel?
    
    func getCurrentShiftDetails(token: String, driver: String, completionHandler:@escaping(_ status: Int, _ message: String) -> () ) {
        let paramiter = ["device_type":"1","token_key":token, "driver_id":driver]
        let apiManager = ServerRequestHandler()
        
        apiManager.callWebServiceApi(url: API.ShiftDetailsAPI.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: ShiftDetailsResponce.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.shiftDataModel = dict as? ShiftDetailsResponce
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
    
    //Mark: - Start shift Api
    func getStartShiftDetails(token: String, rosterDrive: String, completionHandler:@escaping(_ status: Int, _ message: String) -> () ) {
        
        let paramiter = ["device_type":"1", "token_key":token, "roster_driver_id":rosterDrive]
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.StartShiftAPI.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: StartShiftDataModel.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.startShiftModel = dict as? StartShiftDataModel
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

