//
//  CarDetailsInfoViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CarDetailsInfoViewController: BaseViewController {

    @IBOutlet weak var accidentTable:UITableView!
    @IBOutlet weak var textNumberOfCars: SkyFloatingLabelTextField!
    var carDetailsInfoArray = [Dictionary<String, String>]()
    
    var carDetailsInfo = Dictionary<String, String>()
//new var
    var isDataIsSaved = false
    var arrISSelectedInsured = [true]
    var arrISSelectedOwnerDriver = [false]
    let arrPicker = ["2","3","4","5","6","7","8","9"]
    var arrContainerTotal = [[String]]()
    var arrContainerSection = [String]()
    var arrBankInfo = [String]()
    var numberOfSection = 2
    var pickerView = UIPickerView()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(self.checkDataIsSaveOrNot()) {
        self.getBlankTextArray()
        }
        self.accidentTable.rowHeight = UITableView.automaticDimension
        self.accidentTable.estimatedRowHeight = 44.0
        self.accidentTable.reloadData()
        pickerView.delegate = self
        pickerUp()

    }
    
    func checkDataIsSaveOrNot() -> Bool  {
     var carDetailsInfo = [[String]]()
        if let  mySaveData = UserDefaults.standard.object(forKey: USER_DEFAULT_SAVE_CAR_INFO){
            carDetailsInfo = mySaveData as! [[String]]
            if carDetailsInfo.count > 0 {
                isDataIsSaved = true
                self.numberOfSection = UserDefaults.standard.object(forKey: USER_DEFAULT_CAR_NUMBER) as? Int ?? carDetailsInfo.count + 1
                textNumberOfCars.text = String(self.numberOfSection)
                self.arrContainerTotal.removeAll()
                self.arrContainerTotal = carDetailsInfo
                if let  mySaveInsurenceStatus = UserDefaults.standard.object(forKey: USER_DEFAULT_SAVE_INSURENCE) {
                     self.arrISSelectedInsured.removeAll()
                    self.arrISSelectedInsured = mySaveInsurenceStatus as! [Bool]
                }
                
                if let  myOwner_DriverTatus = UserDefaults.standard.object(forKey: USER_DEFAULT_SAVE_OWNER_DRIVER) {
                    self.arrISSelectedOwnerDriver.removeAll()
                    self.arrISSelectedOwnerDriver = myOwner_DriverTatus as! [Bool]
                }
                for _ in 0 ..< (self.arrContainerTotal.count - (self.numberOfSection-1)) {
                    self.arrContainerTotal.removeLast()
                    self.arrISSelectedOwnerDriver.removeLast()
                    self.arrISSelectedInsured.removeLast()
                }
                
                self.accidentTable.reloadData()
                return true
            }
            return false
        }
         return false
    }
    
   fileprivate func pickerUp(){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        textNumberOfCars.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.backgroundColor  = THEME_ORANGE_COLOR
        toolBar.tintColor = THEME_GREEN_COLOR
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CarDetailsInfoViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CarDetailsInfoViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textNumberOfCars.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        textNumberOfCars.resignFirstResponder()
            if  (numberOfSection - 1) - self.arrContainerTotal.count > 0 {
                let count = (numberOfSection - 1) - self.arrContainerTotal.count
                for _ in 0 ..< count {
                     self.getBlankTextArray()
                }
            }
            self.accidentTable.reloadData()
    }
    @objc func cancelClick() {
        textNumberOfCars.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  textField == textNumberOfCars{
        self.pickerUp()
        }
    }
    

    fileprivate enum ACCIDENT_PLACE_HOLDER :Int{
        case CELL_CONTENT_MAKE = 0
        case CELL_CONTENT_REGO
        case CELL_CONTENT_INSURED
        case CELL_CONTENT_INSURED_COMPANY
        case CELL_CONTENT_OWNER
        case CELL_CONTENT_OWNER_NAME
        case CELL_CONTENT_OWNER_ADDESS
        case CELL_CONTENT_OWNER_MOBILE
        case CELL_CONTENT_OWNER_EMAIL
        case CELL_CONTENT_DRIVER_NAME
        case CELL_CONTENT_DRIVER_ADDRESS
        case CELL_CONTENT_DRIVER_MOBILE
        case CELL_CONTENT_DRIVER_EMAIL
        
        case CELL_CONTENT_TOTAL // to denote last elments
        
        func getPlaceHolderText() -> String {
            switch self {
            case .CELL_CONTENT_MAKE:
                return "Make"
            case .CELL_CONTENT_REGO:
                return "Rego"
            case .CELL_CONTENT_INSURED:
                return ""
            case .CELL_CONTENT_INSURED_COMPANY:
                return "Name of Insurance Company"
            case .CELL_CONTENT_OWNER:
                return ""
            case .CELL_CONTENT_OWNER_NAME:
                return "Owner Name"
            case .CELL_CONTENT_OWNER_ADDESS:
                return "Owner's Address"
            case .CELL_CONTENT_OWNER_MOBILE:
                return "Mobile/Landline"
            case .CELL_CONTENT_OWNER_EMAIL:
                return "Email"
            case .CELL_CONTENT_DRIVER_NAME:
                return "Driver Name"
            case .CELL_CONTENT_DRIVER_ADDRESS:
                return "Driver's Address"
            case .CELL_CONTENT_DRIVER_MOBILE:
                return "Mobile"
            case .CELL_CONTENT_DRIVER_EMAIL:
                return "Email"
            default:
                return ""
            }
            
        }
    }
    

    func getBlankTextArray() {
        arrContainerSection.removeAll()
        
        for _ in  self.arrContainerTotal.count ..< numberOfSection-1 {
            arrContainerSection.removeAll()
            for _ in 0..<ACCIDENT_PLACE_HOLDER.CELL_CONTENT_TOTAL.rawValue {
                arrContainerSection.append("")
            }
            self.arrContainerTotal.append(arrContainerSection)
        }
        arrISSelectedOwnerDriver.append(false)
        arrISSelectedInsured.append(true)
 
    }

    @objc func navigateToNextPage() {
            self.addCarDetailsInfoDic()
    }
    
    
    
    @objc func selectInsuranceYes(_sel:UIButton){
        
        if   (_sel.superview?.superview?.superview?.superview?.isKind(of: AccidentCell.self ))!{

            _sel.isSelected = !(_sel.isSelected)
            if  let cell: AccidentCell = _sel.superview?.superview?.superview?.superview as? AccidentCell {
                cell.buttonBoolNo.isSelected = (_sel.isSelected)
               
                if  let indexPath = accidentTable.indexPath(for: cell)
                {
                    arrISSelectedInsured[indexPath.section] = !arrISSelectedInsured[indexPath.section]
                }
            }
            accidentTable.reloadData()
        }
        
    }
    @objc func selectInsuranceNo(_sel:UIButton){
 
        if   (_sel.superview?.superview?.superview?.superview?.isKind(of: AccidentCell.self ))!{
            
            _sel.isSelected = !(_sel.isSelected)
            if  let cell: AccidentCell = _sel.superview?.superview?.superview?.superview as? AccidentCell {
                cell.buttonBooLYes.isSelected = (_sel.isSelected)
                
                if  let indexPath = accidentTable.indexPath(for: cell)
                {
                    arrISSelectedInsured[indexPath.section] = !arrISSelectedInsured[indexPath.section]
                }
            }
            accidentTable.reloadData()
        }
    }
    //ei vabe
    @objc func seletDriverSelection(_sel:UIButton){
        if   (_sel.superview?.superview?.superview?.superview?.isKind(of: AccidentCell.self ))!{
            
               _sel.isSelected = !(_sel.isSelected)
            if  let cell: AccidentCell = _sel.superview?.superview?.superview?.superview as? AccidentCell {
                cell.OwnerDriverSelection.isSelected = (_sel.isSelected)
                if  let indexPath = accidentTable.indexPath(for: cell)
                {
                    arrISSelectedOwnerDriver[indexPath.section] = !arrISSelectedOwnerDriver[indexPath.section]
                }
            }
            accidentTable.reloadData()
        }
       
    }
    
    @objc func seletOwnerDriverSelection(_sel:UIButton){
        if   (_sel.superview?.superview?.superview?.superview?.isKind(of: AccidentCell.self ))!{
            //variableArrayCount  = _sel.isSelected ? arrContainer.count : arrContainer.count - 4
            _sel.isSelected = !(_sel.isSelected)
            if  let cell: AccidentCell = _sel.superview?.superview?.superview?.superview as? AccidentCell {
                cell.DriverSelection.isSelected = (_sel.isSelected)
                if  let indexPath = accidentTable.indexPath(for: cell)
                {
                    arrISSelectedOwnerDriver[indexPath.section] = !arrISSelectedOwnerDriver[indexPath.section]
                }
            }
             accidentTable.reloadData()
        }
    }
    
 
    
}

