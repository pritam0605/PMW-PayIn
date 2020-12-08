//
//  PayInsDetailsDocketViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 10/10/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PayInsDetailsDocketViewController: BaseViewController {
    var dataMOdel = ShowPayInsDetailsModel()
    @IBOutlet weak var labelBond: UILabel!
    @IBOutlet weak var labelMTFares: UILabel!
    @IBOutlet weak var labelNoOfHirings: UILabel!
    @IBOutlet weak var textWHL: SkyFloatingLabelTextField!
    @IBOutlet weak var labelWHL: UILabel!
    @IBOutlet weak var tableDocket: UITableView!
    @IBOutlet weak var lableTotal: UILabel!
    @IBOutlet weak var lableLevy: UILabel!
    @IBOutlet weak var labelSubTotal: UILabel!
    @IBOutlet weak var lableCarNumber: UILabel!
    @IBOutlet weak var lableDtiverType: UILabel!
    @IBOutlet weak var lableShiftName: UILabel!
    @IBOutlet weak var labelWHLTitle: UILabel!
    var array = [Docket_details]()
    

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textWHL.textAlignment = .center
        array.removeAll()
        array = dataMOdel.modelDetails?.docket_details ?? [Docket_details]()
        populateMyData()
        
        
        tableDocket.reloadData()
    }
    
    func populateMyData()  {
        self.hidenIfsedan()
        self.lableCarNumber.text = "Car Number: \(dataMOdel.modelDetails?.payinInfo?.car_no ?? "")"
        self.lableDtiverType.text = "Driver Type: \(dataMOdel.modelDetails?.payinInfo?.driver_type == "1" ? "Sedan" : "Maxi")"
        self.lableShiftName.text = "Shift No: \(dataMOdel.modelDetails?.payinInfo?.shift_no ?? "")"

        self.labelBond.text = dataMOdel.modelDetails?.payinInfo?.bond_charges ?? "0"
        self.labelMTFares.text = dataMOdel.modelDetails?.payinInfo?.metered_fares ?? "0"
        self.textWHL.text = dataMOdel.modelDetails?.payinInfo?.no_of_whl ?? "0"
        self.labelWHL.text = dataMOdel.modelDetails?.payinInfo?.total_lifting_fees ?? "0"
        self.lableTotal.text = dataMOdel.modelDetails?.payinInfo?.docket_total_value ?? "0"
        self.lableLevy.text = dataMOdel.modelDetails?.payinInfo?.levy ?? "0"
        self.labelSubTotal.text = dataMOdel.modelDetails?.payinInfo?.subtotal ?? "0"
        let no_Of_hirings = Int(dataMOdel.modelDetails?.payinInfo?.no_of_hiring_end ?? "0")! - Int(dataMOdel.modelDetails?.payinInfo?.no_of_hiring_start ?? "0")!
        self.labelNoOfHirings.text = String(no_Of_hirings)

    }
    
    func hidenIfsedan(){
        self.labelWHLTitle.isHidden = dataMOdel.modelDetails?.payinInfo?.driver_type == "1" ? true : false
        self.textWHL.isHidden = dataMOdel.modelDetails?.payinInfo?.driver_type == "1" ? true : false
        self.labelWHL.isHidden = dataMOdel.modelDetails?.payinInfo?.driver_type == "1" ? true : false
    }
    
    @IBAction func buttonDidTapNext(_ sender: UIButton) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "PayInsDetailsExpenseViewController") as! PayInsDetailsExpenseViewController
        vc.dataModel = dataMOdel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonDidTapPrevious(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func buttonShowPhoto(_ sender: UIButton) {
        showImageZoom(imageName: array[sender.tag].doc_link ?? "", placeHolder:"NoImage" )
    }
    
}

extension PayInsDetailsDocketViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payInsCell") as! PayinGroupCell
        cell.textInput.textAlignment = .center
        cell.abc.text = array[indexPath.row].docket_name
        cell.textInput.text = array[indexPath.row].value
        cell.buttonUploadImage.tag = indexPath.row
        cell.buttonUploadImage.addTarget(self, action: #selector(buttonShowPhoto(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UIDevice.current.userInterfaceIdiom == .pad ? 70 :  50
    }
    
    
    
}


