//
//  ShowImage.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 11/10/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import SDWebImage

class ShowImage: UIView {
    var imagename:String?
    @IBOutlet weak var imageShow: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let view = loadviewFromNib() else {
             return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadviewFromNib() -> UIView? {
        let nibView = Bundle.main.loadNibNamed("ShowImage", owner: self, options: nil)?.first as? UIView
        return nibView
    }
    
    func showImage(imageName: String, placeHolder: String)  {
        if let url = baseImageURl?.appendingPathComponent(imageName ) {
            imageShow.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageShow.sd_setImage(with: url, placeholderImage: UIImage(named: placeHolder))
        }
    }

    @IBAction func buttonDismiss(_ sender: UIButton) {
        imageShow.image = nil
        self.removeFromSuperview()
    }


}
