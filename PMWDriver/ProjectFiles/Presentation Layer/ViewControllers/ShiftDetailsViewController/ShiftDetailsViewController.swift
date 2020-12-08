//
//  ShiftDetailsViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 29/08/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
class ShiftDetailsViewController: BaseViewController {
    
    @IBOutlet weak var imageprofile: UIImageView!
    @IBOutlet weak var labelDCNumber: UILabel!
    @IBOutlet weak var labelDriverName: UILabel!
    @IBOutlet weak var labelDayName: UILabel!
    @IBOutlet weak var labelCarNumber: UILabel!
    @IBOutlet weak var labelShiftTime: UILabel!
    @IBOutlet weak var lableShiftName: UILabel!
    
    
    // new OutLet
    @IBOutlet weak var startShiftStatusView: UIView!
    @IBOutlet weak var labelShiftStatus: UILabel!
    @IBOutlet weak var buttonStartShift: UIButton!
    
    
    var dataModel:ShiftDetailsModel?
    var roster_driver_id: String = ""
    let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) ?? ""
    let User_id = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID) ?? ""
    var model = ShiftDetailsClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelShiftStatus.isHidden = true
        self.startShiftStatusView.isHidden = true
        self.buttonStartShift.isHidden = true
        
        
        if let name = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_NAME) {
            self.labelDriverName.text = "Name: \(name)"
        }
        
        if let DC_number = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_DC) {
            self.labelDCNumber.text = "DC: \(DC_number)"
        }
        
        if let image = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_IMAGE) {
            setImageInImageView(imageName: image, placeHolderImage: "Driver_photo", imageView:  self.imageprofile)
//            if let profileImage =  self.getImage(imageName: image){
//                DispatchQueue.main.async {
//                    self.imageprofile.image = profileImage
//                }
//            }
        }
        self.getCurrentShiftData()
    }
    
    
    override func viewDidLayoutSubviews() {
        self.imageprofile.makeRound()
        self.imageprofile.layer.borderColor = THEME_GREEN_COLOR.cgColor
        self.imageprofile.layer.borderWidth = 2
    }
    
    //Mark: - Button Tap for Start Shift
    @IBAction func buttonDidTapStartShift(_ sender: UIButton) {
        callStartShiftApiCall()
    }
    
    func getCurrentShiftData()  {
        self.showLoading()
        model.getCurrentShiftDetails(token: token, driver: User_id) { (status, message) in
            self.hideLoading()
            if status == 0{
                DispatchQueue.main.async {
                    self.buttonStartShift.isHidden = self.model.shiftDataModel?.shiftDetails?.status_code != 1 ? true: false
                    self.labelShiftStatus.isHidden = self.model.shiftDataModel?.shiftDetails?.status_code == 1 ? true: false
                    self.labelShiftStatus.text = self.model.shiftDataModel?.shiftDetails?.statusMessage
                    self.startShiftStatusView.isHidden = self.model.shiftDataModel?.shiftDetails?.status_code == 1 ? true: false
                }
                
                if let carNumber = self.model.shiftDataModel?.shiftDetails?.car_no {
                    appDel.INSPECTION_CAR_NO = carNumber
                }
                
                if let carID = self.model.shiftDataModel?.shiftDetails?.car_id {
                    UserDefaults.standard.set(carID, forKey: USER_DEFAULT_USER_CAR_NO)
                    UserDefaults.standard.synchronize()
                }
                if ((self.model.shiftDataModel?.shiftDetails) != nil )&&(self.model.shiftDataModel?.shiftDetails?.status_code == 1) {
                    self.dataModel = self.model.shiftDataModel?.shiftDetails
                    DispatchQueue.main.async {
                        self.populateData(shiftDetails: self.dataModel! )
                    }
                }
            }else if status == 2 {
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                self.forceLogout()
            }else{
                self.hideLoading()
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
        }
    }
    
    
    func callStartShiftApiCall() {
        roster_driver_id = self.model.shiftDataModel?.shiftDetails?.roster_driver_id ?? ""
        self.showLoading()
        model.getStartShiftDetails(token: token, rosterDrive: roster_driver_id) { (status, message) in
            self.hideLoading()
            if status == 0{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                if let shiftID = self.model.startShiftModel?.shift_details?.shiftId {
                    print("shiftID:", shiftID)
                    UserDefaults.standard.set(2, forKey: USER_DEFAULT_USER_SHIFT_STATUS)
                    let shift_no = self.model.startShiftModel?.shift_details?.shift_no

                    UserDefaults.standard.set(shift_no, forKey: USER_DEFAULT_USER_SHIFT_NUMBER)
                    UserDefaults.standard.set(shiftID, forKey: USER_DEFAULT_USER_SHIFT_ID)
                    UserDefaults.standard.synchronize()
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    let dashboardVC  = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                    dashboardVC.isBreakdown = false
                    self.navigationController?.pushViewController(dashboardVC, animated: true)
                }
                
            }else if status == 2 {
                self.forceLogout()
            }else {
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
        }
    }
    
    func populateData(shiftDetails: ShiftDetailsModel)  {
        self.labelCarNumber.text = ""
        self.labelDayName.text =  ""
        self.labelShiftTime.text = ""
        self.lableShiftName.text = ""
        self.labelCarNumber.text = shiftDetails.car_no
        self.labelDayName.text = shiftDetails.dayname
        let totalString = shiftDetails.shift_name
        let strArray:[String] = totalString?.components(separatedBy: " ") ?? ["",""]
        self.lableShiftName.text = strArray[0] as String
        let a = totalString?.components(separatedBy: strArray[0] as String) ?? ["",""]
        self.labelShiftTime.text = a[1] as String
    }
}
