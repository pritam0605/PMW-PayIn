//
//  DriverDocumentationTableViewCell.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 03/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class DriverDocumentationTableViewCell: UITableViewCell{

@IBOutlet weak var documentsImage: UIImageView!
@IBOutlet weak var documentsName: UILabel!
@IBOutlet weak var cellLowerLabel: UILabel!
@IBOutlet weak var buttonSubmit: UIButton!
@IBOutlet weak var buttonBack: UIButton!
@IBOutlet weak var uplodedImageStatus: UIImageView!
    
func populateTable(name:String, imageName: String) {
    documentsName.text = name
    documentsImage.image = UIImage(named: imageName)
    
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
