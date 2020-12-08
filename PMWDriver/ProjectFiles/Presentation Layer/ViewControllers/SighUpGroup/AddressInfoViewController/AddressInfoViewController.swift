//
//  AddressInfoViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class AddressInfoViewController: BaseViewController {
    var isUseAsProfile:Bool?
    var signUpStringInfo = Dictionary<String, String>()
    @IBOutlet weak var addressTable:UITableView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewSignUp: UIView!
    var arrAddressContainer = [String]()
    let stateList = ["Victoria", "New South Wales", "Queensland", "Tasmania" ,"South Australia","Western Australia"]
    var modelAddress = SignUpModel()
    var isDataSave: Bool?
    var pickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
         pickerView.delegate = self
        if (isUseAsProfile!){
            viewProfile.isHidden = false
            viewSignUp.isHidden = true
            isDataSave = true
            self.getBlankTextArray()
            self.populateAddressDetails()
        }else{
            viewProfile.isHidden = true
            viewSignUp.isHidden = false
            if let saveArray:[String] = UserDefaults.standard.value(forKey: USER_DEFAULT_SIGN_UP_ADDRESS) as? [String]{
                arrAddressContainer.removeAll()
                arrAddressContainer = saveArray
                isDataSave = true
            }else{
                self.getBlankTextArray()
                isDataSave = false
            }
        }
        
        self.addressTable.rowHeight = UITableView.automaticDimension
        self.addressTable.estimatedRowHeight = 44.0
        self.addressTable.reloadData()
        print("AddressInfoViewController",signUpStringInfo)
    }
    
    
    fileprivate enum ADDRESS_PLACE_HOLDER :Int{
        case CELL_CONTENT_FLATE_NO = 0
        case CELL_CONTENT_STREET_NO
        case CELL_CONTENT_STREET_NAME
        case CELL_CONTENT_SUBURB
        case CELL_CONTENT_STATE
        case CELL_CONTENT_POSTAL_CODE
        case CELL_CONTENT_TOTAL // to denote last elments
        
        func getPlaceHolderText() -> String {
            switch self {
            case .CELL_CONTENT_FLATE_NO:
                return "Unit No/Flate No"
            case .CELL_CONTENT_STREET_NO:
                return "Street No"
            case .CELL_CONTENT_STREET_NAME:
                return "Street Name"
            case .CELL_CONTENT_SUBURB:
                return "Suburb"
            case .CELL_CONTENT_STATE:
                return "State"
            case .CELL_CONTENT_POSTAL_CODE:
                return "Post Code"
            
            default:
                return ""
            }
            
        }
    }
    
    func addValidation(myIndex: Int, cell : SignUpCell) {
        let myType = ADDRESS_PLACE_HOLDER.init(rawValue: myIndex)
        switch myType {
        case .CELL_CONTENT_FLATE_NO? , .CELL_CONTENT_STREET_NAME? , .CELL_CONTENT_SUBURB?, .CELL_CONTENT_STATE?:
            cell.textFieldCell.keyboardType = .asciiCapable
            
        case .CELL_CONTENT_POSTAL_CODE?:
            cell.textFieldCell.keyboardType = .phonePad
        default:
            break
            
        }
        
        
    }
    
    
    func getBlankTextArray() {
        arrAddressContainer.removeAll()
        for i in 0..<ADDRESS_PLACE_HOLDER.CELL_CONTENT_TOTAL.rawValue {
            if i == ADDRESS_PLACE_HOLDER.CELL_CONTENT_STATE.rawValue{
               arrAddressContainer.append("Victoria")
            }else{
            arrAddressContainer.append("")
            }
        }
        print(arrAddressContainer.count)
    }
    
    @IBAction func buttonClickBack(_ sender: UIButton) {
        self.navigateToPreviousPage()
    }
    
    @objc func navigateToNextPage() {
        self.addInformationToDictionary()
    }
    @objc func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: SignUpPageOneViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}
