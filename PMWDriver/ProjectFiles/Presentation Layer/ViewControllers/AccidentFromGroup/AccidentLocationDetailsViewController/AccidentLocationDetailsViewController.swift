//
//  AccidentLocationDetailsViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit


class AccidentLocationDetailsViewController: BaseViewController {
    
    @IBOutlet weak var locationDetailsTable:UITableView!
    var arrContainer = [String]()
    //taken From Samprita //
    var witnessDetailsReceivedInfo = Dictionary<String, String>()
    var accidentLocationDetailsInfo = Dictionary<String, String>()
    var imageArrayAccidentWitnessPhotos:[MultipartInfo] = [MultipartInfo]()
    let AccidentDatePicker = UIDatePicker()
    let AccidentTimePicker = UIDatePicker()
    
    @IBOutlet weak var buttonFault: UIButton!
    @IBOutlet weak var buttonNotFault: UIButton!
    var isFault:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getBlankTextArray()
        //taken from Samprita //
        print("All Ddata:",witnessDetailsReceivedInfo)
        print("Image Doc:",imageArrayAccidentWitnessPhotos)
        self.locationDetailsTable.separatorStyle = .none
        //**//
        
        self.locationDetailsTable.rowHeight = UITableView.automaticDimension
        self.locationDetailsTable.estimatedRowHeight = 44.0
        self.locationDetailsTable.reloadData()
        
    }
    
    
    @IBAction func buttonTapFault(_ sender: UIButton) {
        self.buttonFault.isSelected = true
        self.buttonNotFault.isSelected = false
        self.isFault = true
    }
    
    
    @IBAction func buttonTapNotFault(_ sender: UIButton) {
        self.buttonFault.isSelected = false
        self.buttonNotFault.isSelected = true
        self.isFault = false
    }
    
    
    fileprivate enum LOCATION_PLACE_HOLDER :Int{
        case CELL_CONTENT_DATE = 0
        case CELL_CONTENT_TIME
        case CELL_CONTENT_PLACE
        case CELL_CONTENT_DESCRIPTION
        case CELL_CONTENT_TOTAL // to denote last elments
        
        func getPlaceHolderText() -> String {
            switch self {
            case .CELL_CONTENT_DATE:
                return "Date"
            case .CELL_CONTENT_TIME:
                return "Time"
            case .CELL_CONTENT_PLACE:
                return "Place"
            case .CELL_CONTENT_DESCRIPTION:
                return ""
            default:
                return ""
            }
        }
    }
    
    
    
    
    
    func getBlankTextArray() {
        arrContainer.removeAll()
        for _ in 0..<LOCATION_PLACE_HOLDER.CELL_CONTENT_TOTAL.rawValue {
            arrContainer.append("")
        }
        print(arrContainer.count)
    }
    
    @objc func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: WitnessDetailsViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @objc func buttonSubmit() {
        submitAccidentDataAPIcall() //taken from Samprita //
    }
    
    @objc func popToDashboard() {
        
        
    }
    
    
}

//Mark: - TableView Extention
extension AccidentLocationDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContainer.count + 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < arrContainer.count  {
            let type = LOCATION_PLACE_HOLDER.init(rawValue: indexPath.row)
            
