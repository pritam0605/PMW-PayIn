//
//  SignUpCell.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpCell: UITableViewCell {
    @IBOutlet weak var textFieldCell: SkyFloatingLabelTextField!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var previousImage: UIImageView!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var dropDownImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func populateData(value: String)  {
        textFieldCell.text = value
    }

}
