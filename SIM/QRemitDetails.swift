//
//  QRemitDetails.swift
//  SIM
//
//  Created by Rimon on 11/13/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import Foundation
import UIKit

class QRemitDetails :UIViewController,UITextFieldDelegate{

    @IBOutlet weak var verifyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var ATMPinCode: UITextField!
    @IBOutlet weak var bankViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var ATMExpiryDateTextField: UITextField!
    @IBOutlet weak var ATMNumberTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var bankButton: DLRadioButton!
    @IBOutlet weak var qWalletButton: DLRadioButton!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var receivedAmount: UILabel!
    @IBOutlet weak var debitedAmount: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var exchangeRate: UILabel!
    @IBOutlet weak var fxRate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackBtn()
        updateLayout()
        self.qWalletButton.isSelected = true
        self.verifyTopConstraint.constant = 90
        self.view.layoutIfNeeded()
    }
    override func didReceiveMemoryWarning() {
        
    }
    @IBAction func bankPressed(_ sender: Any) {
        bankButton.isSelected = true
        self.bankView.isHidden = false
        self.verifyTopConstraint.constant = 270
        self.view.layoutIfNeeded()
    }
    @IBAction func okButton(_ sender: Any) {
        if bankButton.isSelected {
        let alertController = UIAlertController(title: "getting Information from Bank",
                                                message: "your balance is : 102$ \n your debited Amount is : 1292$",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: getConfirmCodeFromBank)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
        alertController.addAction(okAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:  nil)
        }
        else  {
            let alertController = UIAlertController(title: "getting Information from Q-Wallet",
                                                    message: "your balance is : 102$ \n your debited Amount is : 1292$",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: getConfirmCodeFromQWallet)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion:  nil)
        }
        
        
    }
    func getConfirmCodeFromBank(action:UIAlertAction) {
        
        self.performSegue(withIdentifier: "toVerify", sender:action)
    }
    func getConfirmCodeFromQWallet(action:UIAlertAction) {
        self.performSegue(withIdentifier: "toVerify", sender: action)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! VerifyViewController
            destinationViewController.fromQRemit = true
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.ATMNumberTextField.resignFirstResponder()
        self.ATMExpiryDateTextField.resignFirstResponder()
        self.ATMPinCode.resignFirstResponder()
        return true
    }
    //keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.scrollRectToVisible(textField.frame, animated: true)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue
        let keyboardFrameConvertedToViewFrame = view.convert(keyboardFrame!, from: nil)
        let insetHeight : CGFloat = keyboardFrameConvertedToViewFrame.origin.y - 50
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, insetHeight, 0)
        self.scrollView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, insetHeight, 0)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.scrollView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    

    @IBAction func qWalletPressed(_ sender: Any) {
        qWalletButton.isSelected = true
        self.bankView.isHidden = true
        self.verifyTopConstraint.constant = 90
        self.view.layoutIfNeeded()
    }
    func updateLayout() {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        //self.benificiaryUsers.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
        self.verifyButton.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
       }

}
