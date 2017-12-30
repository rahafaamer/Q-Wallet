//
//  SecondViewController.swift
//  SIM
//
//  Created by SSS on 9/10/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class EPaymentViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var transactionSecCode: UITextField!
    @IBOutlet weak var accountSecCode: UITextField!
    @IBOutlet weak var enterSecurityCodelabel: UILabel!
    @IBOutlet weak var transactionInfolabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var oqrImageView: UIImageView!
    var globalTimer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        cancelBtn.layer.cornerRadius = 2
        confirmBtn.layer.cornerRadius = 2
        let scrollGesture = UITapGestureRecognizer(target: self, action: #selector(EPaymentViewController.onGesture(sender:)))
        contentView.addGestureRecognizer(scrollGesture)
        updateLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        let changeTheme = UIBarButtonItem(image: UIImage(named: "theme"), style: .plain, target: self, action: #selector(changetheme))
        self.navigationItem.rightBarButtonItem = changeTheme

        self.addBackBtn()

        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        startTimer()
    }
    
    func updateLayout() {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.addNavWithLogo(image: dic["logo"]!)
        self.descLabel.textColor = UIColor(hex: dic["themeColor1"]!)
        self.enterSecurityCodelabel.textColor = UIColor(hex: dic["themeColor1"]!)
        self.transactionInfolabel.textColor = UIColor(hex: dic["themeColor1"]!)
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
        self.cancelBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        self.confirmBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
    }
    
    
    func onGesture(sender:Any)  {
        transactionSecCode.resignFirstResponder()
        accountSecCode.resignFirstResponder()
    }

    func startTimer() {
        if globalTimer == nil {
            self.globalTimer =  Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(displayPopUp), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.contentView.isHidden = true
    }
    @IBAction func onConfirm(_ sender: Any) {
        transactionSecCode.resignFirstResponder()
        accountSecCode.resignFirstResponder()
        self.contentView.isHidden = true
    }
    func displayPopUp()  {
        let alertController = UIAlertController(title: "Security Code!", message: "Your security code is: (556734)", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .default) { (action) in
           self.contentView.isHidden = false
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okBtn)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func changetheme()  {
        let actionSheet = UIAlertController(title: "Choose Theme", message: "please choose theme that you want!", preferredStyle: .actionSheet)
        let hamad = UIAlertAction(title: "HAMAD International Airport", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "Hamad"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        let qatar = UIAlertAction(title: "Qatar Airways", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "Qatar"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        let aspire = UIAlertAction(title: "ASPIRE Zone", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "ASPIRE"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        let rail = UIAlertAction(title: "RAIL", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "RAIL"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        
        let Qwallet = UIAlertAction(title: "Q-Wallet", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "QWallet"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(Qwallet)
        actionSheet.addAction(hamad)
        actionSheet.addAction(qatar)
        actionSheet.addAction(aspire)
        actionSheet.addAction(rail)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

