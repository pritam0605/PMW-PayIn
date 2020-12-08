//
//  AccidentCell.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AccidentCell: UITableViewCell {
    @IBOutlet weak var textFieldCell: SkyFloatingLabelTextField!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var previousImage: UIImageView!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var uncheckImage: UIImageView!
    
    @IBOutlet weak var buttonBooLYes: UIButton!
    @IBOutlet weak var buttonBoolNo: UIButton!
    
    @IBOutlet weak var OwnerDriverSelection: UIButton!
    @IBOutlet weak var DriverSelection: UIButton!

    @IBOutlet weak var descriptionTextView: UITextView!
    
    var isOwnerOnly:Bool = false

//    func populateData(value: String)  {
//        textFieldCell.text = value
//    }
//    func populateCheckButtonY_N(value: String)  {
//        if value == "1"{
//            buttonBooLYes.isSelected = true
//            buttonBoolNo.isSelected = false
//        }else{
//            buttonBooLYes.isSelected = false
//            buttonBoolNo.isSelected = true
//        }
//    }
//    
//    func populateCheckButtonOwnerDriver(value: String)  {
//        if value == "1"{
//            OwnerDriverSelection.isSelected = true
//            DriverSelection.isSelected = false
//        }else{
//            OwnerDriverSelection.isSelected = false
//            DriverSelection.isSelected = true
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
