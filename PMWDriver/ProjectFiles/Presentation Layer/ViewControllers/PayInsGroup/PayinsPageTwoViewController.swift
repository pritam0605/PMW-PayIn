//
//  PayinsPageTwoViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 04/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PayinsPageTwoViewController: BaseViewController {
    var addMore = 1
    var model = PayInsModel()
    @IBOutlet weak var lableNameNoOfHirings: UILabel!
    @IBOutlet weak var tablePayins: UITableView!
    @IBOutlet weak var lableBond: UILabel!
    @IBOutlet weak var lableTotalFares: UILabel!
    @IBOutlet weak var lableNoOfHirings: UILabel!
    @IBOutlet weak var lableLevy: UILabel!
    @IBOutlet weak var lableNoOfWHL: UILabel!
    @IBOutlet weak var lableTotal: UILabel!
    @IBOutlet weak var lableSUbTotal: UILabel!
    @IBOutlet weak var textWhile: SkyFloatingLabelTextField!
    var alert:selectImageView?
    
    var doketsVallue = [String]() //for calculating sum runtime
    var docketArray = [Dictionary<String, AnyObject>]()
    var payInsData:[String: String] = [String:String]()
    var doclist:[DocketList] = [DocketList]()
    var imagesArray:[MultipartInfo] = [MultipartInfo]()
    
    
    let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY )
    let userID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID )
    let shiftID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_SHIFT_ID) ?? ""
    let driverType =   UserDefaults.standard.string(forKey: USER_DEFAULT_DRIVER_TYPE) ?? "1"
    
    var payinOneImage:MultipartInfo?
    var payinTwoImage:MultipartInfo?
    
    var imageNameArray = [String]()
    var imageLocalArray = [UIImage]()
    
    var selectedImageUploadIndex = -999
    var lableNoOf:Int = 0
    var WHLLiftingFees = 0.0
    var pickerView:UIPickerView?
    var viewpicker:UIView?
    var driverCommission:Double = 0.0
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //doketsVallue.append("") // original
         doketsVallue.insert("", at: 0)
        self.textWhile.textAlignment = .center
        self.tablePayins.rowHeight = UITableView.automaticDimension
        self.tablePayins.estimatedRowHeight = 44.0
        self.tablePayins.reloadData()
        self.hidenIfsedan()
        lableTotalFares.text = payInsData["metered_fares"]
        lableNoOf = Int(payInsData["no_of_hiring_end"]!)! - Int(payInsData["no_of_hiring_start"]!)!
        payInsData["device_type"] = "1"
        payInsData["driver_id"] = userID
        payInsData["shift_id"] = shiftID
        payInsData["token_key"] = token
        self.getBlankDictionary()
        lableNoOfHirings.text = String(lableNoOf)
        self.getDocListArrayData() // Api Call
        self.getPayinsGeneralInfo() // Api Call
    }
    
    func hidenIfsedan(){
        self.lableNameNoOfHirings.isHidden = driverType == "1" ? true : false
        self.textWhile.isHidden = driverType == "1" ? true : false
        self.lableNoOfWHL.isHidden = driverType == "1" ? true : false
    }
    
    
    //Mark: - Get Blank Array of Dictionary
    func getBlankDictionary()  {
        let counter = self.addMore - docketArray.count
        for _ in 0 ..< counter {
            var dic = Dictionary<String, AnyObject>()
            dic["docket_id"] = "" as AnyObject
            dic["docket_value"] = "" as AnyObject
            dic["docket_name"] = "" as AnyObject
            dic["docket_images_key"] = "" as AnyObject
            
            self.docketArray.insert(dic, at: 0)
            self.imageNameArray.insert("", at: 0)
              self.imageLocalArray.insert(UIImage(), at: 0)
           // self.docketArray.append(dic) // original
           // self.imageNameArray.append("") // original
            //self.imageLocalArray.append(UIImage()) // original
           
            
        }
    }
    
  
    
    
    func calculateNoOfWHL(str: String){
        if driverType == "2" {
            if str != "" {
                let result:Double = (Double(str)!) * (Double(self.model.payInInfo?.resultData?.lifting_fees ?? "0.0")!)
                lableNoOfWHL.text = String(format: "%.2f",result)
            }
        }
    }
    
    func calculateValueOfSubtotal() {
        //{1=>’Sedan’,2=>’Maxi’}

        if driverType == "1" {
            if let totalMF = Double(self.lableTotalFares.text!) , let bond = Double(self.lableBond.text!), let levy = Double(self.lableLevy.text!),  let totalDoket = Double(lableTotal.text!) {
                //                let result:Double = (totalMF * (self.driverCommission/100) + (levy * Double(lableNoOf)) - bond - totalDoket)
                
                let result:Double = (totalMF * (self.driverCommission/100) + (levy) + bond - totalDoket)
                self.lableSUbTotal.text = String(format: "%.2f", result)
            }
        }else{ //2=>’Maxi’
            // if let totalMF = Double(self.lableTotalFares.text!) , let bond = Double(self.lableBond.text!), let levy = Double(self.model.payInInfo?.resultData?.levy_rate ?? "0.0"),  let totalDoket = Double(lableTotal.text!) , let totalLifting = Double(lableNoOfWHL.text!)
            
            if let totalMF = Double(self.lableTotalFares.text!) , let bond = Double(self.lableBond.text!), let levy = Double(self.lableLevy.text!),  let totalDoket = Double(lableTotal.text!) , let totalLifting = Double(lableNoOfWHL.text!) {
                
                //                let result:Double = (totalMF * (self.driverCommission/100) + (levy * Double(lableNoOf)) - bond - totalDoket - totalLifting)
                
                let result:Double = (totalMF * (self.driverCommission/100) + levy + bond  + totalLifting - totalDoket)
                self.lableSUbTotal.text = String(format: "%.2f", result)
            }
        }
    }
    
    func navigateToNextPage() {
        
        payInsData["bond_charges"] = self.lableBond.text
        payInsData["subtotal"] = self.lableSUbTotal.text
        payInsData["levy"] = self.lableLevy.text
        // payInsData["no_of_whl"] = self.lableNoOfWHL.text
        payInsData["no_of_whl"] = self.textWhile.text ?? "0"
        getDataFromTable()
        var docValueArray = [String]()
        for (index,Object) in self.docketArray.enumerated() {
            let docketId = "payin_dockets[" + "\(index)" + "][docket_id]"
            let docketValue = "payin_dockets[" + "\(index)" + "][docket_value]"
            let docketImagesKey = "payin_dockets[" + "\(index)" + "][docket_images_key]"
            
            payInsData[docketId] = Object["docket_id"] as? String
            payInsData[docketValue] = Object["docket_value"] as? String
            payInsData[docketImagesKey] = Object["docket_images_key"] as? String
            
            ///// done at 16th Dec
            if let docket_value_temp =  Object["docket_value"] as? String, docket_value_temp.count  != 0
            {
                docValueArray.append(docket_value_temp)
            }
        }
        
        ///// done at 16th Dec
        //let docValueArray = docketArray.filter{$0["docket_value"]! as! String != "" }
        let docArray = docketArray.filter{$0["docket_name"]! as! String != "" }
        guard (docValueArray.count == docArray.count)  else {
            UtilityClass.tosta(message: ALERT_MESSAGE_DOCKET_VALUE_BLANK , duration: 1.0, vc: self)
            return
        }
        guard (self.imagesArray.count == docArray.count)  else {
            UtilityClass.tosta(message: ALERT_MESSAGE_IMAGE_UPLOAD, duration: 1.0, vc: self)
            return
        }
        
        self.imagesArray.append(self.payinOneImage!)
        self.imagesArray.append(self.payinTwoImage!) // added on 17th december
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayinsPageThreeViewController") as! PayinsPageThreeViewController
        vc.payInsData = payInsData
        vc.docimagesArray = imagesArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //Mark: - Back to previous page
    func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: PayinsPageOneViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    //Mark: - Get Data from table
    /*
         get docket data for submission
     */
    ///// done at 16th Dec
    func getDataFromTable() {
        self.imagesArray.removeAll()
        for i:Int in 0 ..< self.addMore  {
            
            var dict =  self.docketArray[i]
            dict["docket_id"] = dict["docket_id"] as AnyObject?
            dict["docket_value"] = doketsVallue[i]  as AnyObject 
            
             if !imageNameArray[i].isEmpty  {
                let image:UIImage = imageLocalArray[i]
                if  let imgData = image.jpegData(compressionQuality: 1) {
                    let imageKey = "docket_images_" + "\(dict["docket_id"]!)" + "_" + imageNameArray[i]
                    dict["docket_images_key"] = imageKey as AnyObject
                    
                    let imageMultiPart = MultipartInfo(key: imageKey, mimeType: .image_jpeg, data: imgData, name: "\(imageNameArray[i]).jpg")
                    self.imagesArray.append(imageMultiPart)
                }
            }
            self.docketArray[i] = dict
        }
    }
    

    

    @objc fileprivate func pickerUp(_ sender: UIButton){
        if (self.viewpicker == nil) {
        self.viewpicker = UIView(frame: CGRect(x: 0, y: SCREEN_SIZE.height - 200 , width: self.view.frame.size.width, height: 200))
        self.pickerView?.tag = 0
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 50 , width: self.view.frame.size.width, height: 150))
        self.pickerView!.delegate = self
        self.pickerView!.dataSource = self
        self.pickerView!.backgroundColor = UIColor.white
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: 50))
        toolBar.backgroundColor  = THEME_ORANGE_COLOR
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = THEME_GREEN_COLOR
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PayinsPageTwoViewController.doneClick(_:)))
        doneButton.tag = sender.tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PayinsPageTwoViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.view.addSubview(self.viewpicker!)
        self.viewpicker!.addSubview(toolBar)
        self.viewpicker!.addSubview(self.pickerView!)
        }

    }
    
    @objc fileprivate func deleteRow(_ sender: UIButton){
        addMore = addMore-1
        self.docketArray.remove(at: sender.tag)
        self.doketsVallue.remove(at: sender.tag)
        self.imageLocalArray.remove(at: sender.tag)
        self.imageNameArray.remove(at: sender.tag)
        let indexpath = IndexPath(row: sender.tag, section: 0)
        tablePayins.deleteRows(at: [indexpath], with: UITableView.RowAnimation.automatic)
        tablePayins.reloadData()
        self.UpdateTotalAndSubTotal()
       
     
    }
    
    
    
    @objc func doneClick(_ sender: UIBarButtonItem) {
        let index = IndexPath(row: sender.tag, section: 0) //banate hobe
        guard let cell = self.tablePayins.cellForRow(at: index) as? PayinGroupCell else {
            return
        }
        let info: DocketList = self.doclist[pickerView!.tag]
        cell.abc.text = info.docket_name
        cell.dropDownID = info.docket_id
        
        var dic = Dictionary<String, AnyObject>()
        dic["docket_id"] = info.docket_id as AnyObject
        dic["docket_name"] = info.docket_name as AnyObject
        
        dic["docket_value"] =  dic["docket_value"] as AnyObject
        //dic["docket_images_key"] = "" as AnyObject
        dic["docket_images_key"] = dic["docket_images_key"] as AnyObject
        self.docketArray[sender.tag] = dic
        
        self.view.endEditing(true)
        self.tablePayins.reloadData() //new line
        guard self.viewpicker != nil else {
            return
        }
        self.viewpicker!.removeFromSuperview()
        self.viewpicker = nil
    }
    
    
    @objc func cancelClick() {
        self.view.endEditing(true)
        guard self.viewpicker != nil else {
            return
        }
        self.viewpicker!.removeFromSuperview()
        self.viewpicker = nil

    }
    
    
    @IBAction func buttonTapPrevious(_ sender: UIButton) {
        self.navigateToPreviousPage()
    }
    
    @IBAction func buttonTapNext(_ sender: UIButton) {
        self.navigateToNextPage()
    }
    
    @IBAction func buttonAddMoreCell(_ sender: UIButton) {
        addMore = addMore + 1
        self.getBlankDictionary()
        
        let addedRow = addMore - doketsVallue.count
        for _ in 0..<addedRow {
           // doketsVallue.append("") // Original
             doketsVallue.insert("", at: 0)
        }
        self.tablePayins.reloadData()
    }
    
    @objc fileprivate func textFieldValueChanged(_ txt:UITextField) {
        guard let cell:PayinGroupCell = txt.superview?.superviewOfClassType(PayinGroupCell.self) as? PayinGroupCell  else {
            return
        }
        guard let indexPath = tablePayins.indexPath(for: cell) else {
            return
        }
       
        
        
        if indexPath.section == 0 {
            if let str = txt.text, str.count > 0 {
                self.doketsVallue.remove(at: indexPath.row)
                self.doketsVallue.insert(str, at: indexPath.row)
            }else{
                self.doketsVallue.remove(at: indexPath.row)
                self.doketsVallue.insert("", at: indexPath.row)
            }
          
        }
        var result:Double = 0.0
        for str in doketsVallue {
            if str != ""{
                 result +=  Double(str.trimSpace)!
            }
        }
        self.lableTotal.text = String(result)
        self.calculateValueOfSubtotal()

    }
    
    //MARK: Update Total and SubTotal when Delete Some Row
    // PayIN Page 2
    func UpdateTotalAndSubTotal() {
        var result:Double = 0.0
        for str in doketsVallue {
            if str != ""{
                 result +=  Double(str.trimSpace)!
            }
        }
        self.lableTotal.text = String(result)
        self.calculateValueOfSubtotal()
    }
    
    
}
//Mark: - TableView Extention
extension PayinsPageTwoViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("addmore",addMore)
        return addMore
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PayinGroupCell = self.tablePayins.dequeueReusableCell(withIdentifier: "payInsCell") as! PayinGroupCell
        cell.textInput.textAlignment = .center
        
        if self.docketArray.count > 0 {
            let dict =  self.docketArray[indexPath.row]
            cell.abc.text =  dict["docket_name"] as? String
            cell.dropDownID =  dict["docket_id"] as? String
            cell.imageName = dict["docket_images_key"] as? String
            cell.textInput.text = doketsVallue[indexPath.row]
            cell.imageName = imageNameArray[indexPath.row]
            //cell.seletedImage =  imageLocalArray[indexPath.row] // pritam just
            if !imageNameArray[indexPath.row].isEmpty {
                cell.buttonUploadImage.backgroundColor = THEME_ORANGE_COLOR
                cell.buttonUploadImage.setTitle("UPLOADED", for: .normal)
            }else{
                cell.buttonUploadImage.backgroundColor = THEME_BUTTON_GREEN_COLOR
                cell.buttonUploadImage.setTitle("UPLOAD PHOTO", for: .normal)
            }
            
        }
        
        
        if (self.docketArray[indexPath.row]["docket_name"] as? String)!.isEmpty {
            //            cell.buttonDelete.isUserInteractionEnabled = false
            cell.textInput.isUserInteractionEnabled = false
            cell.buttonUploadImage.isUserInteractionEnabled = false
        }else{
            //            cell.buttonDelete.isUserInteractionEnabled = true
            cell.textInput.isUserInteractionEnabled = true
            cell.buttonUploadImage.isUserInteractionEnabled = true
        }
        cell.buttonDropDown.tag = indexPath.row
        cell.buttonUploadImage.tag = indexPath.row
        cell.buttonDelete.tag = indexPath.row
        // customImageSelectPopUp
        cell.textInput.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        cell.buttonUploadImage.addTarget(self, action: #selector(self.customImageSelectPopUp(_:)), for: .touchUpInside)
        cell.buttonDropDown.addTarget(self, action: #selector(self.pickerUp(_:)), for: .touchUpInside)
        cell.buttonDelete.addTarget(self, action: #selector(self.deleteRow(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 65 :  45
    }
    
    
}
extension PayinsPageTwoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.textInputMode?.primaryLanguage !=  "hi" else {
            showAlertMessage(title: "", message: "Please change language to english", vc: self)
            return false
        }
        return true
    }

  
    
    @IBAction func textFieldEditingDidChange(_ sender: SkyFloatingLabelTextField) {
       if sender.text != "" {
        let NoOfWHL = (sender.text! as NSString).doubleValue * WHLLiftingFees
        lableNoOfWHL.text = "\(NoOfWHL)"
        self.calculateValueOfSubtotal()
       }else{
        let NoOfWHL = 0.0 * WHLLiftingFees
        lableNoOfWHL.text = "\(NoOfWHL)"
        self.calculateValueOfSubtotal()
        }
        
    }
}

