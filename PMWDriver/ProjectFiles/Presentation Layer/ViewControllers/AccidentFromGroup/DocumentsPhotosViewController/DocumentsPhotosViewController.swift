//
//  DocumentsPhotosViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
class DocumentsPhotosViewController: BaseViewController, UpdateImageArrayDelegate {
    @IBOutlet weak var addPhotoCollection:UICollectionView!
    var carDetails1stPageInfo = Dictionary<String, String>()
    //var imageArray = ["1.png","2.png","3.png","4.png"]
    var imageArrayN:[MultipartInfo] = [MultipartInfo]()
    var nameArray = ["Driving Licence front","Driving Licence back","Car Number Plate","Accident Photo"]
    fileprivate var arrImages:[UIImage] = [UIImage]()
    
    fileprivate var imgAdding:UIImage!
    var accidentPhotos:selectImageView?
    var imageIndex:Int = -999
    var strFirstTimeLoad:String = ""
    var accidentDetailsInfo = Dictionary<String, String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        strFirstTimeLoad = "first"
       
        //UserDefaults.standard.removeObject(forKey: "AccidentImage")
        showLoading()
        getSavedImageData()
        
    }
    
    
    var imagePickerController:UIImagePickerController {
        get{
            return UIImagePickerController()
        }
    }
    
    enum SELECT_ACCIDENT_IMAGE:Int {
        case DRIVER_LICENSE_FRONT = 0
        case DRIVER_LICENSE_BACK
        case CAR_NUMBER_PLATE
        case ACCIDENT_PHOTS
        func getImageKeys() -> String {
            switch self {
            case .DRIVER_LICENSE_FRONT:
                return "driving_licence_front"
            case .DRIVER_LICENSE_BACK:
                return "driving_licence_back"
            case .CAR_NUMBER_PLATE:
                return "car_number_plate"
            case .ACCIDENT_PHOTS:
                return "accident_media[]"
            }
        }
    }
    
    func selectAccidentPhotos()  {
         accidentPhotos = selectImageView()
        accidentPhotos?.frame = UIScreen.main.bounds
        accidentPhotos?.CommonInit()
        accidentPhotos?.delegate = self
        DispatchQueue.main.async {
            //self.accidentPhotos?.selectedImage.makeRound()
            self.view.addSubview(self.accidentPhotos!)
        }
    }
    func selectAccidentDocPhotos()  {
        accidentPhotos = selectImageView()
        accidentPhotos?.frame = UIScreen.main.bounds
        accidentPhotos?.CommonInit()
        accidentPhotos?.delegate = self
        DispatchQueue.main.async {
            //self.accidentPhotos?.selectedImage.makeRound()
            self.view.addSubview(self.accidentPhotos!)
        }
     
      
    }
    
    func cancelButtonPress() {
        print("cancelButtonPress")
        if self.accidentPhotos != nil{
            self.accidentPhotos = nil
        }
    }
    
    
    @IBAction func buttonTapPrevious(_ sender: UIButton) {
        self.navigateToPreviousPage()
    }
    
    @IBAction func buttonTapNext(_ sender: UIButton) {
        self.navigateToNextPage()
    }
    func navigateToNextPage() {
        
        self.addImagesAccident()
        
    }
    
    
    
    func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: CarDetailsInfoViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}
