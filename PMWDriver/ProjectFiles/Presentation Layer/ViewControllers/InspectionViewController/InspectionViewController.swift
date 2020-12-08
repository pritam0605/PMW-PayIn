//
//  InspectionViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 02/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class InspectionViewController: BaseViewController {
    @IBOutlet weak var tableInspection: UITableView!
    @IBOutlet weak var lableCarNumber: UILabel!
    var arrQuestionListData = [QuestionListDataModel]()
    let questionListModel = QuestionListModel()
    
    var imageArray:[MultipartInfo] = [MultipartInfo]()
    var imageIndex:Int = -999
    
    var dataForSubmission = Dictionary<String, AnyObject> ()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableInspection.rowHeight =  UITableView.automaticDimension
        tableInspection.estimatedRowHeight = 100
        tableInspection.reloadData()
        self.lableCarNumber.text = "Car Number: \(appDel.INSPECTION_CAR_NO)"
        getQuestionList()
    }
    func getQuestionList() {
        guard let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) else {
            UtilityClass.tosta(message: "No token found", duration: 0.5, vc: self)
            return
        }
        guard let carNo = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_CAR_NO) else {
            UtilityClass.tosta(message: "No car no found", duration: 0.5, vc: self)
            return
        }
        guard let driverID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID) else {
            UtilityClass.tosta(message: "No driver no found", duration: 0.5, vc: self)
            return
        }
        self.showLoading()
        questionListModel.getQuestionList(token_key: token)
        {(status,message,returnData)  in
            
            if status == "Success"{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                 if  let question_list = self.questionListModel.inspectionData?.question_list {
                    self.arrQuestionListData =  question_list
                    
                    self.dataForSubmission["token_key"] = token as AnyObject
                    self.dataForSubmission["car_id"] = carNo as AnyObject
                    self.dataForSubmission["device_type"] = "1" as AnyObject
                    self.dataForSubmission["driver_id"] = driverID as AnyObject
                    
                    
                    var arrTemp = [[String:AnyObject]]()
                    for(_,Object) in self.arrQuestionListData.enumerated()
                    {
                        var questionListModelTemp : Dictionary<String, AnyObject> = [:]
                        questionListModelTemp["question_id"] = Object.question_id as AnyObject
                        //questionListModelTemp["answer"] = "0" as AnyObject
                        questionListModelTemp["answer"] = "1" as AnyObject //new added to default yes
                        
                        arrTemp.append(questionListModelTemp)
                        
                        /// changed as on 24.12.19
                        let imageKey = "images_" + "\(Object.question_id ?? "")" + "[]"
                        let imageMultiPart = MultipartInfo(key:imageKey, mimeType: .image_jpeg, data: nil, name: "blank")
                        self.imageArray.append(imageMultiPart)
                    }
                    self.dataForSubmission["inspection"] = arrTemp as AnyObject
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                 self.tableInspection.reloadData()
                }
                
            }else if status == "LogOut"{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    self.forceLogout()
                }
            }
            else{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                UtilityClass.tosta(message: message, duration: 1.0, vc: self)
            }
        }
        
        
    }
    
}
extension InspectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQuestionListData.count == 0 ? 0 : (arrQuestionListData.count + 1)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == arrQuestionListData.count {
           let cell: CommonTableViewCell = self.tableInspection.dequeueReusableCell(withIdentifier: "InspectionCell2") as! CommonTableViewCell
          
