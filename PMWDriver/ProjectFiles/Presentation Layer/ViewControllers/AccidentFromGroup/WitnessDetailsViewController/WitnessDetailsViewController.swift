//
//  WitnessDetailsViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import Foundation

class WitnessDetailsViewController: UIViewController {
    
    @IBOutlet weak var WitnessTable:UITableView!
    var arrContainer = [String]()
    
    var imageArrayAccidentPhotos:[MultipartInfo] = [MultipartInfo]()
    var witnessDetailsInfo = Dictionary<String, String>()
    var isPoliceAttended = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(self.checkDataIsSaveOrNot()) {
             self.getBlankTextArray()
        }
        self.WitnessTable.rowHeight = UITableView.automaticDimension
        self.WitnessTable.estimatedRowHeight = 44.0
        self.WitnessTable.reloadData()
  
    }
    
    
    func checkDataIsSaveOrNot() -> Bool  {
        var witnessInfo = [String]()
        if let  mySaveData = UserDefaults.standard.object(forKey: USER_DEFAULT_SAVE_WITNESS_INFO){
            witnessInfo = mySaveData as! [String]
            if witnessInfo.count > 0 {
                self.arrContainer.removeAll()
                self.arrContainer = witnessInfo
                return true
            }
            return false
        }
        return false
    }
    
    
    fileprivate enum WITNESS_PLACE_HOLDER :Int{
        case CELL_CONTENT_NAME = 0
        case CELL_CONTENT_ADDRESS
        case CELL_CONTENT_MOBILE
        case CELL_CONTENT_POLICE_ATTENDED
        case CELL_CONTENT_POLICE_NAME
        case CELL_CONTENT_POLICE_STATION
        case CELL_CONTENT_POLICE_MOBILE
        case CELL_CONTENT_REFERENCE_NO
        case CELL_CONTENT_TOTAL // to denote last elments
        
        func getPlaceHolderText() -> String {
            switch self {
            case .CELL_CONTENT_NAME:
                return "Name"
            case .CELL_CONTENT_ADDRESS:
                return "Address"
            case .CELL_CONTENT_MOBILE:
                return "Mobile"
            case .CELL_CONTENT_POLICE_ATTENDED:
                return ""
            case .CELL_CONTENT_POLICE_NAME:
                return "Name"
            case .CELL_CONTENT_POLICE_STATION:
                return "Police Station"
            case .CELL_CONTENT_POLICE_MOBILE:
                return "Phone No"
            case .CELL_CONTENT_REFERENCE_NO:
                return "Reference No"
                
            default:
                return ""
            }
            
        }
    }
    
    
    
    
    
    
    func getBlankTextArray() {
        arrContainer.removeAll()
        for _ in 0..<WITNESS_PLACE_HOLDER.CELL_CONTENT_TOTAL.rawValue {
            arrContainer.append("")
        }
        arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_ATTENDED.rawValue] = isPoliceAttended == true ? "1" : "2"
    }
    
    @objc func navigateToNextPage() {
        
        // client feedback Witness not mendetary 
        /*
         if arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_NAME.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            
            UtilityClass.tosta(message: "Witness name couldn't be blank", duration: 1.0, vc: self)
            return
        }
        if arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_ADDRESS.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            
            UtilityClass.tosta(message: "Witness address couldn't be blank", duration: 1.0, vc: self)
            return
        }
        if arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            UtilityClass.tosta(message: "Witness mobile number couldn't be blank", duration: 1.0, vc: self)
            return
        }
        if arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count < 10 {
            UtilityClass.tosta(message: ALERT_PHONE_NUMBER, duration: 1.0, vc: self)
            return
        }
         */
        
        
        // if there is phone number it must be 10 digit or more
        if (arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0) &&  (arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count < 10) {
            UtilityClass.tosta(message: ALERT_PHONE_NUMBER, duration: 1.0, vc: self)
            return
        }
        
        
        
        if(isPoliceAttended){
            
            if arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_NAME.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                
                UtilityClass.tosta(message: "Police name couldn't be blank", duration: 1.0, vc: self)
                return
            }
            if arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_STATION.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                
                UtilityClass.tosta(message: "Police station name couldn't be blank", duration: 1.0, vc: self)
                return
            }
            if arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                UtilityClass.tosta(message: "Police mobile number couldn't be blank", duration: 1.0, vc: self)
                return
            }
            if arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_REFERENCE_NO.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                UtilityClass.tosta(message: "Reference number couldn't be blank", duration: 1.0, vc: self)
                return
            }
            
            if arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_MOBILE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count < 10 {
                UtilityClass.tosta(message: ALERT_PHONE_NUMBER, duration: 1.0, vc: self)
                return
            }
            
        }
        
        self.addWitnessDetailsInfoDic()
        
        
    }
    
  
    
    @objc func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DocumentsPhotosViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}

