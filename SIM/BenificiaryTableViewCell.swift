//
//  BenificiaryTableViewCell.swift
//  SIM
//
//  Created by SSS on 10/8/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class BenificiaryTableViewCell: UITableViewCell {

    @IBOutlet var benificiaryName: UILabel!
    @IBOutlet var profilePhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.benificiaryName.textColor = UIColor.white
        self.profilePhoto.layer.cornerRadius =  self.profilePhoto.frame.width / 2
        self.profilePhoto.layer.borderColor = UIColor.lightGray.cgColor
        self.profilePhoto.layer.borderWidth = 1
        self.profilePhoto.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
