//
//  ForgotPasswordViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 30/08/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class ForgotPasswordViewController: BaseViewController {
    let model = LoginModel()
    @IBOutlet weak var textDCnumber:SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClickBack(_ sender: UIButton) {
        self.navigateToPreviousPage()
    }
    
    @IBAction func buttonClickForgotPassworf(_ sender: UIButton){
        view.endEditing(true)
        showLoading()
        model.forgotPassworAPIcall(text: textDCnumber.text ?? "", vc: self) { (status , message) in
            self.hideLoading()
            if status == 0 {
                self.textDCnumber.text = ""
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
               
            }else if status == 2{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    self.forceLogout()
                }
            }
            else{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
            
        }
    }
    
    
    
  
    @objc func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }

}
