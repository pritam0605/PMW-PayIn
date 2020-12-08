//
//  DashboardViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 29/08/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SideMenu
import MessageUI
import CoreLocation

class DashboardViewController: BaseViewController, MFMessageComposeViewControllerDelegate {
    var isBreakdown:Bool?
    var model = LoginModel()
    var phoneNumber = ""
    var whatsAppNumber = ""
    var messageNumber = ""
    @IBOutlet weak var viewBreakDown: UIView!
    @IBOutlet weak var labelDCNumber: UILabel!
    @IBOutlet weak var labelDriverName: UILabel!
    @IBOutlet weak var imageprofile: UIImageView!
    @IBOutlet weak var lableTitle: UILabel!
    @IBOutlet weak var lableMainTitle: UILabel!
    @IBOutlet weak var labelShiftID: UILabel!
    @IBOutlet weak var labelTotalPayOut: UILabel!
    @IBOutlet weak var labelAccumulated: UILabel!
    @IBOutlet weak var buttonEndShift: UIButton!
    @IBOutlet weak var buttonsStack: UIStackView!
    
    @IBOutlet weak var btnCompanyDetails: UIButton!
    @IBOutlet weak var btnCompanyCars: UIButton!
    @IBOutlet weak var btnTAndA: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        MyLocationManager.share.requestForLocation()
        self.viewBreakDown.isHidden = !isBreakdown!
        self.buttonEndShift.isHidden = isBreakdown!
        self.buttonsStack.isHidden = isBreakdown!
        self.labelShiftID.text = ""
        self.buttonEndShift.isHidden = true
//        if !isBreakdown! {
//            self.getDashBoardData() // if not call as break down
//            self.getCMScontains()
//            if let shiftNumber = UserDefaults.standard.value(forKey: USER_DEFAULT_USER_SHIFT_NUMBER ) {
//                if let shiftNumber: String = shiftNumber as? String {
//                    self.labelShiftID.text = shiftNumber.isEmpty ? "" : "Shift ID: \(shiftNumber)"
//                    self.buttonEndShift.isHidden = shiftNumber.isEmpty
//                    if CLLocationManager.locationServicesEnabled(){
//                        MyLocationManager.share.configManager()
//                        MyLocationManager.share.startTimer()
//                    }
//                }
//            }
//        }
        lableTitle.text = isBreakdown == true ? "BREAKDOWN ALERT":"DASHBOARD"
        lableMainTitle.text  = isBreakdown == true ? "Breakdown Alert":"Dashboard"
        
        if isBreakdown!{
            self.getNumber()
        }
        
        
        
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
               if !isBreakdown! {
                   self.getDashBoardData() // if not call as break down
                   self.getCMScontains()
                   if let shiftNumber = UserDefaults.standard.value(forKey: USER_DEFAULT_USER_SHIFT_NUMBER ) {
                       if let shiftNumber: String = shiftNumber as? String {
                           self.labelShiftID.text = shiftNumber.isEmpty ? "" : "Shift ID: \(shiftNumber)"
                           self.buttonEndShift.isHidden = shiftNumber.isEmpty
                           if CLLocationManager.locationServicesEnabled(){
                               MyLocationManager.share.configManager()
                               MyLocationManager.share.startTimer()
                           }
                       }
                   }
               }

