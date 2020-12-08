//
//  Constent.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 09/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation
import UIKit



let SCREEN_SIZE = UIScreen.main.bounds
let FORCE_LOGOUT = "LogOut"
let USER_DEFAULT_TOKEN_KEY = "save_access_token"
let USER_DEFAULT_USER_ID = "save_user_id"
let USER_DEFAULT_USER_IMAGE = "save_driver_image"
let USER_DEFAULT_USER_NAME = "save_driver_name"
let USER_DEFAULT_DRIVER_TYPE = "save_driver_Type"
let USER_DEFAULT_USER_DC = "save_DC_number"
let USER_DEFAULT_USER_SHIFT_ID = "save_Shift_ID"
let USER_DEFAULT_USER_SHIFT_NUMBER = "save_Shift_Number"
let USER_DEFAULT_USER_SHIFT_STATUS = "save_Shift_status"
let USER_DEFAULT_USER_CAR_NO = "save_Car_NO"

//Accident user default key
let USER_DEFAULT_SAVE_CAR_INFO = "save_car_info"
let USER_DEFAULT_SAVE_INSURENCE = "save_insurence_status"
let USER_DEFAULT_SAVE_OWNER_DRIVER = "save_OWNER_DRIVER_status"
let USER_DEFAULT_SAVE_WITNESS_INFO = "save_witness_Details"
let USER_DEFAULT_CAR_NUMBER = "save_Car_number"
let USER_DEFAULT_IMAGE_ARRAY = "AccidentImage"

let USER_DEFAULT_SIGN_UP_PAGE_ONE = "SignUpPageOne"
let USER_DEFAULT_SIGN_UP_ADDRESS = "SignUpPageAddress"
let USER_DEFAULT_SIGN_UP_PERSONAL_INFO = "SignUpPagePersonalInfo"
let USER_DEFAULT_SIGN_UP_BANK_INFO = "SignUpPageBankInfo"


// sign up


let SAVE_USER_NAME = "SaveLoginDcNumber"
let SAVE_USER_PASSWORD = "SaveLoginPassword"


let DATE_FORMETE = "dd/MM/yyyy"
let TIME_FORMETE = "HH:mm"


let THEME_ORANGE_COLOR = UIColor(displayP3Red: 250/255.0, green: 186.0/255.0, blue: 62.0/255.0, alpha: 1.0)
let THEME_GREEN_COLOR = UIColor(displayP3Red: 61.0/255.0, green: 175/255.0, blue: 170/255.0, alpha: 1.0)
let THEME_BUTTON_GREEN_COLOR = UIColor(displayP3Red: 58.0/255.0, green: 163/255.0, blue: 158/255.0, alpha: 1.0)
var MY_USUER_ID:String?



//let baseURl = URL(string: "http://dev.fitser.com:3794/PunjabMotors/api/")
//let baseImageURl = URL(string: "http://dev.fitser.com:3794/PunjabMotors")





//Live url
//let baseURl = URL(string: "https://taxicamera.com.au/api/")
//let baseImageURl = URL(string: "https://taxicamera.com.au/")


////Test
let baseURl = URL(string: "https://taxicamera.com.au/pmw_live_testing/api/")
let baseImageURl = URL(string: "https://taxicamera.com.au/pmw_live_testing")


let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)

enum API {//forgotPassword
    case signUp
    case login
    case ForgotPassword
    case ProfileDetails
    case UpdateProfile
    case QuestionList
    case SubmitInspectionData
    case BreakdownNumber
    case DocketList
    case PayInsOnloadValue
    case ExpenseList
    case PayInsDataSubmit
    case PayInsList
    case SubmitAccidentData
    case RosterListAPI
    case ShiftDetailsAPI
    case StartShiftAPI
    case ChangePasswordAPI
    case LogoutAPI
    case DashboardAPI
    case LevyReportAPI
    case GetPreviousPayinsData
    case GetPayinsDetails
    case GetCMS
    case UpdateLocation