extension DocumentsPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArray.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = SELECT_ACCIDENT_IMAGE.init(rawValue: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! imageCollectionCell
        print(indexPath.item)
        if indexPath.item == arrImages.count {
            //Add New Record Cell
            cell.imageDoc?.image = UIImage(named: "AddMore.png")
            cell.nameField.text = "Add more"
            return cell
        }else{
            cell.imageDoc.tag = indexPath.item
            cell.imageDoc.layer.borderWidth = 1
            cell.imageDoc.layer.masksToBounds = false
            cell.imageDoc.layer.borderColor = UIColor.white.cgColor
            cell.imageDoc.layer.cornerRadius = ((self.addPhotoCollection.bounds.size.width/2 - 40)*0.75) / 2
            cell.imageDoc.clipsToBounds = true
            cell.populateDate(name: nameArray[indexPath.item],imgArr:self.arrImages[indexPath.item])
            
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageIndex = indexPath.item
        if indexPath.item == arrImages.count {
            //Last item
            if let cell = collectionView.cellForItem(at: indexPath) {
                self.selectAccidentPhotos()
            }
        }else if indexPath.item == 0
        {
            //Driving license Front
            
            self.selectAccidentPhotos()
            print("Image Index is:",imageIndex)
            
        }
        else if indexPath.item == 1 {
            //Driving license back
            print("Image Index is:",imageIndex)
            self.selectAccidentPhotos()
        }
        else if indexPath.item == 2 {
            //Car Number Plate
            print("Image Index is:",imageIndex)
            self.selectAccidentPhotos()
        }
        else if indexPath.item == 3 {
            //Car Number Plate
            print("Image Index is:",imageIndex)
            self.selectAccidentPhotos()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let width  = self.addPhotoCollection.bounds.size.width/2 - 40
        let hight = width+16
        return CGSize(width: width, height: hight)
    }
    
    //Mark : - test delegate
    func imageSelectedDone(_ selectedImage: UIImage, imageName: String) {
        guard let imgData = selectedImage.jpegData(compressionQuality: 0.75) else { return  }
        let imageKey = SELECT_ACCIDENT_IMAGE.init(rawValue: imageIndex)
        var Key_Multipart = "accident_media[]"
        if let key = imageKey?.getImageKeys(){
            Key_Multipart = key
        }
        let image = MultipartInfo(key:Key_Multipart , mimeType: .image_jpeg, data: imgData, name: imageName)
        //self.imageArrayN.append(image)

        if(arrImages.count == imageIndex)
        {
            imageArrayN.append(image)
            arrImages.append(selectedImage)
            nameArray.append(imageName)
        }
        else
        {
            imageArrayN[imageIndex] = image
            arrImages[imageIndex] = selectedImage
            nameArray[imageIndex] = imageName
        }

        addPhotoCollection.reloadData()
        if self.accidentPhotos != nil{
            self.accidentPhotos = nil
        }
        
        
        
    }
    
    func addImagesAccident(){
         showLoading()
        print("Accident Details Info:",self.accidentDetailsInfo)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WitnessDetailsViewController") as! WitnessDetailsViewController
        var imageArrayAccidentPhotosTemp:[MultipartInfo] = [MultipartInfo]()
        var arrImageData = [Dictionary<String, String>]()
        var indexAcctident = [Int]()
        for(index , object) in imageArrayN.enumerated()
        {
            //TotalAddedPic = TotalAddedPic + 1
            var tempImageData = Dictionary<String, String>()
            
            if(object.strKey != "blank"){
                let indexPath = IndexPath(row: index, section: 0)
                let cell:imageCollectionCell = addPhotoCollection.cellForItem(at: indexPath) as! imageCollectionCell
                
                guard let imageData = cell.imageDoc.image?.jpegData(compressionQuality: 0.75) else {
                      self.hideLoading()
                    return  }
                let image = MultipartInfo(key:object.strKey , mimeType: .image_jpeg, data: imageData , name: object.strFileName)
                imageArrayAccidentPhotosTemp.append(image)
               
               
                //imageArrayAccidentPhotosTemp.append(object)
            }else{
                UtilityClass.tosta(message: ALERT_MESSAGE_IMAGE_UPLOAD , duration: 2.0, vc: self)
                self.hideLoading()
                return
            }
            
            let colIndex = IndexPath(row: index, section: 0)
            let cell = addPhotoCollection.cellForItem(at: colIndex) as! imageCollectionCell
            if let img = cell.imageDoc.image {
                //let imageData = img.pngData() as NSData?
                guard let imageData = img.jpegData(compressionQuality: 1.0) else {return  }
                
                self.saveImageFile(FileName:nameArray[index],imageData:imageData as Data)
                
                tempImageData =  ["FileName":nameArray[index],"key":object.strKey!]
                arrImageData.append(tempImageData)
                indexAcctident.append(index)
            }
            
        }

        UserDefaults.standard.set(arrImageData, forKey: USER_DEFAULT_IMAGE_ARRAY)
        UserDefaults.standard.synchronize()
        
        hideLoading()
        vc.imageArrayAccidentPhotos = imageArrayAccidentPhotosTemp
        vc.witnessDetailsInfo = carDetails1stPageInfo
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

extension DocumentsPhotosViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    internal func takeImage(_ viewController:UIViewController?,_ cell:UICollectionViewCell) {
        guard let vc = viewController else {
            return
        }
        let clousCamera = PROJECT_CONSTANT.CLOUS.init {
            
            self.fetchImageFromCamera(vc, cell)
        }
        
        let clousGallery = PROJECT_CONSTANT.CLOUS.init {
            
            self.fetchImageFromGallery(vc, cell)
        }
        
        PROJECT_CONSTANT.displayAlert(Header: "PMW", MessageBody: "Please choose your image", AllActions: ["Camera":clousCamera,"Gallery":clousGallery,"Cancel":nil], Style: .actionSheet, cell)
    }
    
    
    private func fetchImageFromCamera(_ viewController:UIViewController,_ cell:UICollectionViewCell) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let picker = self.imagePickerController
            picker.sourceType = .camera
            picker.allowsEditing = false
            picker.delegate = self
            viewController.present(picker, animated: true, completion: nil)
        }else{
            PROJECT_CONSTANT.displayAlert(Header: "PMW", MessageBody: "Your device does not support to take image using camera", AllActions: ["OK":nil], Style: UIAlertController.Style.alert)
        }
    }
    private func fetchImageFromGallery(_ viewController:UIViewController,_ cell:UICollectionViewCell) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let picker = self.imagePickerController
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            picker.delegate = self
            viewController.present(picker, animated: true, completion: nil)
        }else{
            PROJECT_CONSTANT.displayAlert(Header: "PMW", MessageBody: "Your device does not support to select image using photo library", AllActions: ["OK":nil], Style: UIAlertController.Style.alert)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        var newImage: UIImage?
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage.resizeImage(width: Float(150), height: Float(150), quality: 1.0)
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage.resizeImage(width: Float(150), height: Float(150), quality: 1.0)
        } else {
            newImage = nil
        }
        
        if let img = newImage {
            // imageArray
            self.arrImages.append(img)
            self.addPhotoCollection.reloadData()
            //self.addPhotoCollection.reloadItems(at: [IndexPath.init(row: SELECT_ACCIDENT_IMAGE.ACCIDENT_PHOTS.rawValue + 1, section: 0)])
            
            //            self.tblSupportDocForm.reloadRows(at: [IndexPath.init(row: CELL_CONTENT.CELL_CONTENT_IMAGEADD.rawValue, section: 0)], with: UITableView.RowAnimation.automatic)
            
            imgAdding = newImage
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

extension UIImage {
    internal func resizeImage(width:Float,height:Float,quality:Float) -> UIImage {
        var actualHeight: Float = Float(self.size.height)
        var actualWidth: Float = Float(self.size.width)
        let maxHeight: Float = height
        let maxWidth: Float = width
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = quality
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect.init(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
}
extension DocumentsPhotosViewController
{
    func getSavedImageData()
    {
        if let savedImagArray :[Dictionary<String, String>] = UserDefaults.standard.value(forKey:"AccidentImage") as? [Dictionary<String, String>]{
            imageArrayN.removeAll()
            arrImages.removeAll()
            nameArray.removeAll()
            for (_ , object) in savedImagArray.enumerated()
            {
                
                let imageToupleData = self.fetchImage(FileName: object["FileName"] ?? "")
                let imageData = imageToupleData.1
                
                var blankMultipart = MultipartInfo(key:"blank", mimeType: .image_jpeg, data: nil, name: "blank")
                
                if(object["key"]! == "blank"){
                    imageArrayN.append(blankMultipart)
                    arrImages.append(imageToupleData.0)
                    nameArray.append(object["FileName"]!)
                }
                else{
                    blankMultipart = MultipartInfo(key:object["key"]! , mimeType:.image_jpeg, data: imageData, name: object["FileName"]!)
                    imageArrayN.append(blankMultipart)
                    arrImages.append(imageToupleData.0)
                    nameArray.append(object["FileName"]!)
                }
            }
        }
        else
        {
           // arrImages = [UIImage(named: "3.png"),UIImage(named: "2.png"),UIImage(named: "4.png"), UIImage(named: "1.png")] as! [UIImage]
            arrImages = [UIImage(named: "AddMore.png"),UIImage(named: "AddMore.png"),UIImage(named: "AddMore.png"), UIImage(named: "AddMore.png")] as! [UIImage]
            let blankMultipart = MultipartInfo(key:"blank", mimeType: .image_jpeg, data: nil, name: "blank")
            imageArrayN = [blankMultipart,blankMultipart,blankMultipart,blankMultipart]
            nameArray = ["Driving Licence front","Driving Licence back","Car Number Plate","Accident Photo"]
        }
        hideLoading()
    }
}
