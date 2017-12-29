//
//  WalletToWalletViewController.swift
//  SIM
//
//  Created by SSS on 10/23/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class WalletToWalletViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var amountTextFiled: UITextField!
    @IBOutlet weak var walletBeneTextFiled: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var walletBeneficiaryTableview: UITableView!
    @IBOutlet weak var clickCancelBtn: UIButton!
    
    var amountText: String!
     var isBeneficiaryFieldopen : Bool  = false
    
    var walletBeneficiary : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateLayout()
        walletBeneficiaryTableview.delegate = self
        walletBeneficiaryTableview.dataSource = self
        
         walletBeneficiary.append("Samer Wallet")
         walletBeneficiary.append("Rawan Wallet")
        
        amountText = amountTextFiled.text
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletBeneficiary.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SelectBeneficiary(_ sender: Any) {
        if isBeneficiaryFieldopen == false
        {
            walletBeneficiaryTableview.isHidden = false
            walletBeneficiaryTableview.reloadData()
            isBeneficiaryFieldopen = true
        }
        else
         
        {
            walletBeneficiaryTableview.isHidden = true
            isBeneficiaryFieldopen = false
        }

    }

    @IBAction func ClickSendBtn(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WalletBeneficiaryCell")
            cell?.textLabel?.text = walletBeneficiary[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell!
      
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        walletBeneTextFiled.text = walletBeneficiary[indexPath.row]
            walletBeneficiaryTableview.isHidden = true
            isBeneficiaryFieldopen = false
        
        
    }
    
    func UpdateLayout()
    {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        sendButton.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
        sendButton.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        
        CancelButton.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
        CancelButton.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