            if type == LOCATION_PLACE_HOLDER.CELL_CONTENT_DESCRIPTION {
                let cell: AccidentCell = self.locationDetailsTable.dequeueReusableCell(withIdentifier: "fromCellTextView") as! AccidentCell
                cell.descriptionTextView.delegate = self
                cell.descriptionTextView.text = self.arrContainer[indexPath.row]
                cell.descriptionTextView.tag = indexPath.row
                return cell
                
            }else{
                
            let cell: AccidentCell = self.locationDetailsTable.dequeueReusableCell(withIdentifier: "fromCell") as! AccidentCell
            cell.textFieldCell.placeholder = type?.getPlaceHolderText()
            cell.textFieldCell.text = self.arrContainer[indexPath.row]
            
            //taken from Samprita //
   
            if type == LOCATION_PLACE_HOLDER.CELL_CONTENT_DATE {
                // Bind the label's text to the DatePicker value
                cell.textFieldCell.text =  cell.textFieldCell.text == "" ? Date().currentDate :  cell.textFieldCell.text
                
                self.arrContainer[indexPath.row] = cell.textFieldCell.text ?? ""
                createPickerView(sender: cell.textFieldCell)
                
            }else if type == LOCATION_PLACE_HOLDER.CELL_CONTENT_TIME {
                
                createTimePickerView(sender: cell.textFieldCell)
                cell.textFieldCell.text =  cell.textFieldCell.text == "" ? Date().currentTime:  cell.textFieldCell.text
                self.arrContainer[indexPath.row] = cell.textFieldCell.text ?? ""
                
            }
            cell.textFieldCell.tag = indexPath.row
            cell.textFieldCell.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
            return cell
            }
            
        }else{
            let cell = self.locationDetailsTable.dequeueReusableCell(withIdentifier: "buttonCell") as! AccidentCell
            cell.buttonNext.addTarget(self, action: #selector(self.buttonSubmit), for: .touchUpInside)
            cell.buttonPrevious.addTarget(self, action: #selector(self.navigateToPreviousPage), for: .touchUpInside)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    //taken from Samprita //
    func createPickerView(sender: UITextField){
        AccidentDatePicker.datePickerMode = .date
        AccidentDatePicker.tag = sender.tag
        AccidentDatePicker.maximumDate = Date()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action:#selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        // add toolbar to textField
        sender.inputAccessoryView = toolbar
        sender.inputView = AccidentDatePicker
        
        //AccidentDatePicker.addTarget(self, action: #selector(datePickerValueChanged(caller:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func donePicker(barButton:UIBarButtonItem){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let indexPath = IndexPath(row: LOCATION_PLACE_HOLDER.CELL_CONTENT_DATE.rawValue, section: 0)
        let cell = locationDetailsTable.cellForRow(at: indexPath) as! AccidentCell
        cell.textFieldCell.text = dateFormatter.string(from: AccidentDatePicker.date)
        self.arrContainer.remove(at: LOCATION_PLACE_HOLDER.CELL_CONTENT_DATE.rawValue)
        self.arrContainer.insert(cell.textFieldCell.text ?? "", at: LOCATION_PLACE_HOLDER.CELL_CONTENT_DATE.rawValue)
        self.view.endEditing(true)
        
    }

    //taken from Samprita //
    func createTimePickerView(sender: UITextField){
        AccidentTimePicker.datePickerMode = .time
        sender.inputView = AccidentTimePicker
        AccidentTimePicker.tag = sender.tag
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action:#selector(self.doneTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        // add toolbar to textField
        sender.inputAccessoryView = toolbar
        sender.inputView = AccidentTimePicker
        
        
        
        //AccidentTimePicker.addTarget(self, action: #selector(timePickerValueChanged(caller:)), for: UIControl.Event.valueChanged)
    }
    
    
    @objc func doneTimePicker(barButton:UIBarButtonItem){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        let indexPath = IndexPath(row: LOCATION_PLACE_HOLDER.CELL_CONTENT_TIME.rawValue, section: 0)
        let cell = locationDetailsTable.cellForRow(at: indexPath) as! AccidentCell
        cell.textFieldCell.text = dateFormatter.string(from: AccidentTimePicker.date)
        self.arrContainer.remove(at: LOCATION_PLACE_HOLDER.CELL_CONTENT_TIME.rawValue)
        self.arrContainer.insert(cell.textFieldCell.text ?? "", at: LOCATION_PLACE_HOLDER.CELL_CONTENT_TIME.rawValue)
        self.view.endEditing(true)
        
    }
    
//    //taken from Samprita //
//    @objc func timePickerValueChanged(caller: UIDatePicker){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//        let indexPath = IndexPath(row: LOCATION_PLACE_HOLDER.CELL_CONTENT_TIME.rawValue, section: 0)
//        let cell = locationDetailsTable.cellForRow(at: indexPath) as! AccidentCell
//        cell.textFieldCell.text = dateFormatter.string(from: AccidentTimePicker.date)
//        self.arrContainer.remove(at: LOCATION_PLACE_HOLDER.CELL_CONTENT_TIME.rawValue)
//        self.arrContainer.insert(cell.textFieldCell.text ?? "", at: LOCATION_PLACE_HOLDER.CELL_CONTENT_TIME.rawValue)
//    }
    
}

extension AccidentLocationDetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView){
        guard let cell:AccidentCell = textView.superview?.superviewOfClassType(AccidentCell.self) as? AccidentCell  else {
            return
        }
        guard let indexPath = locationDetailsTable.indexPath(for: cell) else {
            return
        }
        if indexPath.row < arrContainer.count {
            if let str = textView.text, !(str.isEmpty) {
                self.arrContainer.remove(at: indexPath.row)
                self.arrContainer.insert(str, at: indexPath.row)
            }else{
                self.arrContainer.remove(at: indexPath.row)
                self.arrContainer.insert("", at: indexPath.row)
            }
            print(String.init(describing: self.arrContainer))
            
        }
    }
    
    
}

//taken from Samprita //
extension AccidentLocationDetailsViewController{
    
    @objc fileprivate func textFieldValueChanged(_ txt:UITextField) {
        guard let cell:AccidentCell = txt.superview?.superviewOfClassType(AccidentCell.self) as? AccidentCell  else {
            return
        }
        guard let indexPath = locationDetailsTable.indexPath(for: cell) else {
            return
        }
        if indexPath.row < arrContainer.count {
            if let str = txt.text, !(str.isEmpty) {
                self.arrContainer.remove(at: indexPath.row)
                self.arrContainer.insert(str, at: indexPath.row)
            }else{
                self.arrContainer.remove(at: indexPath.row)
                self.arrContainer.insert("", at: indexPath.row)
            }
            print(String.init(describing: self.arrContainer))
            
        }
    }
    
