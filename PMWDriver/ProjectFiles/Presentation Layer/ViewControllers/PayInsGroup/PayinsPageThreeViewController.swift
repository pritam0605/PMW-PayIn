//
//  PayinsPageThreeViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 04/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class PayinsPageThreeViewController: BaseViewController {
    var addMoreCell = 1
    
    let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY )
    let userID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID )
    
    
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelTotalPayOut: UILabel!
    @IBOutlet weak var labelTotalPayOut_Header: UILabel!
    var model = PayInsModel()
    
    var payinOneImage:MultipartInfo?
    
    var expenselist:[ExpenseList] = [ExpenseList]()
    var expenseVallue = [String]() //for calculating sum runtime
    
    
    var expenseArray = [Dictionary<String, AnyObject>]()
    var docimagesArray:[MultipartInfo] = [MultipartInfo]()
    var imagesArrayexpense:[MultipartInfo] = [MultipartInfo]()
    var payInsData:[String: String] = [String:String]()
    var alert:selectImageView?
    var selectedImageUploadIndex = -999
    
    
    
    var imageNameArrayExpance = [String]()
    var imageLocalArrayExpance = [UIImage]()
    
    
    var pickerView:UIPickerView?
    var viewpicker:UIView?
    @IBOutlet weak var tablePayins: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.expenseVallue.append("") // original
        self.expenseVallue.insert("", at: 0)
        self.getBlankDictionary()
        self.getExpenseListArrayData()
        self.tablePayins.reloadData()
        self.calculatePayoutTotal(Str: String(0.0))
       
    }
    
    
    
    
    //Mark: - Get Blank Array of Dictionary
    func getBlankDictionary(){
        let counter = self.addMoreCell - expenseArray.count
        for _ in 0 ..< counter {
            var dic = Dictionary<String, AnyObject>()
            dic["expense_id"] = "" as AnyObject
            dic["expense_value"] = "" as AnyObject
            dic["expense_name"] = "" as AnyObject
            dic["expense_images_key"] = "" as AnyObject
             self.expenseArray.insert(dic, at: 0)
             self.imageNameArrayExpance.insert("", at: 0)
             self.imageLocalArrayExpance.insert(UIImage(), at: 0)
          //   self.expenseArray.append(dic) // original
           // self.imageNameArrayExpance.append("") // original
           // self.imageLocalArrayExpance.append(UIImage()) // original
            
           
        }
    }

    
    //Mark : - Open Picker
    @objc fileprivate func pickerUp(_ sender: UIButton){
        if (self.viewpicker == nil) {
            self.viewpicker = UIView(frame: CGRect(x: 0, y: SCREEN_SIZE.height - 200 , width: self.view.frame.size.width, height: 200))
            self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 50 , width: self.view.frame.size.width, height: 150))
            self.pickerView!.delegate = self
            self.pickerView!.dataSource = self
            self.pickerView!.backgroundColor = UIColor.white
            self.pickerView?.tag = 0
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: 50))
            toolBar.backgroundColor  = THEME_ORANGE_COLOR
            toolBar.barStyle = .default
            toolBar.isTranslucent = true
            toolBar.tintColor = THEME_GREEN_COLOR
            toolBar.sizeToFit()
            //Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PayinsPageThreeViewController.doneClick(_:)))
            doneButton.tag = sender.tag
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(PayinsPageThreeViewController.cancelClick))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            self.view.addSubview(self.viewpicker!)
            self.viewpicker!.addSubview(toolBar)
            self.viewpicker!.addSubview(self.pickerView!)
          
        }
    }
    
    
    @objc fileprivate func deleteRow(_ sender: UIButton){
        addMoreCell = addMoreCell-1
        self.expenseArray.remove(at: sender.tag)
        self.expenseVallue.remove(at: sender.tag)
        self.imageLocalArrayExpance.remove(at: sender.tag)
        self.imageNameArrayExpance.remove(at: sender.tag)
        let indexpath = IndexPath(row: sender.tag, section: 0)
        tablePayins.deleteRows(at: [indexpath], with: UITableView.RowAnimation.automatic)
        tablePayins.reloadData()
        self.UpdateTotalAndSubTotal()
    }
    
    
    @objc func doneClick(_ sender: UIBarButtonItem) {
        let index = IndexPath(row: sender.tag, section: 0)
        guard let cell = self.tablePayins.cellForRow(at: index) as? PayinGroupCell else {
            return
        }
        let info: ExpenseList = self.expenselist[pickerView!.tag]
        cell.abc.text = info.expense_name
        cell.dropDownID = info.expense_id
        var dict =  self.expenseArray[sender.tag]
        dict["expense_images_key"] = dict["expense_images_key"] as AnyObject
        dict["expense_id"] = info.expense_id as AnyObject?
        dict["expense_value"] = dict["expense_value"] as AnyObject //new line
        dict["expense_name"] = info.expense_name as AnyObject
        //dict["expense_value"] = "" as AnyObject
        self.expenseArray[sender.tag] = dict
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
    /*
      get expence data for submission
     */
    ///done at 17th dec
    func getDataFromTable() {
       self.imagesArrayexpense.removeAll()
        for i:Int in 0 ..< self.addMoreCell  {
            
            var dict =  self.expenseArray[i]
            dict["expense_id"] = dict["expense_id"] as AnyObject?
            dict["expense_value"] = expenseVallue[i]  as AnyObject
          
             if !imageNameArrayExpance[i].isEmpty  {
                let image:UIImage = imageLocalArrayExpance[i]
                if  let imgData = image.jpegData(compressionQuality: 1) {
                    let imageKey = "expense_images_" + "\(dict["expense_id"]!)" + "_" + imageNameArrayExpance[i]
                    dict["expense_images_key"] = imageKey as AnyObject
                    
                    let imageMultiPart = MultipartInfo(key: imageKey, mimeType: .image_jpeg, data: imgData, name: "\(imageNameArrayExpance[i]).jpg")
                    self.imagesArrayexpense.append(imageMultiPart)
                }
            }
            self.expenseArray[i] = dict
        }
    }
   
    /**
     send data submission for pay-ins
     */
    func SubmitData() {
        getDataFromTable()
        var expanceValueArray = [String]()
        payInsData["total_payin_payout"] = self.labelTotalPayOut.text
        for (index,Object) in self.expenseArray.enumerated() {
            let expenseId = "payin_expense[" + "\(index)" + "][expense_id]"
            let expenseValue = "payin_expense[" + "\(index)" + "][expense_value]"
            let expenseImagesKey = "payin_expense[" + "\(index)" + "][expense_images_key]"
            payInsData[expenseId] = Object["expense_id"] as? String
            payInsData[expenseValue] = Object["expense_value"] as? String
            payInsData[expenseImagesKey] = Object["expense_images_key"] as? String
            
            
            /// done at 16th Dec
            if let expance_value_temp =  Object["expense_value"] as? String, expance_value_temp.count  != 0 {
                expanceValueArray.append(expance_value_temp)
            }
        }
        
        let exparray = self.expenseArray.filter{$0["expense_name"]! as! String != "" }
        
        ///// done at 17th Dec
        guard (expanceValueArray.count == exparray.count)  else {
            UtilityClass.tosta(message: ALERT_MESSAGE_EXPENSE_VALUE_BLANK , duration: 1.0, vc: self)
            return
        }
        
        guard (self.imagesArrayexpense.count == exparray.count)  else {
            UtilityClass.tosta(message: ALERT_MESSAGE_IMAGE_UPLOAD, duration: 1.0, vc: self)
            return
        }
        docimagesArray.append(contentsOf: imagesArrayexpense)
        self.showLoading()
        model.payInsDataSubmit(SubmissionData: payInsData as [String : AnyObject], imageArray: docimagesArray) { (status, message) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
            
            if status == 0{
                self.docimagesArray.removeAll()
                self.expenselist.removeAll()
                self.imagesArrayexpense.removeAll()
                self.expenseVallue.removeAll()
                
                self.showAlert(strTitle: "ALERT", strMessage: ALERT_MESSAGE_PAYIN_LOGOUT)
            }else if status == 2 {
                self.docimagesArray.removeAll()
                self.expenselist.removeAll()
                self.imagesArrayexpense.removeAll()
                self.expenseVallue.removeAll()
                self.showAlert(strTitle: "ALERT", strMessage: message)
            }else{
                DispatchQueue.main.async {
                    self.hideLoading()
                    UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                }
            }
        }
        
    }
    
    func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: PayinsPageTwoViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    

    @IBAction func buttonTapPrevious(_ sender: UIButton) {
        self.navigateToPreviousPage()
    }
    
    func calculatePayoutTotal(Str:String) {
        if let totalExpense = Double(Str), let subTotal = Double(payInsData["subtotal"]!)
        {
            let payInPayOutValue =  subTotal - totalExpense
            labelTotalPayOut.text = String(format: "%.2f",payInPayOutValue)
            labelTotalPayOut_Header.text = payInPayOutValue >= 0 ? "TOTAL PAY IN" : "TOTAL PAY OUT"
            
        }
    }

    @IBAction func buttonTapSubmit(_ sender: UIButton) {
        self.SubmitData()
    }
    
    @IBAction func buttonAddMoreCell(_ sender: UIButton) {
        addMoreCell = addMoreCell + 1
        self.getBlankDictionary()
        let addedRow = addMoreCell - expenseVallue.count
        for _ in 0..<addedRow {
            //expenseVallue.append("")
             self.expenseVallue.insert("", at: 0)
            self.tablePayins.reloadData()
            
        }
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
                self.expenseVallue.remove(at: indexPath.row)
                self.expenseVallue.insert(str, at: indexPath.row)
            }else{
                self.expenseVallue.remove(at: indexPath.row)
                self.expenseVallue.insert("", at: indexPath.row)
            }
            
        }
        var result:Double = 0.0
        for str in expenseVallue {
            if str != ""{
                result +=  Double(str.trimSpace)!
            }
        }
        self.labelTotal.text = String(result)
        self.calculatePayoutTotal(Str: String(result))
        
    }
    
    //MARK: Update Total and SubTotal when Delete Some Row
    // PayIN Page 3
    func UpdateTotalAndSubTotal() {
        var result:Double = 0.0
        for str in expenseVallue {
            if str != ""{
                result +=  Double(str.trimSpace)!
            }
        }
        self.labelTotal.text = String(result)
        self.calculatePayoutTotal(Str: String(result))
    }
    
    func getExpenseListArrayData() {
        if let token = token {
            self.showLoading()
            model.getExpenseList(token: token) { (status, message) in
                self.hideLoading()
                if status == 0{
                    self.expenselist = self.model.expenseList?.expense_list ?? []
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
//Mark: - TableView Extention
extension PayinsPageThreeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addMoreCell
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PayinGroupCell = self.tablePayins.dequeueReusableCell(withIdentifier: "payInsCell") as! PayinGroupCell
         cell.textInput.textAlignment = .center
        if self.expenseArray.count > 0 {
            var dict =  self.expenseArray[indexPath.row]
            cell.abc.text =  dict["expense_name"] as? String
            cell.dropDownID = dict["expense_id"] as? String
            cell.imageName = dict["expense_images_key"] as? String
            
            cell.textInput.text = expenseVallue[indexPath.row]
            cell.imageName = imageNameArrayExpance[indexPath.row]
           // cell.seletedImage =  imageLocalArrayExpance[indexPath.row]
            
            if !imageNameArrayExpance[indexPath.row].isEmpty {
                cell.buttonUploadImage.backgroundColor = THEME_ORANGE_COLOR
                cell.buttonUploadImage.setTitle("UPLOADED", for: .normal)
            }else{
                cell.buttonUploadImage.backgroundColor = THEME_BUTTON_GREEN_COLOR
                cell.buttonUploadImage.setTitle("UPLOAD PHOTO", for: .normal)
            }
        }
        
        
        if (self.expenseArray[indexPath.row]["expense_name"] as? String)!.isEmpty {
            //cell.buttonDelete.isUserInteractionEnabled = false
            cell.textInput.isUserInteractionEnabled = false
            cell.buttonUploadImage.isUserInteractionEnabled = false
        }else{
            //cell.buttonDelete.isUserInteractionEnabled = true
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
extension PayinsPageThreeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.textInputMode?.primaryLanguage !=  "hi" else {
            showAlertMessage(title: "", message: "Please change language to english", vc: self)
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//Mark:- PickerView for dropDown
extension PayinsPageThreeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenselist.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if expenselist.count > 0 {
            let name = expenselist[row]
            return name.expense_name
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

//Mark: -  Add image Custom View
extension PayinsPageThreeViewController: UpdateImageArrayDelegate {
    
    func imageSelectedDone(_ selectedImage: UIImage, imageName: String) {
        let index = IndexPath(row: selectedImageUploadIndex, section: 0) //banate hobe
        guard let cell = self.tablePayins.cellForRow(at: index) as? PayinGroupCell else {
            return
        }
        
        let timeStamp:Int64 = Int64(NSDate().timeIntervalSince1970 * 1000)
        cell.imageName = "\(timeStamp)"
       // cell.seletedImage = selectedImage
        
        if  let imgData = selectedImage.jpegData(compressionQuality: 0.3) {
            let dataToImage: UIImage = UIImage(data: imgData) ?? UIImage()
            self.imageLocalArrayExpance[selectedImageUploadIndex] = dataToImage
            
        }
        
        self.imageNameArrayExpance[selectedImageUploadIndex] = "\(timeStamp)"
       
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


