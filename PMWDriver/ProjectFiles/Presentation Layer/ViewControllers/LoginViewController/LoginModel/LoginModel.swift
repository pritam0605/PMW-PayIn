//
//  LoginModel.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 10/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import Foundation



struct BreakdownData : Codable {
    let status : Int?
    let message : String?
    let breakdown_data : BreakdownInfo?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case breakdown_data = "breakdown_data"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        breakdown_data = try values.decodeIfPresent(BreakdownInfo.self, forKey: .breakdown_data)
    }
    
}

struct BreakdownInfo : Codable {
    let breakdown_alert_id : String?
    

    let breakdown_sms_no : String?
    let breakdown_call_no : String?
    let breakdown_whatsup_no : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case breakdown_alert_id = "breakdown_alert_id"
        case breakdown_sms_no = "breakdown_alert_sms_no"
        case breakdown_call_no = "breakdown_alert_contact_no"
        case breakdown_whatsup_no = "breakdown_alert_whatsapp_no"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        breakdown_alert_id = try values.decodeIfPresent(String.self, forKey: .breakdown_alert_id)
        breakdown_sms_no = try values.decodeIfPresent(String.self, forKey: .breakdown_sms_no)
        
        breakdown_call_no = try values.decodeIfPresent(String.self, forKey: .breakdown_call_no)
        breakdown_whatsup_no = try values.decodeIfPresent(String.self, forKey: .breakdown_whatsup_no)
    }
    
}



//Dash board api structure
struct DashBoardInfo : Codable {
    
    let status : Int?
    let message : String?
    let inspection_details : InspectionDetails?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case inspection_details = "inspection_details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        inspection_details = try values.decodeIfPresent(InspectionDetails.self, forKey: .inspection_details)
    }
    
}

struct InspectionDetails : Codable {
    let status_code : Int?
    let status : String?
    let total_payout : String?
    let bond_accumulated : String?
    
    enum CodingKeys: String, CodingKey {
        case status_code = "status_code"
        case status = "status"
        case total_payout = "total_payout"
        case bond_accumulated = "bond_accumulated"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        total_payout = try values.decodeIfPresent(String.self, forKey: .total_payout)
        bond_accumulated = try values.decodeIfPresent(String.self, forKey: .bond_accumulated)
    }
}

/////////////////////

//Mark : - Logout model Structure
struct LogOutDataModel : Codable {
    let status : Int?
    let message : String?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
       
    }
}

//Mark: ----- Login data model
struct LoginDataModel : Codable {
    let status : Int?
    let message : String?
    let driver_details : DriverDetails?
    let api_token_details : ApiTokenDetails?
    let shiftDetails : shiftDetails?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case driver_details = "driver_details"
        case api_token_details = "api_token_details"
        case shiftDetails = "shift_details"
    }

}

struct shiftDetails : Codable {
    let status_code : Int?
    let status : String?
    let shift_id : String?
    let car_id : String?
    let shift_no : String?
    let car_no : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status_code = "status_code"
        case status = "status"
        case shift_id = "shift_id"
        case car_id = "car_id"
        case shift_no = "shift_no"
        case car_no = "car_no"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        shift_id = try values.decodeIfPresent(String.self, forKey: .shift_id)
        car_id = try values.decodeIfPresent(String.self, forKey: .car_id)
        shift_no = try values.decodeIfPresent(String.self, forKey: .shift_no)
        car_no = try values.decodeIfPresent(String.self, forKey: .car_no)
    }
    
    //    0=>No Shift
    //    1=>Shift Available Today
    //    2=>Ongoing Shift
    
    
}

struct DriverDetails : Codable {
    let user_id : String?
    let role_id : String?
    let dc_no : String?
    let is_admin : String?
    let email : String?
    let password : String?
    let created_by : String?
    let created_ts : String?
    let updated_by : String?
    let updated_ts : String?
    let status : String?
    let login_status : String?
    let profilePhoto : String?
    let fullName : String?
    let drDriverType : String?
    
    enum CodingKeys: String, CodingKey {
        
        case user_id = "user_id"
        case role_id = "role_id"
        case dc_no = "dc_no"
        case is_admin = "is_admin"
        case email = "email"
        case password = "password"
        case created_by = "created_by"
        case created_ts = "created_ts"
        case updated_by = "updated_by"
        case updated_ts = "updated_ts"
        case status = "status"
        case login_status = "login_status"
        case fullName = "full_name"
        case profilePhoto = "profile_photo"
        case drDriverType = "dr_driver_type"
        
    }

}


struct ApiTokenDetails : Codable {
    let token_id : String?
    let user_id : String?
    let device_type : String?
    let token_key : String?
    let date_of_creation : String?
    let session_start_time : String?
    let session_end_time : String?
    
