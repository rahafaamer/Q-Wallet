//
//  TourCollectionViewCell.swift
//  SIM
//
//  Created by Rimon on 9/12/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class TourCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descLebel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descLebel.layer.cornerRadius = 3
    }
}
