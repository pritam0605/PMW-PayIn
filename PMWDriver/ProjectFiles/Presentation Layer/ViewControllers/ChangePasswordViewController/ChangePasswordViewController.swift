//
//  ChangePasswordViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 26/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var textOldPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var textNewPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var textConformPasword: SkyFloatingLabelTextField!
    var model = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func validation()  {
        guard !(self.textOldPassword.text?.isEmpty)! else {
            UtilityClass.tosta(message: ALERT_MESSAGE_PASSWORD_BLANK, duration: 1.5, vc: self)
            return
        }
        guard !(self.textNewPassword.text?.isEmpty)!  else {
            UtilityClass.tosta(message: ALERT_MESSAGE_PASSWORD_BLANK, duration: 1.5, vc: self)
             return
        }
        guard !(self.textConformPasword.text?.isEmpty)! else {
            UtilityClass.tosta(message: ALERT_MESSAGE_PASSWORD_BLANK, duration: 1.5, vc: self)
             return
        }
        
        guard self.textConformPasword.text == self.textNewPassword.text else {
            UtilityClass.tosta(message: ALERT_MESSAGE_PASS_NOT_MATCH, duration: 1.5, vc: self)
            return
        }
        self.callChangePassword()
    }
    
    func callChangePassword()  {
        let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY ) ?? ""
        let userID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID ) ?? ""
        self.showLoading()
        model.changePassworAPIcall(token: token, userID: userID, oldPassword: self.textOldPassword.text!, newPassword: self.textNewPassword.text!) { (status, message) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
            if status == 0{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.passWordChange()
                }
            }else if status == 2 {
                self.forceLogout()
            }else {
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
        }
    }

    func passWordChange()  {
        let vc:DashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.isBreakdown = false
        self.navigationController?.popPushToVC(ofKind: DashboardViewController.self, pushController: vc)
    }

    @IBAction func buttonDidTapSubmit(_ sender: ButtionX) {
        self.validation()
    }
    
}