    enum CodingKeys: String, CodingKey {
        
        case token_id = "token_id"
        case user_id = "user_id"
        case device_type = "device_type"
        case token_key = "token_key"
        case date_of_creation = "date_of_creation"
        case session_start_time = "session_start_time"
        case session_end_time = "session_end_time"
    }

}


//Mark : - Forgot Password struct

struct ForgetPasswordDataModel : Codable {
    let message : String?
   
    private enum CodingKeys: String, CodingKey {
        case message = "message"
        
    }
}


struct CMSResponce : Codable {
    let status : Int?
    let message : String?
    let cms_list : [Cms_list]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case cms_list = "cms_list"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        cms_list = try values.decodeIfPresent([Cms_list].self, forKey: .cms_list)
    }
    
}

struct Cms_list : Codable {
    let cms_id : String?
    let page_name : String?
    let cms_link : String?
    
    enum CodingKeys: String, CodingKey {
        
        case cms_id = "cms_id"
        case page_name = "page_name"
        case cms_link = "cms_link"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cms_id = try values.decodeIfPresent(String.self, forKey: .cms_id)
        page_name = try values.decodeIfPresent(String.self, forKey: .page_name)
        cms_link = try values.decodeIfPresent(String.self, forKey: .cms_link)
    }
    
}





class LoginModel {
    var loginDate:LoginDataModel?
    var breakDown:BreakdownData?
    var dashBoardDate: DashBoardInfo?
    var cmsData: CMSResponce?

