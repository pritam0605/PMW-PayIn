//
//  PayinsPageOneViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 04/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PayinsPageOneViewController: BaseViewController {
    let model = PayInsModel()
    let token =  UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) ?? ""
    let carID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_CAR_NO) ?? ""
    var startDataModel: PreviousPayinDetails?
    var isAllFieldAreOk = false
    var imageType:String?
    
    @IBOutlet weak var textTotalStart: SkyFloatingLabelTextField!
    @IBOutlet weak var texttotalFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textPaidKMStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textPaidKMFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textTotalKMStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textTotalKMFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textNoOfHiringsStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textNoOfHiringsFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textExtraStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textExtraFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textSpeedoStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textSpeedoFinish: SkyFloatingLabelTextField!
    
    @IBOutlet weak var buttonDocumentUpload: UIButton!
    
    @IBOutlet weak var buttonLifetimeTotal: UIButton!
    
    @IBOutlet weak var textKMTravel: UITextField!
    @IBOutlet weak var textMeterdFares: UITextField!
    var payInsData:[String: String] = [String:String]()
    
    //var imagePayinOneArray:[MultipartInfo] = [MultipartInfo]()//new
    /// changed as on 24.12.19
    var imagePayinOneArray:[MultipartInfo] = [MultipartInfo(key:"payin_reference_doc", mimeType: .image_jpeg, data: nil, name: "blank"), MultipartInfo(key:"payin_lifetime_total", mimeType: .image_jpeg, data: nil, name: "blank")]
    
    var selectImage:selectImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllPayInsStartData()
        textTotalStart.textAlignment  = .center
        texttotalFinish.textAlignment = .center
        textPaidKMStart.textAlignment = .center
        textPaidKMFinish.textAlignment = .center
        textTotalKMStart.textAlignment = .center
        textTotalKMFinish.textAlignment = .center
        textNoOfHiringsStart.textAlignment = .center
        textNoOfHiringsFinish.textAlignment = .center
        textExtraStart.textAlignment = .center
        textExtraFinish.textAlignment = .center
        textSpeedoStart.textAlignment = .center
        textSpeedoFinish.textAlignment = .center
        // Do any additional setup after loading the view.
    }
    
    
    func getAllPayInsStartData() {
        self.showLoading()
        model.getAllPayInsStartData(token: token, carId: carID) { (status, message) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
            if status == 0 {
            self.startDataModel = self.model.payInsPreviousData?.previous_payin_details
            self.populateDataInStartReading()
            }else if status == 2 {
                self.forceLogout()
            }else{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
            
        }
    }
    
    
    func populateDataInStartReading() {
        self.textTotalStart.text = self.startDataModel?.total_extra_start
        self.textPaidKMStart.text = self.startDataModel?.paid_km_start
        self.textTotalKMStart.text = self.startDataModel?.total_km_start
        self.textNoOfHiringsStart.text = self.startDataModel?.no_of_hiring_start
        self.textExtraStart.text = self.startDataModel?.extra_start
        self.textSpeedoStart.text = self.startDataModel?.speedo_reading_start
    }
    
    
    @IBAction func buttonClickUploadDocImage(_ sender: UIButton) {
        self.selectImage = selectImageView()
        self.imageType = "payin_reference_doc"
        selectImage?.frame = UIScreen.main.bounds
        selectImage?.CommonInit()
        selectImage?.delegate = self
        self.view.addSubview(selectImage!)
    }
    
    @IBAction func buttonClickLifetimeTotalUpload(_ sender: UIButton) {
        self.selectImage = selectImageView()
         self.imageType = "payin_lifetime_total"
          selectImage?.frame = UIScreen.main.bounds
          selectImage?.CommonInit()
          selectImage?.delegate = self
          self.view.addSubview(selectImage!)
      }
    
    @IBAction func buttonClickNext(_ sender: UIButton) {
        if validation() {
            payInsData.removeAll()
            payInsData["total_extra_start"] = textTotalStart.text
            payInsData["total_extra_end"] = texttotalFinish.text
            
            payInsData["paid_km_start"] = textPaidKMStart.text
            payInsData["paid_km_end"] = textPaidKMFinish.text
            
            payInsData["total_km_start"] = textTotalKMStart.text
            payInsData["total_km_end"] = textTotalKMFinish.text
            
            payInsData["no_of_hiring_start"] = textNoOfHiringsStart.text
            payInsData["no_of_hiring_end"] = textNoOfHiringsFinish.text
            
            payInsData["extra_start"] = textExtraStart.text
            payInsData["extra_end"] = textExtraFinish.text
            
            payInsData["speedo_reading_start"] = textSpeedoStart.text
            payInsData["speedo_reading_end"] = textSpeedoFinish.text
            
            
            payInsData["km_traveled"] = textKMTravel.text
            payInsData["metered_fares"] = textMeterdFares.text

            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayinsPageTwoViewController") as! PayinsPageTwoViewController
            vc.payInsData = payInsData
            vc.payinOneImage = self.imagePayinOneArray[0]
            vc.payinTwoImage = self.imagePayinOneArray[1]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: SkyFloatingLabelTextField) {
        if(sender == textSpeedoStart)
        {
            if(textSpeedoStart.text?.count != 0)
            {
                if(textSpeedoFinish.text?.count != 0)
                {
                    let kmTravelled = (textSpeedoFinish.text! as NSString).intValue - (textSpeedoStart.text! as NSString).intValue
                    textKMTravel.text = "\(kmTravelled)"
                }
            }
        }
        else if(sender == textSpeedoFinish)
        {
            if(textSpeedoFinish.text?.count != 0)
            {
                if(textSpeedoStart.text?.count != 0)
                {
                 
                     let kmTravelled = (textSpeedoFinish.text! as NSString).intValue - (textSpeedoStart.text! as NSString).intValue
                    textKMTravel.text = "\(kmTravelled)"
                }
            }
        }
        else  if(sender == textTotalStart)
        {
            if(textTotalStart.text?.count != 0)
            {
                if(texttotalFinish.text?.count != 0)
                {
                    let meterFare = (texttotalFinish.text! as NSString).floatValue - (textTotalStart.text! as NSString).floatValue
                    textMeterdFares.text = "\(meterFare)"
                }
            }
        }
        else if(sender == texttotalFinish)
        {
            if(texttotalFinish.text?.count != 0)
            {
                if(textTotalStart.text?.count != 0)
                {
                    let meterFare = (texttotalFinish.text! as NSString).floatValue - (textTotalStart.text! as NSString).floatValue
                    textMeterdFares.text = "\(meterFare)"
                }
            }
        }
    }
    
}
extension PayinsPageOneViewController {
    func textValueValidation() -> Bool {
        if (Double(self.textTotalStart.text!)! >  Double(self.texttotalFinish.text!)!){
            showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
//            UtilityClass.tosta(message: ALERT_MESSAGE_START_VALUE_BIGGER, duration: 1.0, vc: self)
            return false
        }
        if (Double(self.textPaidKMStart.text!)! >  Double(self.textPaidKMFinish.text!)!){
             showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
           // UtilityClass.tosta(message: ALERT_MESSAGE_START_VALUE_BIGGER, duration: 1.0, vc: self)
            return false
        }
        if (Double(self.textTotalKMStart.text!)! >  Double(self.textTotalKMFinish.text!)!){
             showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
            //UtilityClass.tosta(message: ALERT_MESSAGE_START_VALUE_BIGGER, duration: 1.0, vc: self)
            return false
        }

        if (Double(self.textNoOfHiringsStart.text!)! >  Double(self.textNoOfHiringsFinish.text!)!){
             showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
           // UtilityClass.tosta(message: ALERT_MESSAGE_START_VALUE_BIGGER, duration: 1.0, vc: self)
            return false
        }

        if (Double(self.textExtraStart.text!)! >  Double(self.textExtraFinish.text!)!){
             showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
            //UtilityClass.tosta(message: ALERT_MESSAGE_START_VALUE_BIGGER, duration: 1.0, vc: self)
            return false
        }
        if (Double(self.textSpeedoStart.text!)! >  Double(self.textSpeedoFinish.text!)!){
             showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
            //UtilityClass.tosta(message: ALERT_MESSAGE_START_VALUE_BIGGER, duration: 1.0, vc: self)
            return false
        }
      return true
    }
    
    func validation() -> Bool {
        //// chaged 24.12.19
        if self.imagePayinOneArray.filter({$0.data != nil}).count != 2{
            UtilityClass.tosta(message: ALERT_MESSAGE_IMAGE_UPLOAD_PAYINS, duration: 1.0, vc: self)
            return false
        }
        /*
        if self.imagePayinOneArray.count != 2 {
            UtilityClass.tosta(message: ALERT_MESSAGE_IMAGE_UPLOAD_PAYINS, duration: 1.0, vc: self)
            return false
        }*/
        if textTotalStart.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_TOTAL_EXTRA_START_BLANK, duration: 1.0, vc: self)
            return false
        }
        if texttotalFinish.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_TOTAL_EXTRA_FINISH_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textPaidKMStart.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_PAIDKM_START_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textPaidKMFinish.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_PAIDKM_FINISH_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textTotalKMStart.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_TOTALKM_START_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textTotalKMFinish.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_TOTALKM_FINISH_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textNoOfHiringsStart.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_HIRINGS_START_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textNoOfHiringsFinish.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_HIRINGS_FINISH_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textExtraStart.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_EXTRA_START_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textExtraFinish.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_EXTRA_FINISH_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textSpeedoStart.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_CARSPEED_START_BLANK, duration: 1.0, vc: self)
            return false
        }
        if textSpeedoFinish.text == "" {
            
            UtilityClass.tosta(message: ALERT_MESSAGE_CARSPEED_FINISH_BLANK, duration: 1.0, vc: self)
            return false
        }
      return isAllFieldAreOk
    }
}