extension PayinsPageTwoViewController {
    func getPayinsGeneralInfo() {
        if let token = token, let driverID = userID{
            self.showLoading()
            model.getPayInInfo(token: token, driver: driverID) { (status, message) in
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                if status == 0{
                    self.lableBond.text = "\(self.model.payInInfo?.resultData?.bond_value ?? "0.0")"
                    let  levy: Double = Double(self.model.payInInfo?.resultData?.levy_rate ?? "0.0")! *  Double(self.lableNoOf)
                    self.lableLevy.text =  String(format: "%.2f",levy)
                    self.driverCommission = Double(self.model.payInInfo?.resultData?.commission_rate_driver ?? "0.0")!
                    print("driverCommission",  self.driverCommission)
                    if  let amountValue = Double(self.model.payInInfo?.resultData?.lifting_fees ?? "0")  {
                        self.WHLLiftingFees = amountValue
                        self.calculateNoOfWHL(str: self.textWhile.text!)
                    }
                    self.calculateValueOfSubtotal()
                }else if status == 2 {
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
    }
    
    
    func getDocListArrayData() {
        if let token = token {
            self.showLoading()
            model.getDocketList(token: token) { (status, message) in
                self.hideLoading()
                if status == 0{
                    self.doclist = self.model.docketList?.docket_list ?? []
                   
                    DispatchQueue.main.async {
                        self.tablePayins.reloadData()
                    }
                    
                }else if status == 2 {
                    UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                    self.forceLogout()
                }else{
                    UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                }
            }
        }
    }
}


extension PayinsPageTwoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return doclist.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if doclist.count > 0 {
            let name = doclist[row]
            return name.docket_name
        } else{
            return ""
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerView!.tag = row
    }
    
    
}

extension PayinsPageTwoViewController: UpdateImageArrayDelegate {
    func imageSelectedDone(_ selectedImage: UIImage, imageName: String) {
        let index = IndexPath(row: selectedImageUploadIndex, section: 0) //banate hobe
        guard let cell = self.tablePayins.cellForRow(at: index) as? PayinGroupCell else {
            return
        }
        let timeStamp:Int64 = Int64(NSDate().timeIntervalSince1970 * 1000)
        self.imageNameArray[selectedImageUploadIndex] = "\(timeStamp)"
       // self.imageLocalArray[selectedImageUploadIndex] = selectedImage
        
        
        if  let imgData = selectedImage.jpegData(compressionQuality: 0.2) {
            let dataToImage: UIImage = UIImage(data: imgData) ?? UIImage()
            self.imageLocalArray[selectedImageUploadIndex] = dataToImage
            
        }
        
        
        
        cell.imageName = "\(timeStamp)"
      //  cell.seletedImage = selectedImage
        cell.buttonUploadImage.setTitle("UPLOADED", for: .normal)
        cell.buttonUploadImage.backgroundColor = THEME_ORANGE_COLOR
        if self.alert != nil{
            self.alert = nil
        }
    }
    
    func cancelButtonPress() {
        print("cancelButtonPress")
        if self.alert != nil{
            self.alert = nil
        }
    }
    
    
    @objc func customImageSelectPopUp(_ sender: UIButton)  {
        self.alert = selectImageView()
        selectedImageUploadIndex = sender.tag
        alert?.frame = UIScreen.main.bounds
        alert?.CommonInit()
        //        DispatchQueue.main.async {
        //            self.alert.selectedImage.makeRound()
        //        }
        alert?.delegate = self
        self.view.addSubview(alert!)
    }
}

