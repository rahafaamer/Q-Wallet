//
//  customCollectionViewCell.swift
//  SIM
//
//  Created by SSS on 9/12/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class customCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var userPhoto: UIImageView!
    
    @IBOutlet var userName: UILabel!
    override func awakeFromNib() { 
        
        self.userPhoto.layer.cornerRadius = 50
        self.userPhoto.layer.borderColor = UIColor.white.cgColor
        self.userPhoto.layer.borderWidth = 3
        self.userPhoto.layer.masksToBounds = true
    }
}