            cell.button_SubmitQuestion.addTarget(self, action: #selector(self.submitDataForQuestion), for: .touchUpInside)
            return cell
        }else{
            let cell: CommonTableViewCell = self.tableInspection.dequeueReusableCell(withIdentifier: "InspectionCell") as! CommonTableViewCell
            let mdOBJ = arrQuestionListData[indexPath.row]
            
            cell.labelQuestionName.text = mdOBJ.question
           
            cell.img_Yes.image = UIImage(named: "unSelect")
            cell.img_No.image = UIImage(named: "unSelect")
            
            
            
            var arrTemp = self.dataForSubmission["inspection"] as! [[String:AnyObject]]
            var dictTemp = arrTemp[indexPath.row]
            dictTemp["answer"] as! String == "1" ? (cell.img_Yes.image = UIImage(named: "green_Select")) : (cell.img_No.image = UIImage(named: "green_Select"))
            
            
            cell.button_Yes.tag = indexPath.row
            cell.button_Yes.addTarget(self, action: #selector(self.buttonSetActive), for: .touchUpInside)
            cell.button_No.tag = indexPath.row
            cell.button_No.addTarget(self, action: #selector(self.buttonSetInactive), for: .touchUpInside)
            
            cell.button_Camera.tag = indexPath.row
            cell.button_Camera.addTarget(self, action: #selector(self.setImageForQuestion), for: .touchUpInside)
            
           
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == arrQuestionListData.count  {
             return arrQuestionListData.count == 0 ? 0 : 60
        }else{
        return UITableView.automaticDimension
        }
    }
    
}
extension InspectionViewController
{
    @objc func buttonSetActive(_ sender :UIButton)  {
        let mdOBJ = arrQuestionListData[sender.tag]
        
        var arrTemp = self.dataForSubmission["inspection"] as! [[String:AnyObject]]
        var dictTemp = arrTemp[sender.tag]
        dictTemp["answer"] = "1"  as AnyObject
        dictTemp["question_id"] = mdOBJ.question_id as AnyObject
        arrTemp[sender.tag] = dictTemp
        self.dataForSubmission["inspection"] = arrTemp  as AnyObject
       
        tableInspection.reloadData()
    }
    @objc func buttonSetInactive(_ sender :UIButton)  {
        
        let mdOBJ = arrQuestionListData[sender.tag]
        
        var arrTemp = self.dataForSubmission["inspection"] as! [[String:AnyObject]]
        var dictTemp = arrTemp[sender.tag]
        dictTemp["answer"] = "0"  as AnyObject
        dictTemp["question_id"] = mdOBJ.question_id as AnyObject
        
        arrTemp[sender.tag] = dictTemp
        self.dataForSubmission["inspection"] = arrTemp as AnyObject
      
        tableInspection.reloadData()
    }
    @objc func setImageForQuestion(_ sender :UIButton)  {
       
        imageIndex = sender.tag
        customImageSelectPopUp()
    }
    
    func customImageSelectPopUp()  {
        let alert =  selectImageView()
        alert.isInspectionImageUpload = true
        alert.frame = UIScreen.main.bounds
        alert.CommonInit()
        //        DispatchQueue.main.async {
        //            alert.selectedImage.makeRound()
        //        }
        alert.delegate = self
        self.view.addSubview(alert)
    }
    
    @objc func submitDataForQuestion(_ sender :UIButton)  {
        //// chaged 24.12.19
        if self.imageArray.filter({$0.data != nil}).count != self.arrQuestionListData.count{
            UtilityClass.tosta(message: ALERT_MESSAGE_IMAGE_UPLOAD_INSPECTION, duration: 1.0, vc: self)
            return
        }
        /*
        guard (self.arrQuestionListData.count == imageArray.count) else {
            UtilityClass.tosta(message: ALERT_MESSAGE_IMAGE_UPLOAD, duration: 1.0, vc: self)
            return
        }*/
        var dataForSubmissionTemp = Dictionary<String, AnyObject> ()
        guard let shiftID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_SHIFT_ID) else {
            UtilityClass.tosta(message: "No Shift Id found", duration: 0.5, vc: self)
            return
        }
        dataForSubmissionTemp["token_key"] = dataForSubmission["token_key"] as AnyObject
        dataForSubmissionTemp["device_type"] = dataForSubmission["device_type"] as AnyObject
        dataForSubmissionTemp["car_id"] = dataForSubmission["car_id"] as AnyObject
        dataForSubmissionTemp["driver_id"] = dataForSubmission["driver_id"] as AnyObject
        dataForSubmissionTemp["shift_id"] = shiftID as AnyObject
        
        let arrTemp = self.dataForSubmission["inspection"] as! [[String:AnyObject]]
        for(index,Object) in arrTemp.enumerated()
        {
            let question_id_key = "inspection[" + "\(index)" + "][question_id]"
            let answer_key = "inspection[" + "\(index)" + "][answer]"
            
            dataForSubmissionTemp[question_id_key] = Object["question_id"]
            dataForSubmissionTemp[answer_key] = Object["answer"]
            
        }
        
        
      self.showLoading()
      questionListModel.inspectionDataSubmit(SubmissionData: dataForSubmissionTemp, imageArray: imageArray)
        {(status,message) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
            if status == "Success"{
                 appDel.IS_INSPECTION_DONE = 1
                  UtilityClass.tostaOnWindow(message: message, duration: 0.5, vc: self)//new
                 let vc:DashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                self.navigationController?.popPushToVC(ofKind: DashboardViewController.self, pushController: vc)
                
            }else if status == "LogOut"{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    self.forceLogout()
                }
            }
            else{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                UtilityClass.tosta(message: message, duration: 1.0, vc: self)
                
            }
        }
    }
    
    
    func showAlertForDashBoard(strTitle: String, strMessage: String)  {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
           
            let vc:DashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            vc.isBreakdown = false
            self.navigationController?.popPushToVC(ofKind: DashboardViewController.self, pushController: vc)
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    
}
extension InspectionViewController: UpdateImageArrayDelegate {
    func imageSelectedDone(_ selectedImage: UIImage, imageName: String) {
        
        guard let imgData = selectedImage.jpegData(compressionQuality: 0.30) else { return  }
        let mdOBJ = arrQuestionListData[imageIndex]
        let imageKey = "images_" + mdOBJ.question_id! + "[]"
        let imageMultiPart = MultipartInfo(key: imageKey, mimeType: .image_jpeg, data: imgData, name: imageName)
        
        let index = IndexPath(row: imageIndex, section: 0)
        guard let cell:CommonTableViewCell  = self.tableInspection.cellForRow(at: index) as? CommonTableViewCell else {
            return
        }
        //// chaged 24.12.19
        imageArray[imageIndex] = imageMultiPart
        /*
        if(imageArray.count == 0 || imageArray.count < arrQuestionListData.count){
            imageArray.append(imageMultiPart)
        }else{
            imageArray[imageIndex] = imageMultiPart
        }*/
         cell.imgCamera.image = UIImage(named: "Tick")
    }
    
    func cancelButtonPress() {
       
    }
    
}
