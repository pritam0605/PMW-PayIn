//
//  ClassExtension.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 02/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var trimSpace: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var isValidTenDigitMobileNumber : Bool{
       let p = self.trimSpace
        return p.count >= 10 ? true : false
    }
    
    func toDate(withFormate formet: String) -> Date? {
        let dateFormatter = DateFormatter()
        let utcTimeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.timeZone = utcTimeZone
        dateFormatter.dateFormat = formet
        let date = dateFormatter.date(from: self)
        return date
    }
    
    var isValideEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    var containsDigits : Bool {
        return (self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil)
    }
}

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}
extension UINavigationController {
    //Mark:  - Check in navigation stack
    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: {$0.isKind(of: kind)})
    }
    //function use to check whether that VC is in the Stack or not , if in tha stack tha pop or Push
    func popPushToVC(ofKind Kind: AnyClass, pushController: UIViewController) {
        if containsViewController(ofKind: Kind) {
            for controller in self.viewControllers{
                if controller.isKind(of: Kind){
                    popToViewController(controller, animated: true)
                    break
                }
            }
        } else{
            pushViewController(pushController, animated: true)
        }
    }
    
    func backToPreviousPage() {
      self.popViewController(animated: true)
        
    }
    
}
extension UIView {
    func makeRound(){
    let radius = (self.frame.size.width / 2) - 2
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
       
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

extension Date {
    var currentTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = TIME_FORMETE
        let dateString = dateFormatter.string(from: self)
       return dateString
        
    }
    
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMETE
        let dateString = dateFormatter.string(from: self)
        return dateString
        
    }
}


extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}





