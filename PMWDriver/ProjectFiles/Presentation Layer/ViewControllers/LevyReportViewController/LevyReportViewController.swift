//
//  LevyReportViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 02/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import  SkyFloatingLabelTextField

class LevyReportViewController: BaseViewController {
    var model =   LevyModelClass()
    var arrData = [LevyList]()
    let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) ?? ""
    let Userid = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID) ?? ""
    
    @IBOutlet weak var textFromDate: SkyFloatingLabelTextField!
    @IBOutlet weak var textTodate: SkyFloatingLabelTextField!
    @IBOutlet weak var tableLavyReport: UITableView!
    var selectedtag = -99
    @objc var pickerLevy = UIDatePicker()
    let datePickerViewLevy = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateTableList()
        tableLavyReport.reloadData()
        showDatePicker()
        self.datePickerViewLevy.isHidden = true

    }
    
    func showDatePicker(){
        pickerLevy.datePickerMode = .date
        pickerLevy.backgroundColor = UIColor.white
        pickerLevy.maximumDate = Date()
        //ToolBar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40));
       
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerLevy));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePickerLevy));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

        datePickerViewLevy.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 240, width: self.view.frame.width, height: 240)
        pickerLevy.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: 200)
        self.datePickerViewLevy.addSubview(toolbar)
        self.datePickerViewLevy.addSubview(pickerLevy)
        self.view.addSubview(datePickerViewLevy)
    }

    
    @objc func donedatePickerLevy(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if selectedtag == 101{
            textFromDate.text = formatter.string(from: pickerLevy.date)
        }
        if  selectedtag == 102 {
            textTodate.text = formatter.string(from: pickerLevy.date)
        }
        self.datePickerViewLevy.isHidden = true
    }
    
    @objc func cancelDatePickerLevy(){
      self.pickerLevy = UIDatePicker()
       self.datePickerViewLevy.isHidden = true
    }
    
    

    @IBAction func buttonSelectFromDate(_ sender: UIButton) {
        selectedtag = sender.tag
       self.datePickerViewLevy.isHidden = false
        
        
    }
    
    @IBAction func buttonSelectToDate(_ sender: UIButton) {
        selectedtag = sender.tag
        self.datePickerViewLevy.isHidden = false
        
    }
    
    func validation()  {
        if (self.textTodate.text != nil && self.textFromDate.text != nil){
            let dateA:Date = (self.textFromDate.text?.toDate(withFormate: DATE_FORMETE)!)!
            let dateB:Date = (self.textTodate.text?.toDate(withFormate: DATE_FORMETE))!
            if  dateA.compare(dateB) == .orderedAscending{//"Date A is earlier than date B"
                self.populateTableList()
            }else{
                UtilityClass.tosta(message: "From will be earlier than TO date", duration: 0.5, vc: self)
            }
        }else{
             UtilityClass.tosta(message: "Please select both dates", duration: 0.5, vc: self)
        }
    }
    
    
    func populateTableList() {
        self.showLoading()
        model.getLevyListDatas(driverId: Userid, startDate: self.textFromDate.text ?? "", endDate: self.textTodate.text ?? "", token: token) { (status, message) in
            self.hideLoading()
            if status == 0 {
               // UtilityClass.tosta(message: message, duration: 0.5, vc: self) //tester issue
                self.arrData = self.model.levyModel?.levy_list ?? []
                DispatchQueue.main.async {
                    self.tableLavyReport.reloadData()
                }
            }else if status == 2{
                self.textTodate.text = ""
                self.textFromDate.text = ""
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
    
    
    @IBAction func buttonSearch(_ sender: UIButton) {
        if textFromDate.text == "" || textTodate.text == ""   {
            UtilityClass.tosta(message: "Please select both dates", duration: 0.5, vc: self)
            return
        }else{
            let dateTo = textTodate.text!.toDate(withFormate: "dd/MM/yyyy")
            let dateFrom = textFromDate.text!.toDate(withFormate: "dd/MM/yyyy")
            if (dateFrom! < dateTo!) || ( dateFrom == dateTo) {
                 self.populateTableList()
                print("Success")
            }else{
                 UtilityClass.tosta(message: "From will be earlier than TO date", duration: 0.5, vc: self)
                self.textTodate.text = ""
                self.textFromDate.text = ""
                print("Error")
            }
        }
        
        
    }
    
   
    
}

extension LevyReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommonTableViewCell = self.tableLavyReport.dequeueReusableCell(withIdentifier: "leavyCell") as! CommonTableViewCell
        if self.arrData.count > 0 {
            cell.populateLevyReportCellDate(info: self.arrData[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 80 :  60
        
        
    }
     
}


