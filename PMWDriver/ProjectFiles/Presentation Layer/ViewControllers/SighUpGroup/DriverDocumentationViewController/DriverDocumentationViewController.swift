//
//  DriverDocumentationViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import Toast_Swift
import SDWebImage


class DriverDocumentationViewController: BaseViewController, UpdateImageArrayDelegate {
    var modelDocuments = SignUpModel()
    var isUseAsProfile:Bool?
    var profileImage:String?
    var signUpStringInfo = Dictionary<String, String>()
    @IBOutlet weak var documentationTable: UITableView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewSignUp: UIView!
    @IBOutlet weak var imageDriver: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!

    var imageIndex:Int = -999
    
    var imageArray:[MultipartInfo] = [MultipartInfo]()
    var statusFlag:[Bool] = [true,true,true,true,true,true] //dekhabe na
    let documentsName = ["Driver Certificate","Driving License","Login Card","Photo Id", "Upload Signature"]
    let documentsImageArray = ["Driver_certificate.png","Driving_license.png", "login_card.png","Paper_dc.png", "Signature.png"]
    var alert:selectImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if (isUseAsProfile!){
            viewProfile.isHidden = false
            viewSignUp.isHidden = true
            if profileImage != "" {
                statusFlag[0] = false
                setImageInImageView(imageName: profileImage ?? "", placeHolderImage: "Driver_photo", imageView: self.imageDriver)
            }
          self.populateStatusArray() 

        }else{
            viewProfile.isHidden = true
            viewSignUp.isHidden = false
        }
        print("DriverDocumentationViewController",signUpStringInfo)
    }
    
    func populateStatusArray() {
        statusFlag[1] =   modelDocuments.regModel?.personal_info?.driver_certificate_flag  == 0 ? true : false
        statusFlag[2] =   modelDocuments.regModel?.personal_info?.driving_license_flag  == 0 ? true : false
        statusFlag[3] =   modelDocuments.regModel?.personal_info?.login_card_flag  == 0 ? true : false
        statusFlag[4] =   modelDocuments.regModel?.personal_info?.paper_dc_flag  == 0 ? true : false
        statusFlag[5] =   modelDocuments.regModel?.personal_info?.signature_flag  == 0 ? true : false
        if  self.isAddressChange(){
             statusFlag[1] = true
             statusFlag[2] = true
            
        }
        self.dcExpDateChange()
        self.dLExpDateChange()
        self.documentationTable.reloadData()
    }

    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            self.imageDriver.makeRound()
        }
    }
    
    enum SELECT_IMAGE_KEYS:Int {
        case PROFILE_IMAGE = 0
        case DRIVER_CERTIFICATE
        case DRIVING_LICENSE
        case LOGIN_CARD
        case PAPER_DC
        case UPLOAD_SIGNATURE
        func getImageKeys() -> String {
            switch self {
            case .PROFILE_IMAGE:
                return "profile_photo"
            case .DRIVER_CERTIFICATE:
                return "driver_certificate[]"
            case .DRIVING_LICENSE:
                return "driving_license[]"
            case .LOGIN_CARD:
                return "login_card[]"
            case .PAPER_DC:
                return "paper_dc[]"
            case .UPLOAD_SIGNATURE:
                return "signature[]"
        
            }
        }
        
        
    }
    
    @IBAction func buttonClickUploadImage(_ sender: UIButton){
        self.imageIndex =  0
        self.customImageSelectPopUp()
    }
    
    func customImageSelectPopUp()  {
        self.alert = selectImageView()
        alert?.frame = UIScreen.main.bounds
        alert?.CommonInit()
      
        alert?.delegate = self
        self.view.addSubview(alert!)
        
    }
    
    //Mark : - test delegate
    func imageSelectedDone(_ selectedImage: UIImage, imageName: String) {
        guard let imgData = selectedImage.jpegData(compressionQuality: 0.4) else { return  }
        let imageKey = SELECT_IMAGE_KEYS.init(rawValue: imageIndex)
        let imageMultiPart = MultipartInfo(key: imageKey?.getImageKeys(), mimeType: .image_jpeg, data: imgData, name: imageName)
        
        if  imageIndex >= 0 {//default index= -999
            //// chaged 24.12.19
            if( self.imageArray.count != 0){
                if self.imageArray.filter({$0.strKey == imageMultiPart.strKey}).count == 0{
                    self.imageArray.append(imageMultiPart)
                }else{
                    let index = self.imageArray.enumerated().filter({
                        $0.element.strKey == imageMultiPart.strKey
                    }).map({ $0.offset })
                    
                    
                    if(index.count == 0){
                        self.imageArray.append(imageMultiPart)
                    }else{
                        self.imageArray[index[0]] = imageMultiPart
                    }
                }
            }else{
                self.imageArray.append(imageMultiPart)
            }
            if imageIndex == 0 {
                self.imageDriver.image = selectedImage
                self.statusFlag[imageIndex] = false // index 0
            }else  {
                //create  cell
                self.statusFlag[imageIndex] = false // dekhabe tick
                self.documentationTable.reloadData()
            }
        }
        print("my multipart array number",imageArray.count)
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
    
    @IBAction func buttonClickBack(_ sender: UIButton) {
        self.navigateToPreviousPage()
    }
    
    func canSubmitDate() -> Bool {
        for check in self.statusFlag {
            if check == true{
                return false
            }
        }
        return true
    }
    
    @objc func buttonSubmitData()  {// next will check with status array
        //        guard  self.isUseAsProfile! ? true : (self.imageArray.count == (documentsName.count + 1))  else { //old
        //            UtilityClass.tosta(message: ALERT_MESSAGE_IMAGE_UPLOAD, duration: 1.0, vc: self)
        //            return
        //        }
        
        guard canSubmitDate()  else { // check with status array
            UtilityClass.tosta(message: ALERT_MESSAGE_IMAGE_UPLOAD, duration: 1.0, vc: self)
            return
        }
        
        let apiManager = ServerRequestHandler()
        
        if isUseAsProfile! {
            let userID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID) ?? ""
            let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) ?? ""
            signUpStringInfo["token_key"] =  token
            signUpStringInfo["user_id"] = userID
            signUpStringInfo["device_type"] = "1"
        }
        print("signUpStringInfo  ---->", signUpStringInfo)
        self.showLoading()
        apiManager.uploadimageWithParamiter(url: isUseAsProfile! ? API.UpdateProfile.url :  API.signUp.url, parm: signUpStringInfo as Dictionary<String, AnyObject>, imagedate: imageArray, success: { (dict) -> (Void) in
            DispatchQueue.main.async {
                self.hideLoading()
            }
            if let myResult:Dictionary<String, AnyObject> = dict as? Dictionary<String, AnyObject> {
                
                if  let status: Int = myResult["status"] as? Int {
                    let message = myResult["message"]
                    if let driver_details = myResult["driver_details"] as? [String : String]   {
                        if let image_pfoto =  driver_details["profile_photo"] {
                            if !image_pfoto.isEmpty {
                                UserDefaults.standard.set(image_pfoto, forKey: USER_DEFAULT_USER_IMAGE)
                                UserDefaults.standard.synchronize()
                            }
                        }
                        if let name =  driver_details["full_name"] {
                            if !name.isEmpty {
                                UserDefaults.standard.set(name, forKey: USER_DEFAULT_USER_NAME)
                                UserDefaults.standard.synchronize()
                            }
                            
                        }
                    }
                    
                    if status == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if !self.isUseAsProfile!{// nor mal login
                                showAlertMessageWithOkAction(title: "ALERT", message: message as! String, vc: self) { (status) -> (Void) in
                                    if status == 1{
                                        removeSaveDate()
                                        self.popToLoginPage()
                                    }
                                }
                                
                                
                             //   UtilityClass.tostaOnWindow(message: message as! String, duration: 3.0, vc: self)
                              //  removeSaveDate()
                              //  self.popToLoginPage()
                                
                            }else{
                                self.showAlertDialog(strTitle: "ALERT", strMessage: message as! String)
                            }
                        }
                    }else if status == 1{
                        showAlertMessageWithOkAction(title: "ALERT", message: message as! String, vc: self) { (status) -> (Void) in
                            if status == 1{
                                removeSaveDate()
                                self.popToLoginPage()
                            }
                        }
                        
                    }
                }
            }
        })
        { (message) in
            self.hideLoading()
            UtilityClass.tosta(message: message as! String, duration: 1.5, vc: self)
        }
        
        
        
    }
    
    func popToLoginPage()  {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    //Mark: - Show meassage
    func showAlertDialog(strTitle: String, strMessage: String)  {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            
            let vc:DashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            vc.isBreakdown = false
            self.navigationController?.popPushToVC(ofKind: DashboardViewController.self, pushController: vc)
         
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    
@objc func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: PersonalInfoViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}

func removeSaveDate(){
    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SIGN_UP_PAGE_ONE)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SIGN_UP_ADDRESS)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SIGN_UP_ADDRESS)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SIGN_UP_PERSONAL_INFO)
    UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SIGN_UP_BANK_INFO)

}

