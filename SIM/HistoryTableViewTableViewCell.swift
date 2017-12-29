//
//  HistoryTableViewTableViewCell.swift
//  SIM
//
//  Created by Rimon on 9/12/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class HistoryTableViewTableViewCell: UITableViewCell {
    @IBOutlet weak var cellBackground: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var underView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sentToLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackground.layer.cornerRadius = 10
        cellBackground.layer.masksToBounds = true
        cellBackground.addLayer()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
