//
//  HomeTableViewCell.swift
//  SIM
//
//  Created by SSS on 9/24/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
   
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var startbtn: UIButton!
    var type:String = ""
    @IBOutlet var label: UILabel!
    @IBOutlet var background: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
    }

    func onOpen()  {
        self.descriptionView.isHidden = false
    }
    
    func onClose()  {
        self.descriptionView.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