        if CLLocationManager.locationServicesEnabled(){
            MyLocationManager.share.configManager()
            
            if  !self.labelShiftID.text!.isEmpty  {
                 MyLocationManager.share.startTimer()
            }
        }
        if let name = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_NAME) {
            self.labelDriverName.text = "Name: \(name)"
        }
        if let image = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_IMAGE) {
            setImageInImageView(imageName: image, placeHolderImage: "Driver_photo", imageView:  self.imageprofile)
        }
        if let DC_number = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_DC) {
            self.labelDCNumber.text = "DC: \(DC_number)"
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        self.imageprofile.makeRound()
        self.imageprofile.layer.borderColor = THEME_GREEN_COLOR.cgColor 
        self.imageprofile.layer.borderWidth = 2
    }
    
    
    
    @IBAction func buttonSendSMS(_ sender: UIButton){
     self.sendTextSMS(ph: self.messageNumber )
    }
    
    
    @IBAction func buttonClickEndShift(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayinsPageOneViewController") as! PayinsPageOneViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonWhatssApp(_ sender: UIButton) {
        self.sendTextToUnsavedNumber(phoneNumber: self.whatsAppNumber)
    }
    
    @IBAction func buttonSendCall(_ sender: UIButton) {
        self.callNumber(phoneNumber: self.phoneNumber)
    }

    @IBAction func buttonDidTapCompanyDetails(_ sender: UIButton) {
        self.deepLinkingToUrl(str: self.model.cmsData?.cms_list?[0].cms_link ?? "")
    }
    
    @IBAction func buttonDidTapCompanyCar(_ sender: UIButton) {
        self.deepLinkingToUrl(str: self.model.cmsData?.cms_list?[1].cms_link ?? "")
    }
    
    @IBAction func butttonDidTapTA(_ sender: UIButton) {
        self.deepLinkingToUrl(str: self.model.cmsData?.cms_list?[2].cms_link ?? "")
    }
    
    
    
    
    func getDashBoardData() {
        self.showLoading()
         let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) ?? ""
         let carID =  UserDefaults.standard.string(forKey: USER_DEFAULT_USER_CAR_NO) ?? ""
         let shiftID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_SHIFT_ID ) ?? ""
        model.getDashBoardInfo(token: token, carID: carID, shiftID: shiftID) { (status, message) in
            DispatchQueue.main.async {
              self.hideLoading()
            }
            if status == 0{
                self.labelTotalPayOut.text = self.model.dashBoardDate?.inspection_details?.total_payout ?? ""
                self.labelAccumulated.text = self.model.dashBoardDate?.inspection_details?.bond_accumulated ?? ""
                
//                Inspection Status
//                0=>Inspection Not Done
//                1=>Inspection OK
//                2=> Inspection Not needed for no shift
                
                if let inspetionStatus = self.model.dashBoardDate?.inspection_details?.status_code {
                    if inspetionStatus == 0{
                        appDel.IS_INSPECTION_DONE = inspetionStatus
                        self.inspectionPending()
                    }else{
                        appDel.IS_INSPECTION_DONE = 1
                    }
                }
            }else if  status == 2 {
                self.forceLogout()
            }else{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
        }
 
        
    }
    
    
    
    func getCMScontains() {
        self.showLoading()
        let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) ?? ""
        model.getDashBoardCMSLinks(token:  token) { (status, message) in
           
            if status == 0{
                DispatchQueue.main.async {
                    self.hideLoading()
                    self.btnCompanyDetails.setTitle(self.model.cmsData?.cms_list?[0].page_name, for: .normal)
                    self.btnCompanyCars.setTitle(self.model.cmsData?.cms_list?[1].page_name, for: .normal)
                    self.btnTAndA.setTitle(self.model.cmsData?.cms_list?[2].page_name, for: .normal)
                }
              
            }else if  status == 2 {
                DispatchQueue.main.async {
                    self.hideLoading()
                }
            }else{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
        }
    
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Mark :- call API to get a number
    func getNumber()  {
        self.showLoading()
        guard let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) else { return  }
        model.getBreakDownNumber(token: token) { (status, message) in
            self.hideLoading()
            if status == 0{
                self.phoneNumber = self.model.breakDown?.breakdown_data?.breakdown_call_no ?? ""
                self.messageNumber = self.model.breakDown?.breakdown_data?.breakdown_sms_no ?? ""
                self.whatsAppNumber = self.model.breakDown?.breakdown_data?.breakdown_whatsup_no ?? ""
            }else if  status == 2 {
                self.forceLogout()
            }else{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
        }
    }
    
    
    //Mark: - Call to A number
    func callNumber(phoneNumber:String){
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
        
    }
    
    func inspectionShowAlert(strTitle: String, strMessage: String)  {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
           self.inspectionPending()
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    
    func inspectionPending() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"InspectionViewController") as! InspectionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Mark: - Send message to A number
    func sendTextSMS(ph:String){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [ph]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    
    func sendTextToUnsavedNumber(phoneNumber:String){
        let whatsAppUrl = NSURL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=")
        if UIApplication.shared.canOpenURL(whatsAppUrl! as URL) {
             UIApplication.shared.open(whatsAppUrl! as URL, options: [:], completionHandler: nil)
        }
        else {
            UtilityClass.tosta(message: ALERT_MESSAGE_WHATS_APP, duration: 0.5, vc: self)
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DashboardViewController {

    func deepLinkingToUrl(str: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.urlToOpen = str
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