//Mark: - TableView Extention
extension DriverDocumentationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentsName.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.row < documentsName.count {
            let cell: DriverDocumentationTableViewCell = self.documentationTable.dequeueReusableCell(withIdentifier: "cellDriver") as! DriverDocumentationTableViewCell
            cell.uplodedImageStatus.isHidden = true
            cell.populateTable(name: documentsName[indexPath.row], imageName: documentsImageArray[indexPath.row])
            cell.cellLowerLabel.isHidden = indexPath.row == (documentsName.count-1) ? false : true
            cell.uplodedImageStatus.isHidden = self.statusFlag[indexPath.row+1]
            return cell
            
        }else{
            let cell: DriverDocumentationTableViewCell = self.documentationTable.dequeueReusableCell(withIdentifier: "buttonCell") as! DriverDocumentationTableViewCell
            cell.buttonSubmit.addTarget(self, action: #selector(self.buttonSubmitData), for: .touchUpInside)
            cell.buttonBack.addTarget(self, action: #selector(self.navigateToPreviousPage), for: .touchUpInside)
         
            return cell
            
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.imageIndex = indexPath.row+1
        self.customImageSelectPopUp()
    }
 
}
extension DriverDocumentationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension DriverDocumentationViewController {
    func isAddressChange() -> Bool {
        if signUpStringInfo["flat_no"] != self.modelDocuments.regModel?.address_info?.flat_no {
            return true
        }
        if signUpStringInfo["street_no"] != self.modelDocuments.regModel?.address_info?.street_no {
            return true
        }
        if signUpStringInfo["street_name"] != self.modelDocuments.regModel?.address_info?.street_name {
            return true
        }
        if signUpStringInfo["suburb"] != self.modelDocuments.regModel?.address_info?.suburb {
            return true
        }
        
        if signUpStringInfo["state"] != self.modelDocuments.regModel?.address_info?.state {
            return true
        }
        if signUpStringInfo["pin"] != self.modelDocuments.regModel?.address_info?.pin {
            return true
        }
        return false
    }
    
    
    func dcExpDateChange() {
        if signUpStringInfo["dr_dc_expiry"] != self.modelDocuments.regModel?.personal_info?.dr_dc_expiry {
            self.statusFlag [1] = true
        }
        
    }
    
    func dLExpDateChange() {
        if signUpStringInfo["dr_licence_expiry"] != self.modelDocuments.regModel?.personal_info?.dr_licence_expiry {
            self.statusFlag [2] = true
        }
        
    }
}
