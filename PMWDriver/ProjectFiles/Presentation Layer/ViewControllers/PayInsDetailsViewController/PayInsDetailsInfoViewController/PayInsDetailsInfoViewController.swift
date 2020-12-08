//
//  PayInsDetailsInfoViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 10/10/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class PayInsDetailsInfoViewController: BaseViewController {
    var model = ShowPayInsDetailsModel()
    var info: PayInsDetails?
    let token =  UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) ?? ""
    let carID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_CAR_NO) ?? ""
    var payIn_id = ""
    @IBOutlet weak var textInfoTotalStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfototalFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoPaidKMStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoPaidKMFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoTotalKMStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoTotalKMFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoNoOfHiringsStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoNoOfHiringsFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoExtraStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoExtraFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoSpeedoStart: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoSpeedoFinish: SkyFloatingLabelTextField!
    @IBOutlet weak var textInfoKMTravel: UITextField!
    @IBOutlet weak var textInfoMeterdFares: UITextField!
    
    
    
    @IBOutlet weak var lableCarNumber: UILabel!
    @IBOutlet weak var lableDtiverType: UILabel!
    @IBOutlet weak var lableShiftName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        textInfoTotalStart.textAlignment  = .center
        textInfototalFinish.textAlignment = .center
        textInfoPaidKMStart.textAlignment = .center
        textInfoPaidKMFinish.textAlignment = .center
        textInfoTotalKMStart.textAlignment = .center
        textInfoTotalKMFinish.textAlignment = .center
        textInfoNoOfHiringsStart.textAlignment = .center
        textInfoNoOfHiringsFinish.textAlignment = .center
        textInfoExtraStart.textAlignment = .center
        textInfoExtraFinish.textAlignment = .center
        textInfoSpeedoStart.textAlignment = .center
        textInfoSpeedoFinish.textAlignment = .center
        self.getPayInsDetailInfoById()
    }

    func getPayInsDetailInfoById() {
        self.showLoading()
        model.detailsOfPayInsInfoData(token: token, payInID: payIn_id) { (status, message) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
            if status == 0 {
               self.populateData()
            }else if status == 2 {
                self.forceLogout()
            }else{
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
        }
       
    }
    
    func populateData() {
        textInfoTotalStart.text = model.modelDetails?.payinInfo?.total_extra_start
        textInfototalFinish.text = model.modelDetails?.payinInfo?.total_extra_end
        textInfoPaidKMStart.text = model.modelDetails?.payinInfo?.paid_km_start
        textInfoPaidKMFinish.text = model.modelDetails?.payinInfo?.paid_km_end
        textInfoTotalKMStart.text = model.modelDetails?.payinInfo?.total_km_start
        textInfoTotalKMFinish.text = model.modelDetails?.payinInfo?.total_km_end
        textInfoNoOfHiringsStart.text = model.modelDetails?.payinInfo?.no_of_hiring_start
        textInfoNoOfHiringsFinish.text = model.modelDetails?.payinInfo?.no_of_hiring_end
        textInfoExtraStart.text = model.modelDetails?.payinInfo?.extra_start
        textInfoExtraFinish.text = model.modelDetails?.payinInfo?.extra_end
        textInfoSpeedoStart.text = model.modelDetails?.payinInfo?.speedo_reading_start
        textInfoSpeedoFinish.text = model.modelDetails?.payinInfo?.speedo_reading_end
        textInfoKMTravel.text = model.modelDetails?.payinInfo?.km_traveled
        textInfoMeterdFares.text = model.modelDetails?.payinInfo?.metered_fares

        self.lableCarNumber.text = "Car Number: \(model.modelDetails?.payinInfo?.car_no ?? "")"
        self.lableDtiverType.text = "Driver Type: \(model.modelDetails?.payinInfo?.driver_type == "1" ? "Sedan" : "Maxi")"
        self.lableShiftName.text = "Shift No: \(model.modelDetails?.payinInfo?.shift_no ?? "")" 
    }
    
    @IBAction func buttonSeeImage(_ sender: ButtionX) {
          showImageZoom(imageName: model.modelDetails?.payinInfo?.payin_reference_doc ?? "", placeHolder:"NoImage" )
    }
    
    @IBAction func buttonSeeImageTwo(_ sender: ButtionX) {
          showImageZoom(imageName: model.modelDetails?.payinInfo?.payin_lifetime_total ?? "", placeHolder:"NoImage" )
    }
    

    @IBAction func buttonShowNextDate(_ sender: UIButton) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "PayInsDetailsDocketViewController") as! PayInsDetailsDocketViewController
        vc.dataMOdel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
