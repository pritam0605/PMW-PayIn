//
//  PersonalInfoViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class PersonalInfoViewController: BaseViewController {
    var isUseAsProfile:Bool?
    var signUpStringInfo = Dictionary<String, String>()
    @IBOutlet weak var personalTable:UITableView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewSignUp: UIView!
    var arrPersonalContainer = [String]()
    var arrBankInfo = [String]()
    var pickerView = UIPickerView()
    var isDataSave:Bool?
    var modelPresonal = SignUpModel()
    let arrDriverType = ["Sedan","Maxi"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        if (isUseAsProfile!){
            viewProfile.isHidden = false
            viewSignUp.isHidden = true
            isDataSave = true
            self.getBlankTextArray()
            self.bankPlaceHolderArray()
            self.populatePersonalDetails()
        }else{
            viewProfile.isHidden = true
            viewSignUp.isHidden = false
            if let saveArray:[String] = UserDefaults.standard.value(forKey: USER_DEFAULT_SIGN_UP_PERSONAL_INFO) as? [String]{
                arrPersonalContainer.removeAll()
                arrPersonalContainer = saveArray
                isDataSave = true
            }else{
                self.getBlankTextArray()
                self.bankPlaceHolderArray()
                isDataSave = false
            }
            
            if let saveArray1:[String] = UserDefaults.standard.value(forKey: USER_DEFAULT_SIGN_UP_BANK_INFO) as? [String]{
                arrBankInfo.removeAll()
                arrBankInfo = saveArray1
                isDataSave = true
            }else{
                self.getBlankTextArray()
                isDataSave = false
            }
        }
        self.personalTable.rowHeight = UITableView.automaticDimension
        self.personalTable.estimatedRowHeight = 44.0
        self.personalTable.reloadData()
        print("PersonalInfoViewController",signUpStringInfo)
    }
    
    
    fileprivate enum PERSONAL_PLACE_HOLDER :Int{
        case CELL_CONTENT_DRIE_TYPES = 0
        case CELL_CONTENT_DC_NUMBER
        case CELL_CONTENT_DRIVER_LICENSE_NUMBER
        case CELL_CONTENT_DRIVER_LICENSE_EXP_DATE
        case CELL_CONTENT_DC_EXP_DATE
        case CELL_CONTENT_TOTAL // to denote last elments
        
        func getPlaceHolderText() -> String {
            switch self {
            case .CELL_CONTENT_DRIE_TYPES:
                return "Driver's Type"
            case .CELL_CONTENT_DC_NUMBER:
                return "DC Number"
            case .CELL_CONTENT_DRIVER_LICENSE_NUMBER:
                return "Driver's license number"
            case .CELL_CONTENT_DRIVER_LICENSE_EXP_DATE:
                return "Driver's license Exp. Date"
            
            case .CELL_CONTENT_DC_EXP_DATE:
                return "DC Exp. Date"
                
            default:
                return ""
            }
            
        }
    }
    
    
    
    fileprivate enum BANK_INFO_PLACE_HOLDER :Int{
        case CELL_CONTENT_BAN = 0
        case CELL_CONTENT_BSB
        case CELL_CONTENT_ACCOUNT_NUMBER

        case CELL_CONTENT_TOTAL // to denote last elments
        
        func getPlaceHolderText() -> String {
            switch self {
            case .CELL_CONTENT_BAN:
                return "Bank Name"
            case .CELL_CONTENT_BSB:
                return "BSB"
            case .CELL_CONTENT_ACCOUNT_NUMBER:
                return "Account No."
            
                
            default:
                return ""
            }
            
        }
    }
    
    
    
    func addValidationBankField(myIndex: Int, cell : SignUpCell) {
        let myType = BANK_INFO_PLACE_HOLDER.init(rawValue: myIndex)
        switch myType {
        case .CELL_CONTENT_ACCOUNT_NUMBER?:
            cell.textFieldCell.keyboardType = .phonePad
        default:
            break
        }
    }
    
    
    override func donedatePicker(barButton:UIBarButtonItem){
        let indexPath = IndexPath(row: barButton.tag, section: 0)
        let cell = self.personalTable.cellForRow(at: indexPath) as? SignUpCell
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        cell?.textFieldCell.text = formatter.string(from: datePicker.date)
        if let str =  cell?.textFieldCell.text, str.count > 0 {
            self.arrPersonalContainer.remove(at: barButton.tag)
            self.arrPersonalContainer.insert(str, at: barButton.tag)
        }else{
            self.arrPersonalContainer.remove(at: barButton.tag)
            self.arrPersonalContainer.insert("", at: barButton.tag)
        }
        self.view.endEditing(true)
        
    }
    
    fileprivate func pickerUp(_ text: UITextField){
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        text.inputView = self.pickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PersonalInfoViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PersonalInfoViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        text.inputAccessoryView = toolBar
     
        
    }
    
    @objc func doneClick() {
        let index = IndexPath(row: 0, section: 0)
        guard let cell = self.personalTable.cellForRow(at: index) as? SignUpCell else {
            return
        }
        let indexPic = (pickerView.tag-1) < 0 ? 0 : (pickerView.tag-1)
        let indexKeys = (pickerView.tag) < 1 ? 1 : (pickerView.tag)
        cell.textFieldCell.text = arrDriverType[indexPic]//datePicker.tag
        let kayValue = String(indexKeys)
        if let str =  cell.textFieldCell.text, str.count > 0 {
            self.arrPersonalContainer.remove(at: 0)
            self.arrPersonalContainer.insert( kayValue, at: 0)
        }else{
            self.arrPersonalContainer.remove(at: 0)
            self.arrPersonalContainer.insert("", at: 0)
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelClick() {
      self.view.endEditing(true)
    }
  
    
    
    func getBlankTextArray() {
        arrPersonalContainer.removeAll()
        for _ in 0..<PERSONAL_PLACE_HOLDER.CELL_CONTENT_TOTAL.rawValue {
            arrPersonalContainer.append("")
        }
        print(arrPersonalContainer.count)
    }
    
    func bankPlaceHolderArray() {
        arrBankInfo.removeAll()
        for _ in 0..<BANK_INFO_PLACE_HOLDER.CELL_CONTENT_TOTAL.rawValue {
            arrBankInfo.append("")
        }
        print(arrBankInfo.count)
    }
    
    @IBAction func buttonClickBack(_ sender: UIButton) {
        self.navigateToPreviousPage()
    }
    
    @objc func navigateToNextPage() {
       self.addInformationToDictionary()
    }

    @objc func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AddressInfoViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}
//Mark: - TableView Extention
extension PersonalInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arrBankInfo.count)
        print(arrBankInfo)
        return section == 0 ? arrPersonalContainer.count:(section == 1 ? arrBankInfo.count : 1 )
 
    }
   

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var arr = [String]()
//        arr = indexPath.section == 0 ? arrPersonalContainer:(indexPath.section == 2 ? arrBankInfo : [] )
        if  indexPath.section == 0 {
            let type = PERSONAL_PLACE_HOLDER.init(rawValue: indexPath.row)
            let cell: SignUpCell = self.personalTable.dequeueReusableCell(withIdentifier: "fromCell") as! SignUpCell
            cell.textFieldCell.placeholder = type?.getPlaceHolderText()
            cell.dropDownImage.isHidden = indexPath.row == 0 ? false : true
            if type == .CELL_CONTENT_DRIE_TYPES {
                self.pickerUp(cell.textFieldCell)
            }
            
            if type != .CELL_CONTENT_DRIE_TYPES  {
                 cell.textFieldCell.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
            }
            cell.textFieldCell.tag = indexPath.row
            if type == .CELL_CONTENT_DRIVER_LICENSE_EXP_DATE || type == .CELL_CONTENT_DC_EXP_DATE {
                addDatePickerToTextfield(textFild: cell.textFieldCell)

            }
            if isDataSave ?? false {
                cell.populateData(value: arrPersonalContainer[indexPath.row])
                if type == .CELL_CONTENT_DRIE_TYPES{
                    cell.textFieldCell.text = (arrPersonalContainer[indexPath.row])  == "1" ? "Sedan" : "Maxi"
                }
            }
             cell.textFieldCell.isUserInteractionEnabled = true
            if isUseAsProfile!{
                if type == .CELL_CONTENT_DRIE_TYPES || type == .CELL_CONTENT_DC_NUMBER || type == .CELL_CONTENT_DRIVER_LICENSE_NUMBER {
                    cell.textFieldCell.isUserInteractionEnabled = false
                }
            }
            return cell
        }else if indexPath.section == 1 {
            let type = BANK_INFO_PLACE_HOLDER.init(rawValue: indexPath.row)
            let cell: SignUpCell = self.personalTable.dequeueReusableCell(withIdentifier: "fromCellWhite") as! SignUpCell
            cell.textFieldCell.placeholder = type?.getPlaceHolderText()
            cell.textFieldCell.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
            addValidationBankField(myIndex: indexPath.row, cell: cell)
            if isDataSave ?? false {
                cell.populateData(value: arrBankInfo[indexPath.row])
            }
            return cell
            
        }else {
            let cell = self.personalTable.dequeueReusableCell(withIdentifier: "buttonCell") as! SignUpCell
            cell.buttonNext.addTarget(self, action: #selector(self.navigateToNextPage), for: .touchUpInside)
            cell.buttonPrevious.addTarget(self, action: #selector(self.navigateToPreviousPage), for: .touchUpInside)
            return cell
            
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: self.personalTable.bounds.size.width, height: 50)) //set these
            returnedView.backgroundColor = UIColor.clear
            let label = UILabel(frame: CGRect(x: 0, y: 20, width: self.personalTable.bounds.size.width, height: 25))
            label.textColor = UIColor(red: 250.0/255.0, green: 186.0/255.0, blue: 62.0/255.0, alpha: 1.0)
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            label.text = "Driver Bank Details:"
            returnedView.addSubview(label)
            
            return returnedView
        }else{
            let ui = UIView ()
            return ui
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          if section == 1 {
            return  UIDevice.current.userInterfaceIdiom == .pad ? 65.0 :  50.0
          }else{
            return 2.0
        }
        
    }
    
}
extension PersonalInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PersonalInfoViewController{
    
