//
//  LoginModel.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 16/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//


import Foundation
struct InspectionDataModel : Codable {
    let status : Int?
    let message : String?
    let question_list : [QuestionListDataModel]?
  
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case question_list = "question_list"
    }
}
struct QuestionListDataModel : Codable {
	let question_id : String?
	let question : String?
	var is_active : String?
	let created_by : String?
	let created_ts : String?
	let updated_by : String?
	let updated_ts : String?

	enum CodingKeys: String, CodingKey {

		case question_id = "question_id"
		case question = "question"
		case is_active = "is_active"
		case created_by = "created_by"
		case created_ts = "created_ts"
		case updated_by = "updated_by"
		case updated_ts = "updated_ts"
	}
/*
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		question_id = try values.decodeIfPresent(String.self, forKey: .question_id)
		question = try values.decodeIfPresent(String.self, forKey: .question)
		is_active = try values.decodeIfPresent(String.self, forKey: .is_active)
		created_by = try values.decodeIfPresent(String.self, forKey: .created_by)
		created_ts = try values.decodeIfPresent(String.self, forKey: .created_ts)
		updated_by = try values.decodeIfPresent(String.self, forKey: .updated_by)
		updated_ts = try values.decodeIfPresent(String.self, forKey: .updated_ts)
	}
*/
}
class QuestionListModel {
    var inspectionData:InspectionDataModel?
    func getQuestionList(token_key:String, completionHandler: @escaping(_ status: String, _ message: String, _ returnData: Any?) ->()) {
        /////data set for question list Api
        let myParam:[String: AnyObject] = ["token_key": token_key as AnyObject , "device_type" : "1" as AnyObject]
      
        ////// handel Api for question list
        let apiManager = ServerRequestHandler()
        
        apiManager.callWebServiceApi(url: API.QuestionList.url,
                                     callMethod: .post,
                                     param: myParam,
                                     responseModel: InspectionDataModel.self,
                                     success: { (status, message,dict) in
                                        if status == 0 {
                                             self.inspectionData = dict as? InspectionDataModel
                                             completionHandler("Success",message,self.inspectionData)
                                           
                                        }else if (status == 2){
                                            completionHandler("LogOut",message,nil)
                                        }
                                        else{
                                            completionHandler("fail",message,nil)
                                        }
        })
        { (error) in
            print(error as Any)
            completionHandler("fail", "Some thing error",nil)
        }
        
    }
    func inspectionDataSubmit(SubmissionData:[String: AnyObject],imageArray:[MultipartInfo], completionHandler: @escaping(_ status: String, _ message: String) ->()) {
        
        
        let apiManager = ServerRequestHandler()
       
            apiManager.uploadimageWithParamiter(url: API.SubmitInspectionData.url, parm: SubmissionData as Dictionary<String, AnyObject>, imagedate: imageArray, success: { (dict) -> (Void) in
                if let myResult:Dictionary<String, AnyObject> = dict as? Dictionary<String, AnyObject> {
                    
                   
                    let message = myResult["message"]
                    
                    completionHandler("Success",message as! String)
                    
                }
            }) { (error) in
               completionHandler("fail", "Some thing error")
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                //self.popToLoginPage()
            }
    }
}
