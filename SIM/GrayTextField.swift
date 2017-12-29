//
//  GrayTextField.swift
//  Pizza-Hut
//
//  Created by SSS on 6/25/17.
//  Copyright © 2017 omran. All rights reserved.
//

import UIKit

class GrayTextField: UITextField,UITextFieldDelegate {
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 3
    }
    
//    override func awakeFromNib() {
//        self.delegate = self
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if self.layer.borderColor != UIColor.lightGray.cgColor {
//            self.layer.borderColor = UIColor.lightGray.cgColor
//            
//        }
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.text == "" {
//            self.layer.borderColor = UIColor.red.cgColor
//        }
//    }
}
