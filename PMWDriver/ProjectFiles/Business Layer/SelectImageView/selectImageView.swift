//
//  selectImageView.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 04/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import Foundation
import SkyFloatingLabelTextField

protocol UpdateImageArrayDelegate {
    func imageSelectedDone(_ selectedImage:UIImage, imageName: String)
     func cancelButtonPress()
}

struct MultipartInfo {
    enum MIME_TYPE {
        case text_plain
        case text_html
        case file_pdf
        case image_jpg
        case image_jpeg
        case image_png
        case image_gif
        case audio_mpeg
        case audio_ogg
        case audio_any
        case audio_wav
        case video_mp4
        case video_MOV
        
        func getMimeType() -> String {
            switch self {
            case .text_plain:
                return "text/plain"
            case .text_html:
                return "text/html"
            case .file_pdf:
                return "application/pdf"
            case .image_jpg:
                return "image/jpg"
            case .image_jpeg:
                return "image/jpeg" 
            case .image_png:
                return "image/png"
            case .image_gif:
                return "image/gif"
            case .audio_mpeg:
                return "audio/mpeg"
            case .audio_ogg:
                return "audio/ogg"
            case .audio_any:
                return "audio/*"
            case .audio_wav:
                return "audio/x-wav"
            case .video_mp4:
                return "video/mp4"
            case .video_MOV:
                return "video/MOV"
                
            }
        }
    }
    
     let strKey:String?
     let strFileName:String?
     let mimeType:MIME_TYPE?
     let data:Data?
    
    init(key:String?,mimeType:MIME_TYPE?,data:Data?,name:String?) {
        self.strKey = key
        self.mimeType = mimeType
        self.data = data
        self.strFileName = name
    }
}


class selectImageView: UIView,UIActionSheetDelegate{
    var isInspectionImageUpload:Bool = false
    @IBOutlet weak var selectedImage:UIImageView!
    @IBOutlet weak var textImageName: SkyFloatingLabelTextField!
    var picker: UIImagePickerController?
    var finalImage:UIImage?
    var delegate:UpdateImageArrayDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   func CommonInit(){
    guard let view = loadviewFromNib() else {
        return
    }
    self.picker?.delegate = self
    view.frame = self.bounds
    self.addSubview(view)
    finalImage = nil
    }
    

    func loadviewFromNib() -> UIView? {
        let nibView = Bundle.main.loadNibNamed("selectImageView", owner: self, options: nil)?.first as? UIView
        return nibView
    }
 
    
    func setUPImage(){
        self.selectedImage.layer.cornerRadius = self.selectedImage.frame.size.width / 2
        self.selectedImage.clipsToBounds = true
      
    }
    
    
    @IBAction func buttonSelectImage(_ sender: UIButton) {
        self.openActionSheetAlert()

    }
    
    func openActionSheetAlert()  {
        let attributedString = NSAttributedString(string: "Please select an image", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), //your font here
            NSAttributedString.Key.foregroundColor :THEME_GREEN_COLOR
            ])
        
        let actionSheetController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheetController.setValue(attributedString, forKey: "attributedTitle")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
           UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        let openCamera = UIAlertAction(title: "Camera", style: .default) { action in
            self.openCamera()
        }
        // add actions
        actionSheetController.addAction(openCamera)
        if !isInspectionImageUpload { //only from Camera  if isInspectionImageUpload  == true
            let openGalary = UIAlertAction(title: "Galary", style: .default) { action in
                self.openGalary()
            }
             actionSheetController.addAction(openGalary)
        }
        actionSheetController.addAction(cancelAction)
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = self
            popoverController.sourceRect = CGRect(x: self.bounds.midX, y: self.bounds.midY, width: 0, height: 0)
            
        }
        
        self.window?.rootViewController?.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    func openGalary(){
         self.picker = UIImagePickerController()
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            self.picker?.delegate = self
            self.picker?.sourceType = .photoLibrary
            self.picker?.allowsEditing = true
            self.window?.rootViewController?.present(picker!, animated: true, completion: nil)
        }
    }
    
    func openCamera(){
        self.picker = UIImagePickerController()
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            self.picker?.delegate = self
            self.picker?.sourceType = .camera
            self.picker?.allowsEditing = true
            self.window?.rootViewController?.present(picker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonDismissAlert(_ sender: UIButton) {
        self.picker = nil
        self.finalImage = nil
        self.removeFromSuperview()
    }
    
    @IBAction func buttonClickCancel(_ sender: UIButton){
        self.delegate?.cancelButtonPress()
         self.picker = nil
          self.finalImage = nil
        self.removeFromSuperview()
    }
    
    @IBAction func buttonClickDone(_ sender: UIButton){
        if let img = finalImage{
            let finalImageName = (self.textImageName.text ?? "image") + ".jpeg"
            self.delegate?.imageSelectedDone(img, imageName: finalImageName)
        }
        self.picker = nil
         self.finalImage = nil
        self.removeFromSuperview()
    }
    
    
}
extension selectImageView: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: false, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
            let timeInterval = NSDate().timeIntervalSince1970
            var theFileName : String = "\(timeInterval).jpeg"
            if let  imfURL =  info[UIImagePickerController.InfoKey.imageURL] as? NSURL{
                if let urlpath:String = imfURL.path , urlpath.count != 0{
                    theFileName = imfURL.lastPathComponent ?? theFileName
                }
            }
            textImageName.text = theFileName.components(separatedBy: ".").first
            let img = pickedImage.fixedOrientation()
            selectedImage.image = img
            finalImage = img
           
        }
        picker.dismiss(animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
         picker.dismiss(animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
