//
//  CommonTableViewCell.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 02/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class CommonTableViewCell: UITableViewCell {
    @IBOutlet weak var labelDC: UILabel!
    @IBOutlet weak var lableDate: UILabel!
    @IBOutlet weak var lableNoOfRun: UILabel!
    @IBOutlet weak var lableTotalLevy: UILabel!
    @IBOutlet weak var lableDay: UILabel!
    @IBOutlet weak var lableShiftType  : UILabel!
    @IBOutlet weak var lableCarNo  : UILabel!
    @IBOutlet weak var lableShiftID  : UILabel!
    @IBOutlet weak var lableTransctionID  : UILabel!
    @IBOutlet weak var lablePayoutAmmount  : UILabel!
    @IBOutlet weak var lableDateTime  : UILabel!
    
    @IBOutlet weak var labelQuestionName  : UILabel!
    @IBOutlet weak var img_Yes  : UIImageView!
    @IBOutlet weak var img_No  : UIImageView!
    @IBOutlet weak var button_Yes  : UIButton!
    @IBOutlet weak var button_No  : UIButton!
    @IBOutlet weak var button_Camera  : UIButton!
    @IBOutlet weak var button_SubmitQuestion  : UIButton!
    @IBOutlet weak var imgCamera  : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populateRosterTable(info: RosterList)  {
        self.lableDate.text = info.day_date
        self.lableDay.text = info.dayname
        self.lableShiftType.text = info.shift_name
        self.lableCarNo.text = info.registration_no
    }
    
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


// Levy Report
extension CommonTableViewCell {
    func populateLevyReportCellDate(info: LevyList)  {
        self.clearLevyReportCell()
        self.labelDC.text = info.shift_no
        self.lableNoOfRun.text = info.no_of_run
        self.lableDate.text = info.payin_date
        self.lableTotalLevy.text = info.levy
    }
    func clearLevyReportCell()  {
        self.labelDC.text = ""
        self.lableNoOfRun.text = ""
        self.lableDate.text = ""
        self.lableTotalLevy.text = ""
        
    }
}