    func userLogin(textDCNumber: String, passWord: String, vc : UIViewController, completionHandler: @escaping(_ status: String, _ message: String) ->() ) {
       
        let myParam:[String: AnyObject] = ["dc_no": textDCNumber as AnyObject, "password": passWord as AnyObject,"device_type":"1" as AnyObject]
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.login.url, callMethod: .post, param: myParam, responseModel: LoginDataModel.self, success: { (status, message,dict)   in
            
            if status == 0 {
                self.loginDate = dict as? LoginDataModel
                if  let accessToken = self.loginDate? .api_token_details?.token_key {
                    if !accessToken.isEmpty {
                        UserDefaults.standard.set(accessToken, forKey: USER_DEFAULT_TOKEN_KEY )
                        UserDefaults.standard.synchronize()
                    }
                }
                if   let user_id = self.loginDate?.driver_details?.user_id {
                    if !user_id.isEmpty {
                        UserDefaults.standard.set(user_id, forKey: USER_DEFAULT_USER_ID)
                        UserDefaults.standard.synchronize()
                    }
                }
                
                if let profileImage = self.loginDate?.driver_details?.profilePhoto {
                    if !profileImage.isEmpty {
                        UserDefaults.standard.set(profileImage, forKey: USER_DEFAULT_USER_IMAGE)
                        UserDefaults.standard.synchronize()
                    }
                }
                if let name = self.loginDate?.driver_details?.fullName {
                    if !name.isEmpty {
                        UserDefaults.standard.set(name, forKey: USER_DEFAULT_USER_NAME)
                        UserDefaults.standard.synchronize()
                    }
                }
                if let name = self.loginDate?.driver_details?.drDriverType {
                    if !name.isEmpty {
                        UserDefaults.standard.set(name, forKey: USER_DEFAULT_DRIVER_TYPE)
                        UserDefaults.standard.synchronize()
                    }
                }
                
                if let dcNumber = self.loginDate?.driver_details?.dc_no {
                    if !dcNumber.isEmpty {
                        UserDefaults.standard.set(dcNumber, forKey: USER_DEFAULT_USER_DC)
                        UserDefaults.standard.synchronize()
                    }
                }
                
                
                if let shiftStatus = self.loginDate?.shiftDetails?.status_code {
                    UserDefaults.standard.set(shiftStatus, forKey: USER_DEFAULT_USER_SHIFT_STATUS)
                    UserDefaults.standard.synchronize()
                    print("shiftStatus:", shiftStatus)
                    if shiftStatus != 0 {
                        if let shiftID = self.loginDate?.shiftDetails?.shift_id {
                            print("shiftID:", shiftID)
                            UserDefaults.standard.set(shiftID, forKey: USER_DEFAULT_USER_SHIFT_ID)
                        }
                        if let shiftNumber = self.loginDate?.shiftDetails?.shift_no {
                            print("shiftNumber:", shiftNumber)
                            UserDefaults.standard.set(shiftNumber, forKey: USER_DEFAULT_USER_SHIFT_NUMBER)
                        }
                         UserDefaults.standard.synchronize()
  
                    }else{
                        UserDefaults.standard.set(nil, forKey: USER_DEFAULT_USER_SHIFT_ID)
                        UserDefaults.standard.synchronize()
                    }
                }
                
                if let carNumber = self.loginDate?.shiftDetails?.car_id {
                    UserDefaults.standard.set(carNumber, forKey: USER_DEFAULT_USER_CAR_NO)
                    UserDefaults.standard.synchronize()
                }
                
                if let carNumber = self.loginDate?.shiftDetails?.car_no {
                    appDel.INSPECTION_CAR_NO = carNumber
                }
                
                

                completionHandler("Success",message)
            }else if (status == 2){
                 completionHandler(FORCE_LOGOUT,message)
            }
            else{
                 completionHandler("fail",message)
            }
            
        }) { (error) in
            print(error as Any)
            completionHandler("fail", error)
        }
        
        
    }
    
    
    
    func forgotPassworAPIcall(text: String, vc : UIViewController, completionHandler: @escaping(_ status: Int, _ message: String) ->()) {
        guard !text.isEmpty else {
              UtilityClass.tosta(message: ALERT_MESSAGE_DC_NUMBER_BLANK, duration: 1.0, vc: vc )
             return
        }
        let param = ["dc_no": text]
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.ForgotPassword.url, callMethod: .post, param: param as Dictionary<String, AnyObject>, responseModel: ForgetPasswordDataModel.self, success: { (status, message,dict) -> (Void) in
           completionHandler(status, message)
        }) { (message) in
            completionHandler(1, message as! String)
        }
        
    }
    
    func changePassworAPIcall(token: String, userID: String, oldPassword: String, newPassword: String,  completionHandler: @escaping(_ status: Int, _ message: String) ->()) {
        let param = ["token_key": token,
                     "device_type":"1",
                     "user_id":userID,
                     "old_password":oldPassword,
                     "new_password":newPassword
        ]
        
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.ChangePasswordAPI.url, callMethod: .post, param: param as Dictionary<String, AnyObject>, responseModel: ForgetPasswordDataModel.self, success: { (status, message,dict) -> (Void) in
            completionHandler(status, message)
        }) { (message) in
            completionHandler(1, message as! String)
        }
        
    }
    
    
    
    func logOutAPIcall(token: String, userID: String, shiftID: String,   completionHandler: @escaping(_ status: Int, _ message: String) ->()) {
        let param = ["token_key": token,
                     "device_type":"1",
                     "user_id":userID,
                     "shift_id":shiftID
        ]
        
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.LogoutAPI.url, callMethod: .post, param: param as Dictionary<String, AnyObject>, responseModel: LogOutDataModel.self, success: { (status, message,dict) -> (Void) in
            completionHandler(status, message)
        }) { (message) in
            completionHandler(1, message as! String)
        }
        
    }
    
    
    func getBreakDownNumber(token: String, complitionHandeler: @escaping(_ status: Int, _ message: String) ->()) {
        let param = ["device_type":"1", "token_key": token]
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.BreakdownNumber.url, callMethod: .post, param: param as Dictionary<String, AnyObject>, responseModel: BreakdownData.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.breakDown = dict as? BreakdownData
                complitionHandeler(status,message)
            }else if (status == 2){
                complitionHandeler(status,message)
            }
            else{
                complitionHandeler(status,message)
            }
        
        }, failed: { (message) in
            
        })

    }
    
    
    
    func getDashBoardInfo(token: String, carID: String , shiftID: String ,  complitionHandeler: @escaping(_ status: Int, _ message: String) ->()) {
        let userID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID ) ?? ""
        let param = ["device_type":"1", "token_key": token, "car_id": carID, "shift_id": shiftID, "user_id": userID]
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.DashboardAPI.url, callMethod: .post, param: param as Dictionary<String, AnyObject>, responseModel: DashBoardInfo.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.dashBoardDate = dict as? DashBoardInfo
                complitionHandeler(status,message)
            }else if (status == 2){
                complitionHandeler(status,message)
            }
            else{
                complitionHandeler(status,message)
            }
            
        }, failed: { (message) in
            
        })
        
    }
    
    
    
    
    func getDashBoardCMSLinks(token: String,   complitionHandeler: @escaping(_ status: Int, _ message: String) ->()) {
        let param = ["device_type":"1", "token_key": token]
        let apiManager = ServerRequestHandler()
        apiManager.callWebServiceApi(url: API.GetCMS.url, callMethod: .post, param: param as Dictionary<String, AnyObject>, responseModel: CMSResponce.self, success: { (status, message, dict) -> (Void) in
            if status == 0 {
                self.cmsData = dict as? CMSResponce
                complitionHandeler(status,message)
            }else if (status == 2){
                complitionHandeler(status,message)
            }
            else{
                complitionHandeler(status,message)
            }
            
        }, failed: { (message) in
            
        })
        
    }
    
}


