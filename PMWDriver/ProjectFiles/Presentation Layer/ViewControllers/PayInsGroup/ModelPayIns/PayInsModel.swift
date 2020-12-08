//
//  PayInsModel.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 18/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation
import UIKit

struct PayinListDataResponse : Codable {
    
    let status : Int?
    let message : String?
    let payInListData : [PayinListData]?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case payInListData = "payin_list"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        payInListData = try values.decodeIfPresent([PayinListData].self, forKey: .payInListData)
    }
}

struct PayinListData : Codable {
    let transactionId : String?
    let shiftId : String?
    let createdTime : String?
    let totalPayinPayout : String?
    let carNo : String?
    let shift_no : String?
    
    enum CodingKeys: String, CodingKey {
        
        case transactionId = "transaction_id"
        case shiftId = "shift_id"
        case createdTime = "created_ts"
        case totalPayinPayout = "total_payin_payout"
        case carNo = "car_no"
        case shift_no = "shift_no"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        shiftId = try values.decodeIfPresent(String.self, forKey: .shiftId)
        createdTime = try values.decodeIfPresent(String.self, forKey: .createdTime)
        totalPayinPayout = try values.decodeIfPresent(String.self, forKey: .totalPayinPayout)
        carNo = try values.decodeIfPresent(String.self, forKey: .carNo)
        shift_no = try values.decodeIfPresent(String.self, forKey: .shift_no)
    }
    
}




struct DocketListModel : Codable {
    let status : Int?
    let message : String?
    let docket_list : [DocketList]?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case docket_list = "docket_list"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        docket_list = try values.decodeIfPresent([DocketList].self, forKey: .docket_list)
    }
}

struct DocketList : Codable {
    let docket_id : String?
    let docket_name : String?
    
    enum CodingKeys: String, CodingKey {
        case docket_id = "docket_id"
        case docket_name = "docket_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        docket_id = try values.decodeIfPresent(String.self, forKey: .docket_id)
        docket_name = try values.decodeIfPresent(String.self, forKey: .docket_name)
    }
    
}



struct PayInsApiInfo : Codable {
    let status : Int?
    let message : String?
    let resultData : PayInsApiData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case resultData = "result"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        resultData = try values.decodeIfPresent(PayInsApiData.self, forKey: .resultData)
    }
    
}

struct PayInsApiData : Codable {
    let bond_value : String?
    let levy_rate : String?
    let lifting_fees : String?
    let commission_rate_driver : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case bond_value = "bond_value"
        case levy_rate = "levy_rate"
        case lifting_fees = "lifting_fees"
        case commission_rate_driver = "commission_rate_driver"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bond_value = try values.decodeIfPresent(String.self, forKey: .bond_value)
        levy_rate = try values.decodeIfPresent(String.self, forKey: .levy_rate)
        lifting_fees = try values.decodeIfPresent(String.self, forKey: .lifting_fees)
        commission_rate_driver = try values.decodeIfPresent(String.self, forKey: .commission_rate_driver)
    }
    
}



struct ExpenseListResult : Codable {
    let status : Int?
    let message : String?
    let expense_list : [ExpenseList]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case expense_list = "expense_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        expense_list = try values.decodeIfPresent([ExpenseList].self, forKey: .expense_list)
    }
    
}

struct ExpenseList : Codable {
    let expense_id : String?
    let expense_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case expense_id = "expense_id"
        case expense_name = "expense_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        expense_id = try values.decodeIfPresent(String.self, forKey: .expense_id)
        expense_name = try values.decodeIfPresent(String.self, forKey: .expense_name)
    }
    
}

//Mark: - Data response of paylist data 
struct PayInsListData : Codable {
    let status : Int?
    let message : String?
    let payinListArray : [PayInsList]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case payinListArray = "payin_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        payinListArray = try values.decodeIfPresent([PayInsList].self, forKey: .payinListArray)
    }
    
}


struct PayInsList : Codable {
    let transactionId : String?
    let shiftId : String?
    let createdDate : String?
    let payinPayout : String?
    let carNo : String?
    
    enum CodingKeys: String, CodingKey {
        
        case transactionId = "transaction_id"
        case shiftId = "shift_id"
        case createdDate = "created_ts"
        case payinPayout = "total_payin_payout"
        case carNo = "car_no"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        shiftId = try values.decodeIfPresent(String.self, forKey: .shiftId)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        payinPayout = try values.decodeIfPresent(String.self, forKey: .payinPayout)
        carNo = try values.decodeIfPresent(String.self, forKey: .carNo)
    }
    
}






struct PayInsStartData : Codable {
    let status : Int?
    let message : String?
    let previous_payin_details : PreviousPayinDetails?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case previous_payin_details = "previous_payin_details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        previous_payin_details = try values.decodeIfPresent(PreviousPayinDetails.self, forKey: .previous_payin_details)
    }
    
}

struct PreviousPayinDetails : Codable {
    let payin_id : String?
    let total_extra_start : String?
    let paid_km_start : String?
    let total_km_start : String?
    let no_of_hiring_start : String?
    let extra_start : String?
    let speedo_reading_start : String?
    
