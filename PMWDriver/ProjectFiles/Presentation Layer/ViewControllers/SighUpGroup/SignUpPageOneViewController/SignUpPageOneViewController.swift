//
//  SignUpPageOneViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class SignUpPageOneViewController: BaseViewController {
    var isUseAsProfile:Bool?
    var signUpStringInfo:[String: String]?
    var model = SignUpModel()
    @IBOutlet weak var registrationTable:UITableView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewSignUp: UIView!
    var isDataSave: Bool?
    var arrContainer = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(navigationController?.viewControllers)
        signUpStringInfo = [:]
        if (isUseAsProfile!){
             self.getBlankTextArray()
             viewProfile.isHidden = false
             viewSignUp.isHidden = true
             isDataSave = true
             self.callUpdateApi() // call profile details API
        }else{
            viewProfile.isHidden = true
            viewSignUp.isHidden = false
            if let saveArray:[String] = UserDefaults.standard.value(forKey: USER_DEFAULT_SIGN_UP_PAGE_ONE) as? [String]{
             arrContainer.removeAll()
             arrContainer = saveArray
            isDataSave = true
            }else{
              self.getBlankTextArray()
              isDataSave = false
            }
            // user for signUp
         
        }
       print("array ontain ",arrContainer)
        self.registrationTable.reloadData()
    }
    
    
    fileprivate enum PLACE_HOLDER :Int{
        case CELL_CONTENT_FIRST_NAME = 0
        case CELL_CONTENT_MIDDLE_NAME
        case CELL_CONTENT_LAST_NAME
        case CELL_CONTENT_DOB
        case CELL_CONTENT_EMAIL_ID
        case CELL_CONTENT_MOBILE_NUMBER
        case CELL_CONTENT_LANDLINE_NO
        case CELL_CONTENT_ABN
        case CELL_CONTENT_TOTAL // to denote last elments
       
        func getPlaceHolderText() -> String {
            switch self {
            case .CELL_CONTENT_FIRST_NAME:
                return "First Name"
            case .CELL_CONTENT_MIDDLE_NAME:
                return "Middle Name"
            case .CELL_CONTENT_LAST_NAME:
                return "Last Name"
            case .CELL_CONTENT_DOB:
                return "DOB"
            case .CELL_CONTENT_EMAIL_ID:
                return "Email ID"
            case .CELL_CONTENT_MOBILE_NUMBER:
                return "Mobile No"
            case .CELL_CONTENT_LANDLINE_NO:
                return "Land line No."
            case .CELL_CONTENT_ABN:
                return "ABN"
            default:
                return ""
            }
            
        }
    }
    
    
    func addValidation(myIndex: Int, cell : SignUpCell) {
        let myType = PLACE_HOLDER.init(rawValue: myIndex)
        switch myType {
        case .CELL_CONTENT_FIRST_NAME? , .CELL_CONTENT_MIDDLE_NAME? , .CELL_CONTENT_LAST_NAME?, .CELL_CONTENT_ABN?:
            cell.textFieldCell.keyboardType = .asciiCapable
            
        case .CELL_CONTENT_MOBILE_NUMBER?, .CELL_CONTENT_LANDLINE_NO?:
            cell.textFieldCell.keyboardType = .phonePad
            
        case .CELL_CONTENT_EMAIL_ID?:
            cell.textFieldCell.keyboardType = .emailAddress

        default:
            break
            
        }
    }

    func getBlankTextArray() {
        arrContainer.removeAll()
        for _ in 0..<PLACE_HOLDER.CELL_CONTENT_TOTAL.rawValue {
            arrContainer.append("")
        }
        print(arrContainer.count)
    }
    
    @objc func navigateToNextPage() {
        if validation() {
             self.addInformationToDictionary()
        }
       
    }
    
    override func donedatePicker(barButton:UIBarButtonItem){
        let indexPath = IndexPath(row: barButton.tag, section: 0)
        let cell = self.registrationTable.cellForRow(at: indexPath) as? SignUpCell
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        cell?.textFieldCell.text = formatter.string(from: datePicker.date)
        if let str =  cell?.textFieldCell.text, str.count > 0 {
            self.arrContainer.remove(at: barButton.tag)
            self.arrContainer.insert(str, at: barButton.tag)
        }else{
            self.arrContainer.remove(at: barButton.tag)
            self.arrContainer.insert("", at: barButton.tag)
        }
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func buttonClickBack(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    
}
//Mark: - TableView Extention
extension SignUpPageOneViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrContainer.count + 1)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("array ontain ",arrContainer)
        if indexPath.row <  arrContainer.count  {
            let type = PLACE_HOLDER.init(rawValue: indexPath.row)
            let cell: SignUpCell = self.registrationTable.dequeueReusableCell(withIdentifier: "fromCell") as! SignUpCell
            cell.textFieldCell.placeholder = type?.getPlaceHolderText()
            self.addValidation(myIndex: indexPath.row, cell: cell)
            cell.textFieldCell.tag = indexPath.row
            if isDataSave ?? false {
               cell.populateData(value: arrContainer[indexPath.row])
            }
            cell.textFieldCell.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
            if type == PLACE_HOLDER.CELL_CONTENT_DOB {
                self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
                addDatePickerToTextfield(textFild: cell.textFieldCell)
               
            }
            return cell
        }else{
            let cell: SignUpCell = self.registrationTable.dequeueReusableCell(withIdentifier: "buttonCell") as! SignUpCell
            cell.buttonNext.addTarget(self, action: #selector(self.navigateToNextPage), for: .touchUpInside)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 85 :  65
        
    }
  
}

