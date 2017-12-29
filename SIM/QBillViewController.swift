//
//  QBillViewController.swift
//  SIM
//
//  Created by Rimon on 10/7/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class QBillViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate{

    
    @IBOutlet weak var billTypeSelected: UITextField!
    
    var billTypeText : String = ""
    
    
    @IBOutlet weak var transfereFromWay: UITextField!
    
    var transfereWayText : String = ""
    
    @IBOutlet weak var billValue: UITextField!
   
    @IBOutlet weak var debitedValue: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var billTypeTableView: UITableView!
    @IBOutlet weak var transfereFromTableview: UITableView!
    
    var isBillTypeOpen : Bool = false
    var isTransfereWayOpen : Bool = false
    
    var billValueText : String = ""
    var dibiedValueEntered : String = ""
    
    var billTypeList : [String] = []
    var transferFromList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billTypeTableView.delegate = self
        billTypeTableView.dataSource = self
        
        transfereFromTableview.delegate = self
        transfereFromTableview.dataSource = self

        
        billTypeList.append("Kahramaa")
         billTypeList.append("Ooredoo")
        
        transferFromList.append("Q-Wallet")
        transferFromList.append("Card")
 
         dibiedValueEntered = debitedValue.text!
        
        UpdateLayout()
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == billTypeTableView
        {
            return billTypeList.count
        }
        else
            
            {
                return transferFromList.count
            }
        }
    
    @IBAction func SelectBillType(_ sender: Any) {
    
        if isBillTypeOpen == false
        {
            billTypeTableView.isHidden = false
            billTypeTableView.reloadData()
            isBillTypeOpen = true
        }
        else
            
        {
            billTypeTableView.isHidden = true
            isBillTypeOpen = false
            
        }
        
    }
    
    @IBAction func SelectTransferWay(_ sender: Any) {
     
        if isTransfereWayOpen == false
        {
            transfereFromTableview.isHidden = false
            transfereFromTableview.reloadData()
            isTransfereWayOpen = true
        }
        else
        {
            transfereFromTableview.isHidden = true
            isTransfereWayOpen = false
            
        }
        
        billValue.text  = "2000 QR"
    }

    @IBAction func SubmitButton(_ sender: Any) {
        debitedValue.resignFirstResponder()

        let alert = UIAlertController(title: "Done!", message: "you have paid your bill successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func CancelButton(_ sender: Any) {
        debitedValue.resignFirstResponder()

     self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == billTypeTableView
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BillTypeCell")
            cell?.textLabel?.text = billTypeList[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell!
        }
        else
        {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TransferFromCell")
                cell?.textLabel?.text = transferFromList[indexPath.row]
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                return cell!
            }
        
               }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == billTypeTableView
        {
            billTypeSelected.text = billTypeList[indexPath.row]
            billTypeTableView.isHidden = true
            isBillTypeOpen = false
        }
        else
        {
                transfereFromWay.text = transferFromList[indexPath.row]
                transfereFromTableview.isHidden = true
                isTransfereWayOpen = false
        }
        
    }

    func UpdateLayout()
    {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        submitButton.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
        submitButton.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        
        cancelButton.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
        cancelButton.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        
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