    enum CodingKeys: String, CodingKey {
        case payin_id = "payin_id"
        case total_extra_start = "total_extra_start"
        case paid_km_start = "paid_km_start"
        case total_km_start = "total_km_start"
        case no_of_hiring_start = "no_of_hiring_start"
        case extra_start = "extra_start"
        case speedo_reading_start = "speedo_reading_start"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        payin_id = try values.decodeIfPresent(String.self, forKey: .payin_id)
        total_extra_start = try values.decodeIfPresent(String.self, forKey: .total_extra_start)
        paid_km_start = try values.decodeIfPresent(String.self, forKey: .paid_km_start)
        total_km_start = try values.decodeIfPresent(String.self, forKey: .total_km_start)
        no_of_hiring_start = try values.decodeIfPresent(String.self, forKey: .no_of_hiring_start)
        extra_start = try values.decodeIfPresent(String.self, forKey: .extra_start)
        speedo_reading_start = try values.decodeIfPresent(String.self, forKey: .speedo_reading_start)
    }
    
}









//Mark : - PayIns Model
class PayInsModel {
    var expenseList: ExpenseListResult?
    var payInInfo: PayInsApiInfo?
    var docketList: DocketListModel?
    var payInListData: PayInsListData?
    var payInsListResponse: PayinListDataResponse?

    func getExpenseList( token: String,completionHandler: @escaping(_ status: Int, _ message: String) ->()){
        let apiManager = ServerRequestHandler()
        let paramiter = ["device_type":"1","token_key":token]
        apiManager.callWebServiceApi(url: API.ExpenseList.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: ExpenseListResult.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.expenseList = dict as? ExpenseListResult
                completionHandler(status,message)
            }else if (status == 2){
                completionHandler(status,message)
            }
            else{
                completionHandler(status,message)
            }
            
        }, failed: { (message) in
            completionHandler(1,message)
        })
        
    }
    
    func getPayInInfo( token: String, driver: String, completionHandler: @escaping(_ status: Int, _ message: String) ->()){
        let apiManager = ServerRequestHandler()
        let paramiter = ["device_type":"1","token_key":token, "driver_id":driver]
        apiManager.callWebServiceApi(url: API.PayInsOnloadValue.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: PayInsApiInfo.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.payInInfo = dict as? PayInsApiInfo
                completionHandler(status,message)
            }else if (status == 2){
                completionHandler(status,message)
            }
            else{
                completionHandler(status,message)
            }
            
        }, failed: { (message) in
            
        })
    }
    
    
    func getDocketList( token: String,completionHandler: @escaping(_ status: Int, _ message: String) ->()){
        let apiManager = ServerRequestHandler()
        let paramiter = ["device_type":"1","token_key":token]
        apiManager.callWebServiceApi(url: API.DocketList.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: DocketListModel.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.docketList = dict as? DocketListModel
               
                completionHandler(status,message)
            }else if (status == 2){
                completionHandler(status,message)
            }
            else{
                completionHandler(status,message)
            }
            
        }, failed: { (message) in
            completionHandler(1, message)
        })
    }
    
    
    func getPayDataList( token: String, driver: String, completionHandler: @escaping(_ status: Int, _ message: String) ->()){
        let apiManager = ServerRequestHandler()
        let paramiter = ["device_type":"1","token_key":token, "driver_id":driver]
        apiManager.callWebServiceApi(url: API.PayInsList.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: PayInsListData.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
    
                self.payInListData = dict as? PayInsListData
                completionHandler(status,message)
            }else if (status == 2){
                completionHandler(status,message)
            }else{
                completionHandler(status,message)
            }
        }, failed: { (message) in
              completionHandler(1,"Something error")
        })
    }
    
    
    func payInsDataSubmit(SubmissionData:[String: AnyObject],imageArray:[MultipartInfo], completionHandler: @escaping(_ status: Int, _ message: String) ->()) {
        let apiManager = ServerRequestHandler()
        apiManager.uploadimageWithParamiter(url: API.PayInsDataSubmit.url, parm: SubmissionData as Dictionary<String, AnyObject>, imagedate: imageArray, success: { (dict) -> (Void) in
            if let myResult:Dictionary<String, AnyObject> = dict as? Dictionary<String, AnyObject> {
                let message = myResult["message"]
                let status:Int = myResult["status"] as! Int
                completionHandler(status,message as! String)
            }
        }) { (error) in
            completionHandler(1, error as! String)
            print("loader")
        }
    }
    
    
    func listOfPayInsData(token: String, driver: String, completionHandler:@escaping(_ status: Int, _ message: String) -> () ) {
        let paramiter = ["device_type":"1","token_key":token, "driver_id":driver]
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.PayInsList.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: PayinListDataResponse.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.payInsListResponse = dict as? PayinListDataResponse
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
    
    
    
     var payInsPreviousData: PayInsStartData?
    
    func getAllPayInsStartData( token: String, carId: String, completionHandler: @escaping(_ status: Int, _ message: String) ->()){
        let apiManager = ServerRequestHandler()
        let paramiter = ["device_type":"1","token_key":token, "car_id":carId]
        apiManager.callWebServiceApi(url: API.GetPreviousPayinsData.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: PayInsStartData.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                
                self.payInsPreviousData = dict as? PayInsStartData // pay ins star data model
                completionHandler(status,message)
            }else if (status == 2){
                completionHandler(status,message)
            }else{
                completionHandler(status,message)
            }
        }, failed: { (message) in
            completionHandler(1,"Something error")
        })
    }
    
}

