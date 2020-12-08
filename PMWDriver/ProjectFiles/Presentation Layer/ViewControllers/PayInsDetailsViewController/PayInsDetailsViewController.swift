//
//  PayInsDetailsViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 09/10/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
class PayInsDetailsViewController: BaseViewController {
    @IBOutlet weak var detailsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailsTable.estimatedRowHeight = 70
        self.detailsTable.rowHeight =  UITableView.automaticDimension

    }
 
}

extension PayInsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //demodate
        if section == 0{
            return 1
        } else if section == 1 {
            return 5
        }else{
            return 10
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") as! PayInsDetailsCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocketsCell") as! PayInsDetailsCell
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .phone ? 40 : 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
        return "OVER ALL INFO"
        } else if section == 1{
            return "DOCKETS  & EFTPOS"
        } else {
            return "EXPENSE"
        }
    }
    
}
