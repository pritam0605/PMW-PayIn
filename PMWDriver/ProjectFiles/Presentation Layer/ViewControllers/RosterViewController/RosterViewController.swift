//
//  RosterViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 02/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class RosterViewController: BaseViewController {
@IBOutlet weak var tableRoster: UITableView!
    let model = RosterModelClass()
    var dataModelList = [RosterList]()
    
    let userID = UserDefaults.standard.string(forKey: USER_DEFAULT_USER_ID) ?? ""
    let token = UserDefaults.standard.string(forKey: USER_DEFAULT_TOKEN_KEY) ?? ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOfRosterData()
        // Do any additional setup after loading the view.
    }
    
    func getListOfRosterData() {
        self.showLoading()
        model.listOfRosterData(token: token, driver: userID) { (status, message) in
            self.hideLoading()
            if status == 0{
                self.dataModelList = self.model.rosterDataModel?.rosterList ?? []
                DispatchQueue.main.async {
                    self.tableRoster.reloadData()
                }
                
            }else if status == 2 {
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
                self.forceLogout()
            }else{
                self.hideLoading()
                UtilityClass.tosta(message: message, duration: 0.5, vc: self)
            }
        }
    }
    


}
extension RosterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataModelList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommonTableViewCell = self.tableRoster.dequeueReusableCell(withIdentifier: "rosterCell") as! CommonTableViewCell
        if self.dataModelList.count > 0  {
            cell.populateRosterTable(info: self.dataModelList[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
}
