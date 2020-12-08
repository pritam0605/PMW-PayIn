//
//  SignUpModel.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 10/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import Foundation

struct Address_info : Codable {
    let flat_no : String?
    let street_no : String?
    let street_name : String?
    let suburb : String?
    let state : String?
    let pin : String?
    
    enum CodingKeys: String, CodingKey {
        
        case flat_no = "flat_no"
        case street_no = "street_no"
        case street_name = "street_name"
        case suburb = "suburb"
        case state = "state"
        case pin = "pin"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flat_no = try values.decodeIfPresent(String.self, forKey: .flat_no)
        street_no = try values.decodeIfPresent(String.self, forKey: .street_no)
        street_name = try values.decodeIfPresent(String.self, forKey: .street_name)
        suburb = try values.decodeIfPresent(String.self, forKey: .suburb)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        pin = try values.decodeIfPresent(String.self, forKey: .pin)
    }
    
}

struct Basic_info : Codable {
    let user_id : String?
    let role_id : String?
    let email : String?
    let first_name : String?
    let middle_name : String?
    let last_name : String?
    let dob : String?
    let mobile : String?
    let landline_no : String?
    let abn : String?
    
    enum CodingKeys: String, CodingKey {
        
        case user_id = "user_id"
        case role_id = "role_id"
        case email = "email"
        case first_name = "first_name"
        case middle_name = "middle_name"
        case last_name = "last_name"
        case dob = "dob"
        case mobile = "mobile"
        case landline_no = "landline_no"
        case abn = "abn"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        role_id = try values.decodeIfPresent(String.self, forKey: .role_id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        middle_name = try values.decodeIfPresent(String.self, forKey: .middle_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        landline_no = try values.decodeIfPresent(String.self, forKey: .landline_no)
        abn = try values.decodeIfPresent(String.self, forKey: .abn)
    }
    
}

struct DriverBankDetails : Codable {
    let bank_name : String?
    let bsb : String?
    let account_no : String?
    
    enum CodingKeys: String, CodingKey {
        
        case bank_name = "bank_name"
        case bsb = "bsb"
        case account_no = "account_no"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bank_name = try values.decodeIfPresent(String.self, forKey: .bank_name)
        bsb = try values.decodeIfPresent(String.self, forKey: .bsb)
        account_no = try values.decodeIfPresent(String.self, forKey: .account_no)
    }
    
}

struct Personal_info : Codable {
    let dr_driver_type : String?
    let dr_licence_no : String?
    let dr_licence_expiry : String?
    let dc_no : String?
    let dr_dc_expiry : String?
    let profile_photo : String?
    let driver_certificate_flag : Int?
    let driving_license_flag : Int?
    let paper_dc_flag : Int?
    let login_card_flag : Int?
    let profile_photo_flag : Int?
    let signature_flag : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case dr_driver_type = "dr_driver_type"
        case dr_licence_no = "dr_licence_no"
        case dr_licence_expiry = "dr_licence_expiry"
        case dc_no = "dc_no"
        case dr_dc_expiry = "dr_dc_expiry"
        case profile_photo = "profile_photo"
        
        case driver_certificate_flag  = "driver_certificate_flag"
        case driving_license_flag = "driving_license_flag"
        case paper_dc_flag = "paper_dc_flag"
        case login_card_flag = "login_card_flag"
        case profile_photo_flag = "profile_photo_flag"
        case signature_flag = "signature_flag"
        
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dr_driver_type = try values.decodeIfPresent(String.self, forKey: .dr_driver_type)
        dr_licence_no = try values.decodeIfPresent(String.self, forKey: .dr_licence_no)
        dr_licence_expiry = try values.decodeIfPresent(String.self, forKey: .dr_licence_expiry)
        dc_no = try values.decodeIfPresent(String.self, forKey: .dc_no)
        dr_dc_expiry = try values.decodeIfPresent(String.self, forKey: .dr_dc_expiry)
        profile_photo = try values.decodeIfPresent(String.self, forKey: .profile_photo)
        
        driver_certificate_flag = try values.decodeIfPresent(Int.self, forKey: .driver_certificate_flag)
        driving_license_flag = try values.decodeIfPresent(Int.self, forKey: .driving_license_flag)
        paper_dc_flag = try values.decodeIfPresent(Int.self, forKey: .paper_dc_flag)
        login_card_flag = try values.decodeIfPresent(Int.self, forKey: .login_card_flag)
        profile_photo_flag = try values.decodeIfPresent(Int.self, forKey: .profile_photo_flag)
        signature_flag = try values.decodeIfPresent(Int.self, forKey: .signature_flag)
    }
    
}


struct RegistrationDetailsModel : Codable {
    let status : Int?
    let message : String?
    let basic_info : Basic_info?
    let address_info : Address_info?
    let bank_info : DriverBankDetails?
    let personal_info : Personal_info?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case basic_info = "basic_info"
        case address_info = "address_info"
        case bank_info = "bank_info"
        case personal_info = "personal_info"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        basic_info = try values.decodeIfPresent(Basic_info.self, forKey: .basic_info)
        address_info = try values.decodeIfPresent(Address_info.self, forKey: .address_info)
        bank_info = try values.decodeIfPresent(DriverBankDetails.self, forKey: .bank_info)
        personal_info = try values.decodeIfPresent(Personal_info.self, forKey: .personal_info)
    }
    
}
class SignUpModel: NSObject {
    
    var regModel:RegistrationDetailsModel?
    func getProfileDetails(userID: String, token: String,completionHandler: @escaping(_ status:Int, _ message:String) ->()) {
        var param:[String: AnyObject] = [:]
        param["token_key"] = token as AnyObject
        param["device_type"] = "1" as AnyObject
        param["user_id"] = userID as AnyObject
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.ProfileDetails.url, callMethod: .post, param: param, responseModel: RegistrationDetailsModel.self, success: { (status,message,dict) -> (Void) in
            if (status == 0) {
                
                self.regModel = dict as? RegistrationDetailsModel
                 completionHandler(status,message)
            }else if (status == 2){
                //force logout
                completionHandler(status, message)
            }else{
                completionHandler(status, message)
            }
            
        })
        { (error) in
            completionHandler(1, error)
        }
        
        
    }
    
    

}
