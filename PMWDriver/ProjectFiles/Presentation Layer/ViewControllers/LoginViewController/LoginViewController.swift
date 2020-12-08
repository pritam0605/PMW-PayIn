//
//  LoginViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 29/08/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: BaseViewController {
    @IBOutlet weak var textDCNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var textPassword: SkyFloatingLabelTextField!
    
    let loginModel = LoginModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("back to login")
        super.viewWillAppear(animated)
        if let userName = UserDefaults.standard.value(forKey:SAVE_USER_NAME){
            self.textDCNumber.text = userName as? String
        }
        if let password = UserDefaults.standard.value(forKey:SAVE_USER_PASSWORD){
            self.textPassword.text = password as? String
        }
    }
    
    
    func saveUsernameAndPassword(userName:String, password: String) {
        UserDefaults.standard.set(userName, forKey: SAVE_USER_NAME)
        UserDefaults.standard.set(password, forKey: SAVE_USER_PASSWORD)

    }
    
    @IBAction func buttonClickForgotPassWord(_ sender: UIButton) {
        let forgotPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    

    @IBAction func buttonClickSignUP(_ sender: UIButton) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpPageOneViewController") as! SignUpPageOneViewController
        signUpVC.isUseAsProfile = false
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    
    //Mark: - Login
    @IBAction func buttonClickLogin(_ sender: UIButton) {
        view.endEditing(true)
        guard !textDCNumber.text!.isEmpty else {
            UtilityClass.tosta(message: ALERT_MESSAGE_DC_NUMBER_BLANK, duration: 1.0, vc: self )
            print("empty message ")
            return
        }
        guard !textPassword.text!.isEmpty else {
            print("empty message ")
            UtilityClass.tosta(message: ALERT_MESSAGE_PASSWORD_BLANK, duration: 1.0, vc: self )
            return
        }
        showLoading()
        loginModel.userLogin(textDCNumber: textDCNumber.text ?? "", passWord: textPassword.text ?? "", vc: self) { (status,message)  in
            self.hideLoading()
            if status == "Success"{
//                self.textDCNumber.text = ""
//                self.textPassword.text = ""
                self.saveUsernameAndPassword(userName: self.textDCNumber.text! , password: self.textPassword.text!)
                UtilityClass.tosta(message: message, duration: 0.25, vc: self)
                self.navigateToCorrectPage()

            }else if status == FORCE_LOGOUT{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                    self.forceLogout()
                }
            }
            else{
                UtilityClass.tosta(message: message, duration: 1.0, vc: self)
            }
        }

    }
}
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension LoginViewController {
    func navigateToCorrectPage(){
    /*
        Status Code :
        0=>No Shift
        1=>Shift Available Today
        2=>Ongoing Shift
 */

        
        let shiftStatus :Int = UserDefaults.standard.value(forKey: USER_DEFAULT_USER_SHIFT_STATUS) as! Int
        if shiftStatus == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                let dashboardVC:ShiftDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShiftDetailsViewController") as! ShiftDetailsViewController
                self.navigationController?.pushViewController(dashboardVC, animated: true)
                
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                let dashboardVC  = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                dashboardVC.isBreakdown = false
                self.navigationController?.pushViewController(dashboardVC, animated: true)
            }
            
            
        }
        
    }
}