    @objc fileprivate func textFieldValueChanged(_ txt:UITextField) {
        guard let cell:SignUpCell = txt.superview?.superviewOfClassType(SignUpCell.self) as? SignUpCell  else {
            return
        }
        
        guard let indexPath = personalTable.indexPath(for: cell) else {
            return
        }
        if indexPath.section == 0 {
            if let str = txt.text, str.count > 0 {
                self.arrPersonalContainer.remove(at: indexPath.row)
                self.arrPersonalContainer.insert(str, at: indexPath.row)
            }else{
                self.arrPersonalContainer.remove(at: indexPath.row)
                self.arrPersonalContainer.insert("", at: indexPath.row)
            }
            print(String.init(describing: self.arrPersonalContainer))
        }else if indexPath.section == 1 {
            if let str = txt.text, str.count > 0 {
                self.arrBankInfo.remove(at: indexPath.row)
                self.arrBankInfo.insert(str, at: indexPath.row)
            }else{
                self.arrBankInfo.remove(at: indexPath.row)
                self.arrBankInfo.insert("", at: indexPath.row)
            }
        }
       
        
    }
    func populatePersonalDetails()  {
         arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DRIE_TYPES.rawValue] = self.modelPresonal.regModel?.personal_info?.dr_driver_type ?? ""
        arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DC_NUMBER.rawValue] = self.modelPresonal.regModel?.personal_info?.dc_no  ?? ""
         arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DRIVER_LICENSE_NUMBER.rawValue] = self.modelPresonal.regModel?.personal_info?.dr_licence_no ?? ""
         arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DRIVER_LICENSE_EXP_DATE.rawValue] = self.modelPresonal.regModel?.personal_info?.dr_licence_expiry  ?? ""
        
         arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DC_EXP_DATE.rawValue] = self.modelPresonal.regModel?.personal_info?.dr_dc_expiry  ?? ""
         arrBankInfo[BANK_INFO_PLACE_HOLDER.CELL_CONTENT_BAN.rawValue] = self.modelPresonal.regModel?.bank_info?.bank_name  ?? ""
         arrBankInfo[BANK_INFO_PLACE_HOLDER.CELL_CONTENT_BSB.rawValue] = self.modelPresonal.regModel?.bank_info?.bsb  ?? ""
         arrBankInfo[BANK_INFO_PLACE_HOLDER.CELL_CONTENT_ACCOUNT_NUMBER.rawValue] = self.modelPresonal.regModel?.bank_info?.account_no  ?? ""
         self.personalTable.reloadData()
        
    }
    
    
    func addInformationToDictionary(){
        
        guard arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DRIE_TYPES.rawValue] != "" else {
            UtilityClass.tosta(message: ALERT_SELECT_DRIVER_TYPE, duration: 1.0, vc: self)
            return
        }
        guard arrBankInfo[BANK_INFO_PLACE_HOLDER.CELL_CONTENT_BSB.rawValue].count == 6 else {
            UtilityClass.tosta(message: ALERT_MESSAGE_BSB_INVALID, duration: 1.0, vc: self)
            return
        }
        
        
        signUpStringInfo["dr_driver_type"] = arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DRIE_TYPES.rawValue]
        signUpStringInfo["dc_no"] = arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DC_NUMBER.rawValue]
        signUpStringInfo["dr_licence_no"] = arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DRIVER_LICENSE_NUMBER.rawValue]
        signUpStringInfo["dr_licence_expiry"] = arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DRIVER_LICENSE_EXP_DATE.rawValue]
        
        signUpStringInfo["dr_dc_expiry"] = arrPersonalContainer[PERSONAL_PLACE_HOLDER.CELL_CONTENT_DC_EXP_DATE.rawValue]
        signUpStringInfo["bank_name"] = arrBankInfo[BANK_INFO_PLACE_HOLDER.CELL_CONTENT_BAN.rawValue]
        signUpStringInfo["bsb"] = arrBankInfo[BANK_INFO_PLACE_HOLDER.CELL_CONTENT_BSB.rawValue]
        signUpStringInfo["account_no"] = arrBankInfo[BANK_INFO_PLACE_HOLDER.CELL_CONTENT_ACCOUNT_NUMBER.rawValue]
        
        if !isUseAsProfile! {
            UserDefaults.standard.set(arrPersonalContainer, forKey: USER_DEFAULT_SIGN_UP_PERSONAL_INFO)
            UserDefaults.standard.set(arrBankInfo, forKey: USER_DEFAULT_SIGN_UP_BANK_INFO)
            UserDefaults.standard.synchronize()
        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DriverDocumentationViewController") as! DriverDocumentationViewController
        
        vc.isUseAsProfile = isUseAsProfile!
        if isUseAsProfile! {
         vc.profileImage = modelPresonal.regModel?.personal_info?.profile_photo ?? ""
         vc.modelDocuments = self.modelPresonal
        }
        vc.signUpStringInfo = signUpStringInfo
        self.navigationController?.pushViewController(vc, animated: true)

    }
}

extension PersonalInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrDriverType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrDriverType[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerView.tag = (row+1)
        
    }
    
    
}

