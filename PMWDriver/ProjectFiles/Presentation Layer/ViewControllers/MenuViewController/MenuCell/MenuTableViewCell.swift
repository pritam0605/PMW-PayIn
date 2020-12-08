//
//  MenuTableViewCell.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 30/08/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    
    func populateMenuTable(name:String, imageName: String) {
        menuName.text = name
        menuImage.image = UIImage(named: imageName)
        
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
