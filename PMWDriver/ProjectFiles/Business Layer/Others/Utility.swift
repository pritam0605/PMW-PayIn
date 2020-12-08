//
//  Utility.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 02/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import Foundation
import Toast_Swift
import UIKit

struct UtilityClass {
   static func tosta(message: String, duration: CGFloat, vc:UIViewController)  {
        var style = ToastStyle()
        style.messageColor = .white
        vc.view?.makeToast(message, duration: 3.0, position: .bottom)
    }
    
    static func getViewControllerById(storyboardName: String, storyboardId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
    
    static func tostaOnWindow(message: String, duration: CGFloat, vc:UIViewController)  {
        var style = ToastStyle()
        style.messageColor = .white
        vc.view?.window?.makeToast(message, duration: 3.0, position: .bottom)
       
    }
 
 
}

func showAlertMessageWithActionButton(title: String, message: String, actionButtonText: String, vc: UIViewController, complitionHandeler: @escaping(_ status: Int)-> (Void)){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel" , style: .default, handler: { (action) in
        
    }))
    alert.addAction(UIAlertAction(title: actionButtonText,
                                  style: .destructive,
                                  handler: {(_: UIAlertAction!) in
                                    complitionHandeler(1)
    }))
    vc.present(alert, animated: true, completion: nil)
}


func showAlertMessage(title: String, message: String,  vc: UIViewController){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}


func showAlertMessageWithOkAction(title: String, message: String, vc: UIViewController, complitionHandeler: @escaping(_ status: Int)-> (Void)){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: {(_: UIAlertAction!) in
                                    complitionHandeler(1)
    }))
    vc.present(alert, animated: true, completion: nil)
}