//Mark: - TableView Extention
extension CarDetailsInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < numberOfSection-1 {
            return arrISSelectedOwnerDriver[section] == true ? arrContainerTotal[section].count - 4 : (arrContainerTotal[section].count )
            
        }
        else{
            return 1
        }
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 50.0 :  40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = ACCIDENT_PLACE_HOLDER.init(rawValue: indexPath.row)
        
        if indexPath.section < numberOfSection - 1  {
            switch type {
            case .CELL_CONTENT_INSURED?:
                let cell: AccidentCell = self.accidentTable.dequeueReusableCell(withIdentifier: "fromCell2") as! AccidentCell
                self.addValidation(myIndex: indexPath.row, cell: cell)
                cell.buttonBooLYes.addTarget(self, action: #selector(selectInsuranceYes(_sel:)), for: .touchUpInside)
                cell.buttonBoolNo.addTarget(self, action: #selector(selectInsuranceNo(_sel:)), for: .touchUpInside)
                cell.buttonBooLYes.isSelected =   arrISSelectedInsured[indexPath.section]
                cell.buttonBoolNo.isSelected =   !arrISSelectedInsured[indexPath.section]
                
                return cell
                
            case .CELL_CONTENT_OWNER?:
                let cell: AccidentCell = self.accidentTable.dequeueReusableCell(withIdentifier: "fromCell3") as! AccidentCell
                self.addValidation(myIndex: indexPath.row, cell: cell)
                cell.OwnerDriverSelection.addTarget(self, action: #selector(seletOwnerDriverSelection(_sel:)), for: .touchUpInside)
                //selectOwner
                cell.DriverSelection.addTarget(self, action: #selector(seletDriverSelection(_sel:)), for: .touchUpInside)
                cell.DriverSelection.isSelected =   !arrISSelectedOwnerDriver[indexPath.section]
                cell.OwnerDriverSelection.isSelected =   arrISSelectedOwnerDriver[indexPath.section]
                return cell
                
            case .CELL_CONTENT_INSURED_COMPANY?:
                let cell: AccidentCell = self.accidentTable.dequeueReusableCell(withIdentifier: "fromCell") as! AccidentCell
                cell.textFieldCell.tag = indexPath.row
                cell.textFieldCell.text = self.arrContainerTotal[indexPath.section][indexPath.row]
                cell.textFieldCell.placeholder = type?.getPlaceHolderText()
                cell.textFieldCell.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
                self.addValidation(myIndex: indexPath.row, cell: cell)
                cell.textFieldCell.isUserInteractionEnabled = arrISSelectedInsured[indexPath.section]
           
                cell.textFieldCell.text = arrISSelectedInsured[indexPath.section]  == false ? "" : arrContainerTotal[indexPath.section][ACCIDENT_PLACE_HOLDER.CELL_CONTENT_INSURED_COMPANY.rawValue]
               
                
                return cell
                
                
            default:
                let cell: AccidentCell = self.accidentTable.dequeueReusableCell(withIdentifier: "fromCell") as! AccidentCell
                cell.textFieldCell.tag = indexPath.row
                cell.textFieldCell.text = self.arrContainerTotal[indexPath.section][indexPath.row]
                cell.textFieldCell.placeholder = type?.getPlaceHolderText()
                cell.textFieldCell.isUserInteractionEnabled = true
                cell.textFieldCell.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
                self.addValidation(myIndex: indexPath.row, cell: cell)
                
                return cell
                
                
                
            }
            
        }else{
            let cell = self.accidentTable.dequeueReusableCell(withIdentifier: "buttonCell") as! AccidentCell
            cell.buttonNext.addTarget(self, action: #selector(self.navigateToNextPage), for: .touchUpInside)
            // cell.buttonPrevious.addTarget(self, action: #selector(self.navigateToPreviousPage), for: .touchUpInside)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section < numberOfSection - 1  {
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: self.accidentTable.bounds.size.width, height: 40)) //set these
            returnedView.backgroundColor = UIColor.clear
            let label = UILabel(frame: CGRect(x: 0, y: 10, width: self.accidentTable.bounds.size.width, height: 20))
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            label.text = "Car "+"\(section + 1)"
            returnedView.addSubview(label)
            return returnedView
        }
        else{
            let u = UIView()
            return u
        }
       
        
    }
    
    
    func addValidation(myIndex: Int, cell : AccidentCell)  {
        let myType = ACCIDENT_PLACE_HOLDER.init(rawValue: myIndex)
        switch myType {
        case .CELL_CONTENT_MAKE? , .CELL_CONTENT_REGO? , .CELL_CONTENT_INSURED_COMPANY?, .CELL_CONTENT_OWNER_NAME?, .CELL_CONTENT_OWNER_ADDESS?, .CELL_CONTENT_DRIVER_NAME?, .CELL_CONTENT_DRIVER_ADDRESS?:
            cell.textFieldCell.keyboardType = .asciiCapable
            
        case .CELL_CONTENT_OWNER_MOBILE?, .CELL_CONTENT_DRIVER_MOBILE?:
            cell.textFieldCell.keyboardType = .phonePad
            
        case .CELL_CONTENT_OWNER_EMAIL?, .CELL_CONTENT_DRIVER_EMAIL?:
            cell.textFieldCell.keyboardType = .emailAddress
 
        default: break
            
        }

    }
    
}

//Mark : - PickerView
extension CarDetailsInfoViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textNumberOfCars.text = arrPicker[row]
        self.numberOfSection = Int(arrPicker[row]) ?? 0
    }

}

