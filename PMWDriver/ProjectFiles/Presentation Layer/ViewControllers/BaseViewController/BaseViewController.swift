//
//  BaseViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 30/08/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SideMenu
import SDWebImage
import SkyFloatingLabelTextField

class BaseViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    var text:UITextField?
    var vwLoader = LoaderView(frame: CGRect(x: 0.0, y: 0.0, width: Double(SCREEN_SIZE.width), height: Double(SCREEN_SIZE.height)))
    var showImageZoom = ShowImage(frame: CGRect(x: 0.0, y: 0.0, width: Double(SCREEN_SIZE.width), height: Double(SCREEN_SIZE.height)))
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.default.leftMenuNavigationController?.settings.presentationStyle = .menuSlideIn
        SideMenuManager.default.leftMenuNavigationController?.menuWidth = UIDevice.current.userInterfaceIdiom == .pad ? 380.0 :  240.0
        vwLoader.vwActivity.type = .ballClipRotatePulse

    }
    
    
    //MARK: - Internal Methods -
    func showLoading() {
        self.view.isUserInteractionEnabled = false
        vwLoader.startLoading()
        navigationController?.view.addSubview(vwLoader)
    }
    func hideLoading() {
        self.view.isUserInteractionEnabled = true
        vwLoader.removeFromSuperview()
        vwLoader.stopLoading()
    }
    
    func showImageZoom(imageName:String, placeHolder:String)  {
        showImageZoom.showImage(imageName: imageName, placeHolder: placeHolder)
        self.view.addSubview(showImageZoom)
    }
    //call after 
    func removeSavedAccidentData()  {
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SAVE_OWNER_DRIVER)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SAVE_WITNESS_INFO)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SAVE_CAR_INFO)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SAVE_INSURENCE)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_CAR_NUMBER)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_IMAGE_ARRAY)
    }
    
    
    func forceLogout()  {
  
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_USER_ID)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_TOKEN_KEY)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_USER_IMAGE)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_USER_DC)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_USER_NAME)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_DRIVER_TYPE)
         UserDefaults.standard.removeObject(forKey: USER_DEFAULT_USER_SHIFT_NUMBER)
        
        
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_USER_SHIFT_ID)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_USER_SHIFT_STATUS)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_USER_CAR_NO)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SAVE_CAR_INFO)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SAVE_INSURENCE)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SAVE_OWNER_DRIVER)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SAVE_WITNESS_INFO)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_CAR_NUMBER)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_IMAGE_ARRAY)

        //sign up info
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SIGN_UP_PAGE_ONE)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SIGN_UP_ADDRESS)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SIGN_UP_PERSONAL_INFO)
        UserDefaults.standard.removeObject(forKey: USER_DEFAULT_SIGN_UP_BANK_INFO)
        UserDefaults.standard.synchronize()
        
        //stop timer
         MyLocationManager.share.stopTimer()
        
        let vc:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
       if let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
              if nav.viewControllers.contains(where: {$0.isKind(of: LoginViewController.self)}){
                for controller in nav.viewControllers{
                    if controller.isKind(of:LoginViewController.self){
                        nav.popToViewController(controller, animated: true)
                        break
                    }
                }
              }else{
                nav.pushViewController(vc, animated: true)
            }
        }
     
    }
    

    
    func showAlert(strTitle: String, strMessage: String)  {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.forceLogout()
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    
    
    func addDatePickerToTextfield(textFild: UITextField) {
        text = textFild
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action:#selector(self.donedatePicker))
        doneButton.tag = textFild.tag
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(self.cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        // add toolbar to textField
        textFild.inputAccessoryView = toolbar
        // add datepicker to textField
        textFild.inputView = datePicker
    }
    @objc func donedatePicker(barButton:UIBarButtonItem){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        text?.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
}


extension BaseViewController {
    
//    func getImage(imageName:String) -> UIImage? { // old 
//        var image = UIImage()
//        if let url = baseImageURl?.appendingPathComponent(imageName ) {
//            if  let data = try? Data(contentsOf: url){
//                image = UIImage(data: data)!
//                return image
//            }
//        }
//        return nil
//    }
    
    func setImageInImageView(imageName: String, placeHolderImage: String, imageView: UIImageView ) {
         if let url = baseImageURl?.appendingPathComponent(imageName ) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: placeHolderImage))
        }
    }
}

extension BaseViewController {
    func saveImageFile(FileName:String,imageData:Data) {
        let documentsPath1 = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath1.appendingPathComponent("PMWDriver")
        //try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.relativePath
        let docURL = URL(string: documentsDirectory!)!
        let dataPath = docURL.appendingPathComponent("PMWDriver")
        print(dataPath)
        if !fileManager.fileExists(atPath: dataPath.relativePath) {
            do {
                try fileManager.createDirectory(atPath: dataPath.relativePath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print(error.localizedDescription);
            }
        }
        let imagesDirectoryPath = logsPath?.appendingPathComponent(FileName)
        do{
            try imageData.write(to:imagesDirectoryPath!)
        }
        catch{}
    }
    
    func fetchImage(FileName:String) -> (UIImage,Data){
        let documentsPath1 = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath1.appendingPathComponent("PMWDriver")
        let imagesDirectoryPath = logsPath?.appendingPathComponent(FileName)
        guard let image = UIImage(contentsOfFile:imagesDirectoryPath!.relativePath) else { return (UIImage(named: "AddMore.png")!, Data.init())}
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return (UIImage(named: "AddMore.png")!, Data.init())}
        return (image,imageData)
        
    }
    
}
    


