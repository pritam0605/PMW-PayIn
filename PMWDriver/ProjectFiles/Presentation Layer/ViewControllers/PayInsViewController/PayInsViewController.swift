//
//  PayInsViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 02/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class PayInsViewController: BaseViewController {
    let model = PayInsModel()
    @IBOutlet weak var tablePayInsReport: UITableView!
    let token =  UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY)
    let driver =  UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID)
    var modelData:[PayinListData] = [PayinListData]()
    var isFullVersionpayIns = false
    @IBOutlet weak var buttonAddNewPayins: UIButton!
    @IBOutlet weak var labelNodataFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.labelNodataFound.isHidden = true
//        let shiftStatus :Int = UserDefaults.standard.value(forKey: USER_DEFAULT_USER_SHIFT_STATUS) as! Int
//        buttonAddNewPayins.isHidden = shiftStatus == 2 ? false : true
        
        self.callPayInList()
        tablePayInsReport.rowHeight =  UITableView.automaticDimension
        tablePayInsReport.estimatedRowHeight = 100
        tablePayInsReport.reloadData()
    }
    
    
    
    

    @IBAction func buttonClickAddNewPayins(_ sender: UIButton) {
        let shiftStatus :Int = UserDefaults.standard.value(forKey: USER_DEFAULT_USER_SHIFT_STATUS) as! Int
        if shiftStatus == 2 {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayinsPageOneViewController") as! PayinsPageOneViewController
        self.navigationController?.pushViewController(vc, animated: true)
        }else{
            showAlertMessage(title: "Ooops", message: "You don't have any shift to submit payin .", vc: self)
  
        }
    }
    
    func callPayInList() {
        self.showLoading()
        model.listOfPayInsData(token: token ?? "", driver: driver ?? "") { (status, message) in
            self.hideLoading()
            if status == 0 {
                self.modelData = self.model.payInsListResponse?.payInListData ?? [PayinListData]()
                DispatchQueue.main.async {
                    self.labelNodataFound.isHidden = self.modelData.count > 0 ? true : false
                    

                   self.tablePayInsReport.reloadData()
                }

            }else if status == 2 {
               self.forceLogout()
            }else{
               UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
           
        }
    }
    
}
extension PayInsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommonTableViewCell = self.tablePayInsReport.dequeueReusableCell(withIdentifier: "payInsCell") as! CommonTableViewCell
        if modelData.count > 0 {
            cell.lableShiftID.text = modelData[indexPath.row].shift_no
            cell.lableTransctionID.text = modelData[indexPath.row].transactionId
            cell.lableCarNo.text = modelData[indexPath.row].carNo
            cell.lablePayoutAmmount.text = modelData[indexPath.row].totalPayinPayout
            cell.lableDateTime.text = modelData[indexPath.row].createdTime
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "PayInsDetailsInfoViewController") as! PayInsDetailsInfoViewController
        vc.payIn_id = modelData[indexPath.row].transactionId ?? ""
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
//    if isFullVersionMenu {
//    let vc = (self.storyboard?.instantiateViewController(withIdentifier:"PayInsViewController") as! PayInsViewController)
//    self.navigationController?.pushViewController(vc, animated: true)
//    }else{
//    UtilityClass.tostaOnWindow(message: "Currently you don't have any shift", duration: 2.0, vc: self)
//    dismiss(animated: true, completion: nil)
//    }
    
}