    @objc fileprivate func textViewValueChanged(_ txt:UITextView) {
        guard let cell:AccidentCell = txt.superview?.superviewOfClassType(AccidentCell.self) as? AccidentCell  else {
            return
        }
        guard let indexPath = locationDetailsTable.indexPath(for: cell) else {
            return
        }
        if indexPath.row < arrContainer.count {
            if let str = txt.text, !(str.isEmpty) {
                self.arrContainer.remove(at: indexPath.row)
                self.arrContainer.insert(str, at: indexPath.row)
            }else{
                self.arrContainer.remove(at: indexPath.row)
                self.arrContainer.insert("", at: indexPath.row)
            }
            print(String.init(describing: self.arrContainer))
            
        }
    }
   
    
    //taken from Samprita //
    func submitAccidentDataAPIcall(){
        
        if arrContainer[LOCATION_PLACE_HOLDER.CELL_CONTENT_DATE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            
            UtilityClass.tosta(message: "Date couldn't be blank", duration: 1.0, vc: self)
            return
        }
        if arrContainer[LOCATION_PLACE_HOLDER.CELL_CONTENT_TIME.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            
            UtilityClass.tosta(message: "Time couldn't be blank", duration: 1.0, vc: self)
            return
        }
        if arrContainer[LOCATION_PLACE_HOLDER.CELL_CONTENT_PLACE.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            UtilityClass.tosta(message: "Place couldn't be blank", duration: 1.0, vc: self)
            return
        }
//        if arrContainer[LOCATION_PLACE_HOLDER.CELL_CONTENT_DESCRIPTION.rawValue].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
//            UtilityClass.tosta(message: "Description couldn't be blank", duration: 1.0, vc: self)
//            return
//        }
        addAccidentData()
       
    }
    //Mark : - call api for Accident data
    
    func addAccidentData()
    {
        witnessDetailsReceivedInfo["accident_datetime"] =  arrContainer[LOCATION_PLACE_HOLDER.CELL_CONTENT_DATE.rawValue] + " " + arrContainer[LOCATION_PLACE_HOLDER.CELL_CONTENT_TIME.rawValue]
        
        witnessDetailsReceivedInfo["place"] = arrContainer[LOCATION_PLACE_HOLDER.CELL_CONTENT_PLACE.rawValue]
        witnessDetailsReceivedInfo["description"] = arrContainer[LOCATION_PLACE_HOLDER.CELL_CONTENT_DESCRIPTION.rawValue]
        let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY )
        let userID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID )
        if  let shiftID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_SHIFT_ID){
           witnessDetailsReceivedInfo["shift_id"] = shiftID
        }else {
           witnessDetailsReceivedInfo["shift_id"] = ""
        }
        let carID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_CAR_NO) ?? ""
        witnessDetailsReceivedInfo["token_key"] = token
        witnessDetailsReceivedInfo["device_type"] = "1"
        witnessDetailsReceivedInfo["car_id"] = carID
        witnessDetailsReceivedInfo["driver_id"] = userID
        
        witnessDetailsReceivedInfo["fault_type"] = self.isFault ? "fault" : "not fault"
        
        print("final accdent Data", witnessDetailsReceivedInfo)
        self.showLoading()
        self.accidentDataSubmit(SubmissionData: witnessDetailsReceivedInfo as [String : AnyObject], imageArray: imageArrayAccidentWitnessPhotos){ (status, message) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
            if status == 0{
                UtilityClass.tostaOnWindow(message: message, duration: 3.0, vc: self)
                self.removeSavedAccidentData()
                let vc:DashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                vc.isBreakdown = false
                self.navigationController?.popPushToVC(ofKind: DashboardViewController.self, pushController: vc)
            }else if status == 2 {
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                self.forceLogout()
            }else{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
            
        }
    }
    
}
extension AccidentLocationDetailsViewController
{
    func accidentDataSubmit(SubmissionData:[String: AnyObject],imageArray:[MultipartInfo], completionHandler: @escaping(_ status: Int, _ message: String) ->()) {
        let apiManager = ServerRequestHandler()
        apiManager.uploadimageWithParamiter(url: API.SubmitAccidentData.url, parm: SubmissionData as Dictionary<String, AnyObject>, imagedate: imageArray, success: { (dict) -> (Void) in
            if let myResult:Dictionary<String, AnyObject> = dict as? Dictionary<String, AnyObject> {
                let message = myResult["message"]
                let status:Int = myResult["status"] as! Int
                completionHandler(status,message as! String)
            }
        }) { (error) in
            completionHandler(1, error as! String)
            print("loader")
        }
    }
    
}