//Mark: - TableView Extention
extension WitnessDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isPoliceAttended == true ? arrContainer.count + 1 : (arrContainer.count - 4) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let condition = isPoliceAttended ? (indexPath.row < arrContainer.count) : (indexPath.row < (arrContainer.count - 4))
        if  condition {
            let type = WITNESS_PLACE_HOLDER.init(rawValue: indexPath.row)
            switch type {
                
            case .CELL_CONTENT_POLICE_ATTENDED?:
                let cell: AccidentCell = self.WitnessTable.dequeueReusableCell(withIdentifier: "fromCell2") as! AccidentCell
                self.addValidation(myIndex: indexPath.row, cell: cell)
                cell.buttonBooLYes.addTarget(self, action: #selector(selectPoliceAttendentYes(_sel:)), for: .touchUpInside)
                cell.buttonBoolNo.addTarget(self, action: #selector(selectPoliceAttendentNo(_sel:)), for: .touchUpInside)
                return cell
                
                
            case .CELL_CONTENT_POLICE_NAME?,.CELL_CONTENT_POLICE_STATION?,.CELL_CONTENT_POLICE_MOBILE?,.CELL_CONTENT_REFERENCE_NO?:
                
                let cell: AccidentCell = self.WitnessTable.dequeueReusableCell(withIdentifier: "fromCell") as! AccidentCell
                cell.textFieldCell.placeholder = type?.getPlaceHolderText()
                self.addValidation(myIndex: indexPath.row, cell: cell)
                cell.textFieldCell.tag = indexPath.row
                cell.textFieldCell.text = self.arrContainer[indexPath.row]
                cell.textFieldCell.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
                if !isPoliceAttended {
                   cell.textFieldCell.text = ""
                }else{
                    switch type { //Insert privious value
                    case .CELL_CONTENT_POLICE_NAME?:
                        cell.textFieldCell.text  = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_NAME.rawValue]
                        break
                    case .CELL_CONTENT_POLICE_STATION?:
                         cell.textFieldCell.text  = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_STATION.rawValue]
                        break
                    case .CELL_CONTENT_POLICE_MOBILE?:
                         cell.textFieldCell.text  = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_MOBILE.rawValue]
                        break
                    case .CELL_CONTENT_REFERENCE_NO?:
                         cell.textFieldCell.text  = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_REFERENCE_NO.rawValue]
                           break
                    default:
                       break
                    }
                }
                return cell

            default:
                let cell: AccidentCell = self.WitnessTable.dequeueReusableCell(withIdentifier: "fromCell") as! AccidentCell
                cell.textFieldCell.placeholder = type?.getPlaceHolderText()
                self.addValidation(myIndex: indexPath.row, cell: cell)
                cell.textFieldCell.tag = indexPath.row
                cell.textFieldCell.text = self.arrContainer[indexPath.row]
                cell.textFieldCell.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
                return cell
            }
            
        }else{
            let cell = self.WitnessTable.dequeueReusableCell(withIdentifier: "buttonCell") as! AccidentCell
            cell.buttonNext.addTarget(self, action: #selector(self.navigateToNextPage), for: .touchUpInside)
            cell.buttonPrevious.addTarget(self, action: #selector(self.navigateToPreviousPage), for: .touchUpInside)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    
    func addValidation(myIndex: Int, cell : AccidentCell) {
        let myType = WITNESS_PLACE_HOLDER.init(rawValue: myIndex)
        switch myType {
        case .CELL_CONTENT_NAME? , .CELL_CONTENT_ADDRESS? , .CELL_CONTENT_POLICE_NAME?, .CELL_CONTENT_POLICE_STATION?:
            cell.textFieldCell.keyboardType = .asciiCapable
            
        case .CELL_CONTENT_MOBILE?, .CELL_CONTENT_POLICE_MOBILE?, .CELL_CONTENT_REFERENCE_NO?:
            cell.textFieldCell.keyboardType = .phonePad
        default: break
            
        }
        
        
    }
    @objc func selectPoliceAttendentYes(_sel:UIButton)
    {
        if   (_sel.superview?.superview?.superview?.superview?.isKind(of: AccidentCell.self ))!{
            _sel.isSelected = !(_sel.isSelected)
            isPoliceAttended = !isPoliceAttended
            arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_ATTENDED.rawValue] = isPoliceAttended == true ? "1" : "0"
            if  let cell: AccidentCell = _sel.superview?.superview?.superview?.superview as? AccidentCell {
                cell.buttonBoolNo.isSelected = !(_sel.isSelected)
            }
        }
        WitnessTable.reloadData()
    }
    @objc func selectPoliceAttendentNo(_sel:UIButton)
    {
        if (_sel.superview?.superview?.superview?.superview?.isKind(of: AccidentCell.self ))!{
            _sel.isSelected = !(_sel.isSelected)
            isPoliceAttended = !isPoliceAttended
            arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_ATTENDED.rawValue] = isPoliceAttended == true ? "1" : "0"
            if  let cell: AccidentCell = _sel.superview?.superview?.superview?.superview as? AccidentCell {
                cell.buttonBooLYes.isSelected = !(_sel.isSelected)
            }
        }
        WitnessTable.reloadData()
    }
    
}