//Mark: - TableView Extention
extension AddressInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrAddressContainer.count + 1)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <  arrAddressContainer.count  {
            let type = ADDRESS_PLACE_HOLDER.init(rawValue: indexPath.row)
            let cell: SignUpCell = self.addressTable.dequeueReusableCell(withIdentifier: "fromCell") as! SignUpCell
            cell.textFieldCell.placeholder = type?.getPlaceHolderText()
            addValidation(myIndex: indexPath.row, cell: cell)
            cell.textFieldCell.tag = indexPath.row
            if isDataSave ?? false {
                cell.populateData(value: arrAddressContainer[indexPath.row])
            }
            if type == .CELL_CONTENT_STATE {
                if cell.textFieldCell.text == "" {
                   cell.textFieldCell.text = "Victoria" //default value
                }
                self.pickerUp(cell.textFieldCell)
            }
            
            
            cell.textFieldCell.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
            return cell
        }else{
            let cell: SignUpCell = self.addressTable.dequeueReusableCell(withIdentifier: "buttonCell") as! SignUpCell
            cell.buttonNext.addTarget(self, action: #selector(self.navigateToNextPage), for: .touchUpInside)
             cell.buttonPrevious.addTarget(self, action: #selector(self.navigateToPreviousPage), for: .touchUpInside)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    
    //Mark: - picker
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
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddressInfoViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddressInfoViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        text.inputAccessoryView = toolBar
        
        
    }
    
    @objc func doneClick(){
        let index = IndexPath(row: 4, section: 0)
        guard let cell = self.addressTable.cellForRow(at: index) as? SignUpCell else {
            return
        }
        let indexPic = (pickerView.tag-1) < 0 ? 0 : (pickerView.tag-1)
        cell.textFieldCell.text = stateList[indexPic]
        if let str =  cell.textFieldCell.text, str.count > 0 {
            self.arrAddressContainer.remove(at: index.row)
            self.arrAddressContainer.insert( stateList[indexPic], at: index.row)
        }else{
            self.arrAddressContainer.remove(at: index.row)
            self.arrAddressContainer.insert("", at: index.row)
        }
        self.view.endEditing(true)
    }

    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    
    
    
}

extension AddressInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddressInfoViewController {
    @objc fileprivate func textFieldValueChanged(_ txt:UITextField) {
        guard let cell:SignUpCell = txt.superview?.superviewOfClassType(SignUpCell.self) as? SignUpCell  else {
            return
        }
        
        guard let indexPath = addressTable.indexPath(for: cell) else {
            return
        }
        if let str = txt.text, str.count > 0 {
            self.arrAddressContainer.remove(at: indexPath.row)
            self.arrAddressContainer.insert(str, at: indexPath.row)
        }else{
            self.arrAddressContainer.remove(at: indexPath.row)
            self.arrAddressContainer.insert("", at: indexPath.row)
        }
        print(String.init(describing: self.arrAddressContainer))
        
    }
    func populateAddressDetails()  {
            isDataSave = true
            self.arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_FLATE_NO.rawValue] =  self.modelAddress.regModel?.address_info?.flat_no ?? ""
            self.arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_STREET_NO.rawValue] = self.modelAddress.regModel?.address_info?.street_no ?? ""
            self.arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_STREET_NAME.rawValue] = self.modelAddress.regModel?.address_info?.street_name ?? ""
            self.arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_SUBURB.rawValue] = self.modelAddress.regModel?.address_info?.suburb ?? ""
            self.arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_STATE.rawValue] = self.modelAddress.regModel?.address_info?.state ?? ""
            self.arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_POSTAL_CODE.rawValue] = self.modelAddress.regModel?.address_info?.pin ?? ""
        
            self.addressTable.reloadData()
    }
    
    func addInformationToDictionary() {
        guard arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_POSTAL_CODE.rawValue].count == 4 else {
            UtilityClass.tosta(message: ALERT_MESSAGE_PIN_INVALID, duration: 1.0, vc: self)
            return
        }
        signUpStringInfo["flat_no"] = arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_FLATE_NO.rawValue]
        signUpStringInfo["street_no"] = arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_STREET_NO.rawValue]
        signUpStringInfo["street_name"] = arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_STREET_NAME.rawValue]
        signUpStringInfo["suburb"] = arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_SUBURB.rawValue]
        signUpStringInfo["state"] = arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_STATE.rawValue]
        signUpStringInfo["pin"] = arrAddressContainer[ADDRESS_PLACE_HOLDER.CELL_CONTENT_POSTAL_CODE.rawValue]
        
        if !isUseAsProfile! {
            UserDefaults.standard.set(arrAddressContainer, forKey: USER_DEFAULT_SIGN_UP_ADDRESS)
            UserDefaults.standard.synchronize()
        }
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInfoViewController") as! PersonalInfoViewController
        vc.isUseAsProfile = isUseAsProfile!
        if isUseAsProfile! {
            vc.modelPresonal = self.modelAddress
        }
        vc.signUpStringInfo = signUpStringInfo
        print(signUpStringInfo)
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
extension AddressInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateList[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerView.tag = (row+1)
        
    }
    
    
}
