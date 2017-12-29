//
//  NotificationTableViewCell.swift
//  SIM
//
//  Created by SSS on 9/12/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var notificationName: UILabel!
    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
