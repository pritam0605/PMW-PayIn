//
//  PayInsDetailsModel.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 10/10/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation


struct PayInsDetails: Codable {
    let status : Int?
    let message : String?
    let payinInfo : PayinInfo?
    let docket_details : [Docket_details]?
    let expense_details : [Expense_details]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case payinInfo = "payin_details"
        case docket_details = "docket_details"
        case expense_details = "expense_details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        payinInfo = try values.decodeIfPresent(PayinInfo.self, forKey: .payinInfo)
        docket_details = try values.decodeIfPresent([Docket_details].self, forKey: .docket_details)
        expense_details = try values.decodeIfPresent([Expense_details].self, forKey: .expense_details)
    }
    
}


struct PayinInfo : Codable {
    let transaction_id : String?
    let shift_no : String?
    let created_ts : String?
    let total_payin_payout : String?
    let km_traveled : String?
    let metered_fares : String?
    let bond_charges : String?
    let subtotal : String?
    let levy : String?
    let no_of_whl : String?
    let no_of_hiring_start : String?
    let no_of_hiring_end : String?
    let total_extra_start : String?
    let total_extra_end : String?
    let paid_km_start : String?
    let paid_km_end : String?
    let total_km_start : String?
    let total_km_end : String?
    let extra_start : String?
    let extra_end : String?
    let speedo_reading_start : String?
    let speedo_reading_end : String?
    let driver_type : String?
    let car_no : String?
    let payin_reference_doc: String?
    let payin_lifetime_total: String?
    let docket_total_value : String?
    let expense_total_value : String?
    let total_lifting_fees : String?

    enum CodingKeys: String, CodingKey {
        
        case transaction_id = "transaction_id"
        case shift_no = "shift_no"
        case created_ts = "created_ts"
        case total_payin_payout = "total_payin_payout"
        case km_traveled = "km_traveled"
        case metered_fares = "metered_fares"
        case bond_charges = "bond_charges"
        case subtotal = "subtotal"
        case levy = "levy"
        case no_of_whl = "no_of_whl"
        case no_of_hiring_start = "no_of_hiring_start"
        case no_of_hiring_end = "no_of_hiring_end"
        case total_extra_start = "total_extra_start"
        case total_extra_end = "total_extra_end"
        case paid_km_start = "paid_km_start"
        case paid_km_end = "paid_km_end"
        case total_km_start = "total_km_start"
        case total_km_end = "total_km_end"
        case extra_start = "extra_start"
        case extra_end = "extra_end"
        case speedo_reading_start = "speedo_reading_start"
        case speedo_reading_end = "speedo_reading_end"
        case driver_type = "driver_type"
        case car_no = "car_no"
        case payin_reference_doc = "payin_reference_doc"
        case payin_lifetime_total = "payin_lifetime_total"
        
        case docket_total_value = "docket_total_value"
        case expense_total_value = "expense_total_value"
        case total_lifting_fees = "total_lifting_fees"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transaction_id = try values.decodeIfPresent(String.self, forKey: .transaction_id)
        shift_no = try values.decodeIfPresent(String.self, forKey: .shift_no)
        created_ts = try values.decodeIfPresent(String.self, forKey: .created_ts)
        total_payin_payout = try values.decodeIfPresent(String.self, forKey: .total_payin_payout)
        km_traveled = try values.decodeIfPresent(String.self, forKey: .km_traveled)
        metered_fares = try values.decodeIfPresent(String.self, forKey: .metered_fares)
        bond_charges = try values.decodeIfPresent(String.self, forKey: .bond_charges)
        subtotal = try values.decodeIfPresent(String.self, forKey: .subtotal)
        levy = try values.decodeIfPresent(String.self, forKey: .levy)
        no_of_whl = try values.decodeIfPresent(String.self, forKey: .no_of_whl)
        no_of_hiring_start = try values.decodeIfPresent(String.self, forKey: .no_of_hiring_start)
        no_of_hiring_end = try values.decodeIfPresent(String.self, forKey: .no_of_hiring_end)
        total_extra_start = try values.decodeIfPresent(String.self, forKey: .total_extra_start)
        total_extra_end = try values.decodeIfPresent(String.self, forKey: .total_extra_end)
        paid_km_start = try values.decodeIfPresent(String.self, forKey: .paid_km_start)
        paid_km_end = try values.decodeIfPresent(String.self, forKey: .paid_km_end)
        total_km_start = try values.decodeIfPresent(String.self, forKey: .total_km_start)
        total_km_end = try values.decodeIfPresent(String.self, forKey: .total_km_end)
        extra_start = try values.decodeIfPresent(String.self, forKey: .extra_start)
        extra_end = try values.decodeIfPresent(String.self, forKey: .extra_end)
        speedo_reading_start = try values.decodeIfPresent(String.self, forKey: .speedo_reading_start)
        speedo_reading_end = try values.decodeIfPresent(String.self, forKey: .speedo_reading_end)
        driver_type = try values.decodeIfPresent(String.self, forKey: .driver_type)
        car_no = try values.decodeIfPresent(String.self, forKey: .car_no)
        
        docket_total_value = try values.decodeIfPresent(String.self, forKey: .docket_total_value)
        expense_total_value = try values.decodeIfPresent(String.self, forKey: .expense_total_value)
        total_lifting_fees = try values.decodeIfPresent(String.self, forKey: .total_lifting_fees)
        payin_reference_doc = try values.decodeIfPresent(String.self, forKey: .payin_reference_doc)
        payin_lifetime_total = try values.decodeIfPresent(String.self, forKey: .payin_lifetime_total)

    }
    
}

struct Docket_details : Codable {
    let value : String?
    let doc_link : String?
    let docket_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case value = "value"
        case doc_link = "doc_link"
        case docket_name = "docket_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        doc_link = try values.decodeIfPresent(String.self, forKey: .doc_link)
        docket_name = try values.decodeIfPresent(String.self, forKey: .docket_name)
    }
    
}

struct Expense_details : Codable {
    let value : String?
    let doc_link : String?
    let expense_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case value = "value"
        case doc_link = "doc_link"
        case expense_name = "expense_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        doc_link = try values.decodeIfPresent(String.self, forKey: .doc_link)
        expense_name = try values.decodeIfPresent(String.self, forKey: .expense_name)
    }
    
}

class ShowPayInsDetailsModel {
    var modelDetails: PayInsDetails?
    func detailsOfPayInsInfoData(token: String, payInID: String, completionHandler:@escaping(_ status: Int, _ message: String) -> () ) {
        let paramiter = ["device_type":"1","token_key":token, "payin_id":payInID]
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.GetPayinsDetails.url, callMethod: .post, param: paramiter as Dictionary<String, AnyObject>, responseModel: PayInsDetails.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.modelDetails = dict as? PayInsDetails
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