extension PayinsPageOneViewController :UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.textInputMode?.primaryLanguage !=  "hi" else {
            showAlertMessage(title: "", message: "Please change language to english", vc: self)
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField){

        if textField == self.textTotalStart ||  textField == self.texttotalFinish{
            
            let textTotalStart = self.textTotalStart.text == "" ? "0.0" : self.textTotalStart.text
            let texttotalFinish = self.texttotalFinish.text == "" ? "0.0" : self.texttotalFinish.text

            if (Double(textTotalStart!)! >  Double(texttotalFinish!)!){
                 showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
                isAllFieldAreOk = false
            }else{
                isAllFieldAreOk = true
            }
            
        }
        if textField == self.textPaidKMStart ||  textField == self.textPaidKMFinish {
            let textPaidKMStart = self.textPaidKMStart.text == "" ? "0.0" : self.textPaidKMStart.text
            let textPaidKMFinish = self.textPaidKMFinish.text == "" ? "0.0" : self.textPaidKMFinish.text

            if (Double(textPaidKMStart!)! >  Double(textPaidKMFinish!)!){
               showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
                isAllFieldAreOk = false
            }else{
                isAllFieldAreOk = true
            }
        }
        if textField == self.textTotalKMStart ||  textField == self.textTotalKMFinish {
            let textTotalKMStart = self.textTotalKMStart.text == "" ? "0.0" : self.textTotalKMStart.text
            let textTotalKMFinish = self.textTotalKMFinish.text == "" ? "0.0" : self.textTotalKMFinish.text
            if Double(textTotalKMStart!)! >  Double(textTotalKMFinish!)!{
                showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
                isAllFieldAreOk = false
            }else{
                isAllFieldAreOk = true
            }

        }
        if textField == self.textNoOfHiringsStart ||  textField == self.textNoOfHiringsFinish {
            
            let textNoOfHiringsStart = self.textNoOfHiringsStart.text == "" ? "0" : self.textNoOfHiringsStart.text
            let textNoOfHiringsFinish = self.textNoOfHiringsFinish.text == "" ? "0" : self.textNoOfHiringsFinish.text

            
            if (Double(textNoOfHiringsStart!)! >  Double(textNoOfHiringsFinish!)!){
                showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
                isAllFieldAreOk = false
            }else{
                isAllFieldAreOk = true
            }
        }
        if textField == self.textExtraStart ||  textField == self.textExtraFinish {
            
            let textExtraStart = self.textExtraStart.text == "" ? "0.0" : self.textExtraStart.text
            let textExtraFinish = self.textExtraFinish.text == "" ? "0.0" : self.textExtraFinish.text

            if (Double(textExtraStart!)! >  Double(textExtraFinish!)!){
                showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
                isAllFieldAreOk = false
            }else{
                isAllFieldAreOk = true
            }
            
          
            
        }
        if textField == self.textSpeedoStart ||  textField == self.textSpeedoFinish {
            let textSpeedoStart = self.textSpeedoStart.text == "" ? "0.0" : self.textSpeedoStart.text
            let textSpeedoFinish = self.textSpeedoFinish.text == "" ? "0.0" : self.textSpeedoFinish.text

            if (Double(textSpeedoStart!)! >  Double(textSpeedoFinish!)!){
                 showAlertMessage(title: "", message: ALERT_MESSAGE_START_VALUE_BIGGER, vc: self)
                isAllFieldAreOk = false
            }else{
                isAllFieldAreOk = true
            }
            
        }
        
    }
}

extension PayinsPageOneViewController : UpdateImageArrayDelegate {
    func imageSelectedDone(_ selectedImage: UIImage, imageName: String) {
        // self.imagePayinOneArray.removeAll()
        ///Code commented as 16th Dec
        guard let imgData = selectedImage.jpegData(compressionQuality: 0.2) else { return  }
        let imageMultiPart = MultipartInfo(key: self.imageType , mimeType: .image_jpeg, data: imgData, name: imageName)
        
        //self.imagePayinOneArray.append(imageMultiPart)
        // self.buttonDocumentUpload.setTitle("UPLOADED", for: .normal)
        if self.imageType == "payin_reference_doc"{
            self.buttonDocumentUpload.backgroundColor = THEME_ORANGE_COLOR
            imagePayinOneArray[0] = imageMultiPart
        }else{
            self.buttonLifetimeTotal.backgroundColor = THEME_ORANGE_COLOR
            imagePayinOneArray[1] = imageMultiPart
        }
        
        if self.selectImage != nil{
                   self.selectImage = nil
               }
    }
    
    func cancelButtonPress() {
        if self.selectImage != nil{
            self.selectImage = nil
        }
        print("cancelButtonPress")
    }
}