extension CarDetailsInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CarDetailsInfoViewController{
    
    @objc fileprivate func textFieldValueChanged(_ txt:UITextField) {
        guard let cell:AccidentCell = txt.superview?.superviewOfClassType(AccidentCell.self) as? AccidentCell  else {
            return
        }
        guard let indexPath = accidentTable.indexPath(for: cell) else {
            return
        }
        let type = ACCIDENT_PLACE_HOLDER.init(rawValue: indexPath.row)
        if indexPath.section < arrContainerTotal.count  {
            
            switch type {
            case .CELL_CONTENT_INSURED?: break
                
            case .CELL_CONTENT_OWNER?:break
                
            default:
                if let str = txt.text, !(str.isEmpty) {
                    
                self.arrContainerTotal[indexPath.section].remove(at: indexPath.row)
                self.arrContainerTotal[indexPath.section].insert(str, at: indexPath.row)
                }else{
                    self.arrContainerTotal[indexPath.section].remove(at: indexPath.row)
                    self.arrContainerTotal[indexPath.section].insert("", at: indexPath.row)
                }
                print(String.init(describing: self.arrContainerTotal))
                break
            }
        }
    }
    
 
    
    func addCarDetailsInfoDic(){
        for(index,arr) in arrContainerTotal.enumerated()
        {
            if (index >= numberOfSection-1 ){
                break
            }
            let flag = arrISSelectedOwnerDriver[index] == true ? "1" : "2"
            let flagInsured = arrISSelectedInsured[index] == true ? "1": "2"
            
            let make_key = "involved_car[" + "\(index)" + "][make]"
            let rego_key = "involved_car[" + "\(index)" + "][rego]"
            let isInsured_key = "involved_car[" + "\(index)" + "][is_insured]"
            let insuranceCompany_key = "involved_car[" + "\(index)" + "][insurance_company]"
            
            let ownerDriverFlag_key = "involved_car[" + "\(index)" + "][owner_driver_flag]"
            
            let ownerName_key = "involved_car[" + "\(index)" + "][owner_name]"
            let ownerAddress = "involved_car[" + "\(index)" + "][owner_address]"
            
            let ownerContactNo_key = "involved_car[" + "\(index)" + "][owner_contact_no]"
            let ownerEmail_key = "involved_car[" + "\(index)" + "][owner_email]"
            
            let driverName_key = "involved_car[" + "\(index)" + "][driver_name]"
            let driverAddress_key = "involved_car[" + "\(index)" + "][driver_address]"
            
            let driverContact_key = "involved_car[" + "\(index)" + "][driver_contact_no]"
            let driverEmail_key = "involved_car[" + "\(index)" + "][driver_email]"
            
            
            if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_MAKE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                UtilityClass.tosta(message: "Data couldn't be blank", duration: 1.0, vc: self)
                return
            }
            if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_REGO.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                UtilityClass.tosta(message: "Data couldn't be blank", duration: 1.0, vc: self)
                return
            }
            if flagInsured == "1" {
                if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_INSURED_COMPANY.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                    UtilityClass.tosta(message: "Data couldn't be blank", duration: 1.0, vc: self)
                    return
                }
            }
            
            if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_NAME.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                UtilityClass.tosta(message: "Data couldn't be blank", duration: 1.0, vc: self)
                return
            }
            if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_ADDESS.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                UtilityClass.tosta(message: "Data couldn't be blank", duration: 1.0, vc: self)
                return
            }
            if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                UtilityClass.tosta(message: "Data couldn't be blank", duration: 1.0, vc: self)
                return
            }
