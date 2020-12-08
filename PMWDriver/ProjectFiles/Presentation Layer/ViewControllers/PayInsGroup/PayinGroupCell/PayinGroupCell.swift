//
//  PayinGroupCell.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 05/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit


class PayinGroupCell: UITableViewCell {
    
    @IBOutlet weak var abc: UILabel!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var buttonUploadImage: UIButton!
    @IBOutlet weak var buttonDropDown: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    var dropDownID:String?
    var seletedImage: UIImage?
    var imageName: String?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