    var url :URL {
        switch self {
        case .signUp:
            return (baseURl?.appendingPathComponent("signup"))!
        case .login:
            return (baseURl?.appendingPathComponent("login"))!
        case .ForgotPassword:
            return (baseURl?.appendingPathComponent("forgotPassword"))!
        case .ProfileDetails:
            return (baseURl?.appendingPathComponent("profileDetails"))!
        case .UpdateProfile:
            return (baseURl?.appendingPathComponent("updateProfileData"))!
        case .QuestionList:
            return (baseURl?.appendingPathComponent("get_question_list"))!
        case .SubmitInspectionData:
            return (baseURl?.appendingPathComponent("submit_inspection_data"))!
        case .BreakdownNumber:
            return (baseURl?.appendingPathComponent("get_breakdown_number"))!
        case .DocketList:
            return (baseURl?.appendingPathComponent("get_docket_list"))!
        case .PayInsOnloadValue:
            return (baseURl?.appendingPathComponent("get_payin_onload_value"))!
        case .ExpenseList:
            return (baseURl?.appendingPathComponent("get_expense_list"))!
        case .PayInsDataSubmit:
            return (baseURl?.appendingPathComponent("submit_payin_data"))!
        case .PayInsList:
            return (baseURl?.appendingPathComponent("get_payin_list"))!
        case .SubmitAccidentData:
            return (baseURl?.appendingPathComponent("submit_accident_data"))!
        case .RosterListAPI:
             return (baseURl?.appendingPathComponent("get_roster_list"))!
        case .ShiftDetailsAPI:
            return (baseURl?.appendingPathComponent("get_shift_details"))!
        case .StartShiftAPI:
            return (baseURl?.appendingPathComponent("start_shift"))!
        case .ChangePasswordAPI:
            return (baseURl?.appendingPathComponent("changePassword"))!
        case .LogoutAPI:
            return (baseURl?.appendingPathComponent("logout"))!
        case .DashboardAPI:
            return (baseURl?.appendingPathComponent("dashboard"))!
        case .LevyReportAPI:
            return (baseURl?.appendingPathComponent("get_levy_report"))!
        case .GetPreviousPayinsData:
            return (baseURl?.appendingPathComponent("get_previous_payin_data"))!
        case .GetPayinsDetails:
            return (baseURl?.appendingPathComponent("get_payin_details"))!
        case .GetCMS:
            return (baseURl?.appendingPathComponent("get_cms_page_list"))!
        case .UpdateLocation:
             return (baseURl?.appendingPathComponent("update_car_current_location"))!

    }
    
    }
}


//------- Sampritee ------
struct PROJECT_CONSTANT {
    
    public typealias CLOUS = (()->())?
    public static func getSuperview(OfType type:AnyClass, fromView vw:AnyObject?) -> AnyObject? {
        guard vw != nil else {
            return nil
        }
        
        var myView = vw!
        
        if myView.isKind(of: type) {
            return myView
        }
        
        while myView.superview != nil {
            myView = myView.superview as AnyObject
            if myView.isKind(of: type) {
                return myView
            }
        }
        return nil
    }
    
    public static func displayAlert(Header strHeader:String!,MessageBody strMsgBody:String!,AllActions actions:[String:CLOUS],Style style:UIAlertController.Style,_ fromView:UIView? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: strHeader, message: strMsgBody, preferredStyle: style)
            for (key,val) in actions {
                if key.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "cancel" {
                    let action = UIAlertAction(title: key, style: .cancel, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                        if let actionHandler = val {
                            actionHandler()
                        }
                    })
                    alertController.addAction(action)
                }else{
                    let action = UIAlertAction(title: key, style: .default, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil)
                        if let actionHandler = val {
                            actionHandler()
                        }
                    })
                    alertController.addAction(action)
                }
            }
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController, let vc = appDel.topViewControllerWithRootViewController(rootViewController: rootVC) {
                if let popoverPresentationController = alertController.popoverPresentationController, let vw = fromView {
                    popoverPresentationController.sourceView = vw
                    popoverPresentationController.sourceRect = vw.bounds
                }
                vc.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
}
