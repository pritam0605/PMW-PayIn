//
//  PayInsDetailsCell.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 09/10/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class PayInsDetailsCell: UITableViewCell {
    
    @IBOutlet weak var lableShiftID: UILabel!
    @IBOutlet weak var lableTransectionId: UILabel!
    @IBOutlet weak var lableCarNo: UILabel!
    @IBOutlet weak var lableBond: UILabel!
    @IBOutlet weak var lablePayOutAmount: UILabel!
    @IBOutlet weak var lableSubtotal: UILabel!
    @IBOutlet weak var lableDriverShare: UILabel!
    @IBOutlet weak var lableTotalFair: UILabel!
    @IBOutlet weak var lableNoOfHirings: UILabel!
    @IBOutlet weak var lableWHL: UILabel!
    @IBOutlet weak var lableLevyRate: UILabel!
    
    
    
    @IBOutlet weak var lableCatigory: UILabel!
    @IBOutlet weak var lablePrice: UILabel!
    @IBOutlet weak var lableSlipImage: UILabel!
    
    
    func populateOverAllCellInfo()  {
        
    }
    
    func populateDocketsInfo()  {
        
    }
    func populateExpenseInfo()  {
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