extension WitnessDetailsViewController{
    
    @objc fileprivate func textFieldValueChanged(_ txt:UITextField) {
        guard let cell:AccidentCell = txt.superview?.superviewOfClassType(AccidentCell.self) as? AccidentCell  else {
            return
        }
        
        guard let indexPath = WitnessTable.indexPath(for: cell) else {
            return
        }
        let type = WITNESS_PLACE_HOLDER.init(rawValue: indexPath.row)
        if indexPath.row < arrContainer.count {
            switch type {
            case .CELL_CONTENT_POLICE_ATTENDED?: break
                
            default:
                if let str = txt.text, !(str.isEmpty) {
                    self.arrContainer.remove(at: indexPath.row)
                    self.arrContainer.insert(str, at: indexPath.row)
                }else{
                    self.arrContainer.remove(at: indexPath.row)
                    self.arrContainer.insert("", at: indexPath.row)
                }
                print(String.init(describing: self.arrContainer))
                
                break
            }
        }
     }
    
    
  
    
    
    func addWitnessDetailsInfoDic(){
           
        witnessDetailsInfo["witness_name"] = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_NAME.rawValue]
        witnessDetailsInfo["witness_address"] = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_ADDRESS.rawValue]
        witnessDetailsInfo["witness_mobile"] = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_MOBILE.rawValue]
        witnessDetailsInfo["is_police_attended"] = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_ATTENDED.rawValue]
        witnessDetailsInfo["officer_name"] = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_NAME.rawValue]
        witnessDetailsInfo["police_station"] = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_STATION.rawValue]
        witnessDetailsInfo["officer_phone_no"] = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_POLICE_MOBILE.rawValue]
        witnessDetailsInfo["officer_reference_no"] = arrContainer[WITNESS_PLACE_HOLDER.CELL_CONTENT_REFERENCE_NO.rawValue]
        
         UserDefaults.standard.set(arrContainer, forKey:USER_DEFAULT_SAVE_WITNESS_INFO )
         UserDefaults.standard.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccidentLocationDetailsViewController") as! AccidentLocationDetailsViewController
        
        vc.witnessDetailsReceivedInfo = witnessDetailsInfo
        vc.imageArrayAccidentWitnessPhotos = imageArrayAccidentPhotos
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

