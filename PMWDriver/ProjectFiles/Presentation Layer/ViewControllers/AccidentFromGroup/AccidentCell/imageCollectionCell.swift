//
//  imageCollectionCell.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 05/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit

class imageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageDoc: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    
    func populateDate(name: String, imgArr: UIImage)  {
        self.nameField.text = name
        self.imageDoc.image = imgArr 
    }
    
    func populateDate(name: String, img : String)  {
        self.nameField.text = name
        self.imageDoc.image = UIImage(named: img)
    }
    
}
