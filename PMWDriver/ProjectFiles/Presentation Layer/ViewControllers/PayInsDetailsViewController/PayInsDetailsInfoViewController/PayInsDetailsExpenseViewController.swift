//
//  PayInsDetailsExpenseViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 10/10/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class PayInsDetailsExpenseViewController: BaseViewController {
    var dataModel = ShowPayInsDetailsModel()
    @IBOutlet weak var lableTotal: UILabel!
    @IBOutlet weak var lableTotalPayOut: UILabel!
    @IBOutlet weak var tableExpence: UITableView!
    @IBOutlet weak var lableCarNumber: UILabel!
    @IBOutlet weak var lableDtiverType: UILabel!
    @IBOutlet weak var lableShiftName: UILabel!
    
    @IBOutlet weak var lablePayInPayOut: UILabel!
    
    var  arrayExpance = [Expense_details]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayExpance.removeAll()
        arrayExpance = dataModel.modelDetails?.expense_details ?? [Expense_details]()
        self.lableCarNumber.text = "Car Number: \(dataModel.modelDetails?.payinInfo?.car_no ?? "")"
        self.lableDtiverType.text = "Driver Type: \(dataModel.modelDetails?.payinInfo?.driver_type == "1" ? "Sedan" : "Maxi")"
        self.lableShiftName.text = "Shift No: \(dataModel.modelDetails?.payinInfo?.shift_no ?? "")"
        let payout = Double(dataModel.modelDetails?.payinInfo?.total_payin_payout ?? "0.0")!
        lablePayInPayOut.text =    payout >= 0.0 ? "TOTAL PAY IN" : "TOTAL PAY OUT"
        self.lableTotalPayOut.text = dataModel.modelDetails?.payinInfo?.total_payin_payout ?? ""
        self.lableTotal.text = dataModel.modelDetails?.payinInfo?.expense_total_value ?? ""
        tableExpence.reloadData()
    }
 
    
    @IBAction func buttonClickPrivious(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonShowPhoto(_ sender: UIButton) {
        showImageZoom(imageName: arrayExpance[sender.tag].doc_link ?? "", placeHolder:"NoImage" )
    }
}

extension PayInsDetailsExpenseViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayExpance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payInsCell") as! PayinGroupCell
        cell.abc.text = arrayExpance[indexPath.row].expense_name
        cell.textInput.textAlignment = .center
        cell.textInput.text = arrayExpance[indexPath.row].value
        cell.buttonUploadImage.tag = indexPath.row
        cell.buttonUploadImage.addTarget(self, action: #selector(buttonShowPhoto(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UIDevice.current.userInterfaceIdiom == .pad ? 70 :  50
    }
    
}