//            if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_EMAIL.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
//                UtilityClass.tosta(message: ALERT_MESSAGE_BLANK, duration: 1.0, vc: self)
//                return
//            }
            
            if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_EMAIL.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0 {
                if !(arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_EMAIL.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isValideEmail) {
                    UtilityClass.tosta(message: ALERT_MESSAGE_EMAIL_INVALID, duration: 1.0, vc: self)
                    return
                }
            }
            
            if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count < 10  {
                UtilityClass.tosta(message: ALERT_PHONE_NUMBER, duration: 1.0, vc: self)
                return 
            }
            
            if flag == "2" {
                if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_NAME.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                    UtilityClass.tosta(message: "Data couldn't be blank", duration: 1.0, vc: self)
                    return
                }
                if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_ADDRESS.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                    UtilityClass.tosta(message: "Data couldn't be blank", duration: 1.0, vc: self)
                    return
                }
                if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                    UtilityClass.tosta(message: "Data couldn't be blank", duration: 1.0, vc: self)
                    return
                }
                if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_EMAIL.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0 {
                    if !(arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_EMAIL.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isValideEmail) {
                        UtilityClass.tosta(message: ALERT_MESSAGE_EMAIL_INVALID, duration: 1.0, vc: self)
                        return
                    }
                }
                
                if arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count < 10  {
                    UtilityClass.tosta(message: ALERT_PHONE_NUMBER, duration: 1.0, vc: self)
                    return
                }
            }
            //no_of_car
            carDetailsInfo["no_of_car"] =  String((numberOfSection - 1))
            carDetailsInfo[make_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_MAKE.rawValue]
            carDetailsInfo[rego_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_REGO.rawValue]
            carDetailsInfo[isInsured_key] = flagInsured
            carDetailsInfo[insuranceCompany_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_INSURED_COMPANY.rawValue]
            carDetailsInfo[ownerDriverFlag_key] = flag
            carDetailsInfo[ownerName_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_NAME.rawValue]
            carDetailsInfo[ownerAddress] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_ADDESS.rawValue]
            carDetailsInfo[ownerContactNo_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_MOBILE.rawValue]
            carDetailsInfo[ownerEmail_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_OWNER_EMAIL.rawValue]
            carDetailsInfo[driverName_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_NAME.rawValue]
            carDetailsInfo[driverAddress_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_ADDRESS.rawValue]
            carDetailsInfo[driverContact_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_MOBILE.rawValue]
            carDetailsInfo[driverEmail_key] = arr[ACCIDENT_PLACE_HOLDER.CELL_CONTENT_DRIVER_EMAIL.rawValue]
        }
        
        UserDefaults.standard.set(arrContainerTotal, forKey:USER_DEFAULT_SAVE_CAR_INFO )
        UserDefaults.standard.set(arrISSelectedInsured, forKey:USER_DEFAULT_SAVE_INSURENCE )
        UserDefaults.standard.set(arrISSelectedOwnerDriver, forKey:USER_DEFAULT_SAVE_OWNER_DRIVER )
        UserDefaults.standard.set(self.numberOfSection, forKey:USER_DEFAULT_CAR_NUMBER )
      
        UserDefaults.standard.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DocumentsPhotosViewController") as!
        DocumentsPhotosViewController
        vc.carDetails1stPageInfo = carDetailsInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
        
    }