extension SignUpPageOneViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      if   PLACE_HOLDER.CELL_CONTENT_ABN.rawValue == textField.tag {
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }else{
            return true
        }
    }
}
extension SignUpPageOneViewController {
    func callUpdateApi()  {
        let userID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID) ?? ""
        let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) ?? ""
        self.showLoading()
        model.getProfileDetails(userID:userID, token: token) { (status, message) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
            if status == 0{
                if self.model.regModel?.basic_info != nil {
                    self.isDataSave = true
                    self.arrContainer[PLACE_HOLDER.CELL_CONTENT_FIRST_NAME.rawValue] =  self.model.regModel?.basic_info?.first_name ?? ""
                    self.arrContainer[PLACE_HOLDER.CELL_CONTENT_MIDDLE_NAME.rawValue] = self.model.regModel?.basic_info?.middle_name ?? ""
                    self.arrContainer[PLACE_HOLDER.CELL_CONTENT_LAST_NAME.rawValue] = self.model.regModel?.basic_info?.last_name ?? ""
                    self.arrContainer[PLACE_HOLDER.CELL_CONTENT_DOB.rawValue] = self.model.regModel?.basic_info?.dob ?? ""
                    self.arrContainer[PLACE_HOLDER.CELL_CONTENT_EMAIL_ID.rawValue] = self.model.regModel?.basic_info?.email ?? ""
                    self.arrContainer[PLACE_HOLDER.CELL_CONTENT_MOBILE_NUMBER.rawValue] = self.model.regModel?.basic_info?.mobile ?? ""
                    self.arrContainer[PLACE_HOLDER.CELL_CONTENT_LANDLINE_NO.rawValue] = self.model.regModel?.basic_info?.landline_no ?? ""
                    self.arrContainer[PLACE_HOLDER.CELL_CONTENT_ABN.rawValue] = self.model.regModel?.basic_info?.abn ?? ""
                }
                DispatchQueue.main.async {
                    self.registrationTable.reloadData()
                }
            }else if status == 2{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                self.forceLogout()
            }else{
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                 UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
            
        }
    }
    
    
    @objc fileprivate func textFieldValueChanged(_ txt:UITextField) {
        guard let cell:SignUpCell = txt.superview?.superviewOfClassType(SignUpCell.self) as? SignUpCell  else {
            return
        }
        
        guard let indexPath = registrationTable.indexPath(for: cell) else {
            return
        }
        if let str = txt.text, str.count > 0 {
            self.arrContainer.remove(at: indexPath.row)
             self.arrContainer.insert(str, at: indexPath.row)
        }else{
            self.arrContainer.remove(at: indexPath.row)
            self.arrContainer.insert("", at: indexPath.row)
        }
         print(String.init(describing: self.arrContainer))
       
    }
    
    func validation() -> Bool {
        if arrContainer[PLACE_HOLDER.CELL_CONTENT_FIRST_NAME.rawValue] == "" {
            //self.registrationTable.shake()
            UtilityClass.tosta(message: ALERT_MESSAGE_FIRST_BLANK, duration: 1.0, vc: self)
            return false
        }
        if arrContainer[PLACE_HOLDER.CELL_CONTENT_LAST_NAME.rawValue] == "" {
             UtilityClass.tosta(message: ALERT_MESSAGE_LAST_BLANK, duration: 1.0, vc: self)
             return false
        }
        if !arrContainer[PLACE_HOLDER.CELL_CONTENT_EMAIL_ID.rawValue].isValideEmail  {
            UtilityClass.tosta(message: ALERT_MESSAGE_EMAIL_INVALID, duration: 1.0, vc: self)
            return false
        }
        if !arrContainer[PLACE_HOLDER.CELL_CONTENT_MOBILE_NUMBER.rawValue].isValidTenDigitMobileNumber  {
            UtilityClass.tosta(message: ALERT_PHONE_NUMBER, duration: 1.0, vc: self)
            return false
        }
        if arrContainer[PLACE_HOLDER.CELL_CONTENT_ABN.rawValue].count != 11 {
            UtilityClass.tosta(message: ALERT_MESSAGE_ABN_INVALID, duration: 1.0, vc: self)
            return false
        }
       
        
         return true
    }
    
    
    func addInformationToDictionary() {
        
        signUpStringInfo?.removeAll()
        signUpStringInfo?["first_name"] = arrContainer[PLACE_HOLDER.CELL_CONTENT_FIRST_NAME.rawValue]
        signUpStringInfo?["middle_name"] = arrContainer[PLACE_HOLDER.CELL_CONTENT_MIDDLE_NAME.rawValue]
        signUpStringInfo?["last_name"] = arrContainer[PLACE_HOLDER.CELL_CONTENT_LAST_NAME.rawValue]
        signUpStringInfo?["dob"] = arrContainer[PLACE_HOLDER.CELL_CONTENT_DOB.rawValue]
        signUpStringInfo?["email"] = arrContainer[PLACE_HOLDER.CELL_CONTENT_EMAIL_ID.rawValue]
        signUpStringInfo?["mobile"] = arrContainer[PLACE_HOLDER.CELL_CONTENT_MOBILE_NUMBER.rawValue]
        signUpStringInfo?["landline_no"] = arrContainer[PLACE_HOLDER.CELL_CONTENT_LANDLINE_NO.rawValue]
        signUpStringInfo?["abn"] = arrContainer[PLACE_HOLDER.CELL_CONTENT_ABN.rawValue]
        if !isUseAsProfile! {
            UserDefaults.standard.set(arrContainer, forKey: USER_DEFAULT_SIGN_UP_PAGE_ONE)
            UserDefaults.standard.synchronize()
        }
      
        let vc:AddressInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddressInfoViewController") as! AddressInfoViewController
        vc.isUseAsProfile = isUseAsProfile!
        if isUseAsProfile! {
            vc.modelAddress = self.model
        }
        vc.signUpStringInfo = signUpStringInfo ?? [:]
        print(signUpStringInfo ?? [:])
        self.navigationController?.pushViewController(vc, animated: true)

    }
}



