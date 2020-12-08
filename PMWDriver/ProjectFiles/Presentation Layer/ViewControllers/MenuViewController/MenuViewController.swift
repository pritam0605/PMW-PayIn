//
//  MenuViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 30/08/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SideMenu


class MenuViewController: BaseViewController {
    
    var isFullVersionMenu = false
    var model = LoginModel()
    @IBOutlet weak var menuTable: UITableView!
    let menuName = ["Dashboard","Start Shift","Profile","Pay Ins","Daily Inspection", "Accident Form","Roster","Levy Report", "Breakdown Alert", "Change Password", "Log Out"]
    
    let imageArray = ["Dashboard.png", "ShiftIcon.png", "Profile.png", "Pay_ins.png","Daily_inspection.png","Accident_from.png","Roster.png","Levy_report.png", "Breakdown_aleart.png","Change password.png","Logout.png"]
  //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shiftStatus :Int = UserDefaults.standard.value(forKey: USER_DEFAULT_USER_SHIFT_STATUS) as! Int
        isFullVersionMenu = shiftStatus == 2 ? true : false
        menuTable.rowHeight =  UITableView.automaticDimension
        menuTable.estimatedRowHeight = 100
        menuTable.reloadData()
    }
    func presentTestView()  {
        
    }
}

//Mark: - TableView Extention
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuName.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuTableViewCell = self.menuTable.dequeueReusableCell(withIdentifier: "cellMenu") as! MenuTableViewCell
        cell.populateMenuTable(name: menuName[indexPath.row], imageName: imageArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            
            let vc = (self.storyboard?.instantiateViewController(withIdentifier:"DashboardViewController") as! DashboardViewController)
            vc.isBreakdown = false
            self.navigationController?.pushViewController(vc, animated: true)
            
            //            if appDel.IS_INSPECTION_DONE != 0{
            //            print("DashBoard")
            //            let vc = (self.storyboard?.instantiateViewController(withIdentifier:"DashboardViewController") as! DashboardViewController)
            //            vc.isBreakdown = false
            //            self.navigationController?.pushViewController(vc, animated: true)
            //            }else {
            //                UtilityClass.tostaOnWindow(message: "Please do Inspection", duration: 2.0, vc: self)
            //
            //            }
            
        case 1:
            
            let vc = (self.storyboard?.instantiateViewController(withIdentifier:"ShiftDetailsViewController") as! ShiftDetailsViewController)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            if appDel.IS_INSPECTION_DONE != 0{
                print("Profile")
                
                let vc = (self.storyboard?.instantiateViewController(withIdentifier:"SignUpPageOneViewController") as! SignUpPageOneViewController)
                vc.isUseAsProfile = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                UtilityClass.tostaOnWindow(message: "Please do Inspection", duration: 2.0, vc: self)
                
            }
            
        case 3:
            
            print("Payins")
            if appDel.IS_INSPECTION_DONE != 0 { //!=
                let vc = (self.storyboard?.instantiateViewController(withIdentifier:"PayInsViewController") as! PayInsViewController)
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                UtilityClass.tostaOnWindow(message: "Please do Inspection", duration: 2.0, vc: self)
                dismiss(animated: true, completion: nil)
            }
            
        case 4:
            print("Daily Inspaction")
            if isFullVersionMenu {
                let vc = self.storyboard?.instantiateViewController(withIdentifier:"InspectionViewController") as! InspectionViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                UtilityClass.tostaOnWindow(message: "Currently you don't have any shift", duration: 2.0, vc: self)
            }
        case 5:
            
            print("Accident From")
            if appDel.IS_INSPECTION_DONE != 0 {
                if isFullVersionMenu {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"CarDetailsInfoViewController") as! CarDetailsInfoViewController
                    self.navigationController?.pushViewController(vc, animated: true) // 1st page of Accident From
                }else{
                    UtilityClass.tostaOnWindow(message: "Currently you don't have any shift", duration: 2.0, vc: self)
                    dismiss(animated: true, completion: nil)
                }
            }else {
                UtilityClass.tostaOnWindow(message: "Please do Inspection", duration: 2.0, vc: self)
                dismiss(animated: true, completion: nil)
            }
            
        case 6:
            if appDel.IS_INSPECTION_DONE != 0 {
                print("Roster")
                let vc = self.storyboard?.instantiateViewController(withIdentifier:"RosterViewController") as! RosterViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                UtilityClass.tostaOnWindow(message: "Please do Inspection", duration: 2.0, vc: self)
                
            }
            
        case 7:
            if appDel.IS_INSPECTION_DONE != 0 {
                print("LevyReportViewController")
                let vc = self.storyboard?.instantiateViewController(withIdentifier:"LevyReportViewController") as! LevyReportViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                UtilityClass.tostaOnWindow(message: "Please do Inspection", duration: 2.0, vc: self)
                
            }
            
        case 8:
            if appDel.IS_INSPECTION_DONE != 0 {
                print("Break Dowwn")
                let vc = (self.storyboard?.instantiateViewController(withIdentifier:"DashboardViewController") as! DashboardViewController)
                vc.isBreakdown = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                UtilityClass.tostaOnWindow(message: "Please do Inspection", duration: 2.0, vc: self)
                
            }
            
        case 9:
            if appDel.IS_INSPECTION_DONE != 0 {
                print("Change Password")
                let vc = (self.storyboard?.instantiateViewController(withIdentifier:"ChangePasswordViewController") as! ChangePasswordViewController)
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                UtilityClass.tostaOnWindow(message: "Please do Inspection", duration: 2.0, vc: self)
                
            }
        case 10:
            print("Logout ")
            if appDel.IS_INSPECTION_DONE != 0 {
                self.callLogutApiCall()
            }else {
                UtilityClass.tostaOnWindow(message: "Please do Inspection", duration: 2.0, vc: self)
                
            }
            
        default:
            print("default")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
             self.dismiss(animated: true, completion: nil)
        }
    }

    
}
extension MenuViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}

extension MenuViewController {
    
    func callLogutApiCall() {
       
        let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY ) ?? ""
        let userID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID ) ?? ""
        let shiftID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_SHIFT_ID ) ?? ""
        
        self.showLoading()
         model.logOutAPIcall(token: token, userID: userID,shiftID: shiftID ) { (status, message) in
            DispatchQueue.main.async {
              self.hideLoading()
            }
            if status == 0{
                UtilityClass.tostaOnWindow(message: message, duration: 2.0, vc: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dismiss(animated: true, completion: nil)
                    self.forceLogout()
                }
            }else if status == 2 {
                UtilityClass.tostaOnWindow(message: message, duration: 2.0, vc: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dismiss(animated: true, completion: nil)
                    self.forceLogout()
                }
            }else {
                UtilityClass.tostaOnWindow(message: message, duration: 2.0, vc: self)
            }
        }
    }
    
    

}
