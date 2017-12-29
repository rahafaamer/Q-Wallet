//
//  QTopUpViewController.swift
//  SIM
//
//  Created by Rimon on 10/4/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import RealmSwift

class QTopUpViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate ,BenificiaryListViewControllerDelegate {
    
    @IBOutlet weak var chargeButton: UIButton!
    @IBOutlet weak var amountUnits: UITableView!
    @IBOutlet weak var numbers: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var selectedAmount: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var operation: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    var customer:Customer?
    var mobileNumbers : [String] = []
    var units:[String] = []
    var selectedMobileNumber:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateLayout()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.operation.addLineBelowTextField()
        self.mobileNumber.addLineBelowTextField()
        self.selectedAmount.addLineBelowTextField()
        self.country.addLineBelowTextField()
        let realm = try! Realm()
        let customers = realm.objects(Customer.self)
        if customers.count != 0 {
            self.customer = customers.first
            if customer != nil {
                getTopUpBeneficiaries()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case numbers:
            return mobileNumbers.count
        case amountUnits:
            return units.count
        default:
            return 0
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case numbers:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mobileNumber")
            cell?.textLabel?.text = mobileNumbers[indexPath.row]
            return cell!
        case amountUnits:
            let cell = tableView.dequeueReusableCell(withIdentifier: "unit")
            cell?.textLabel?.text = units[indexPath.row]
            return cell!
        default:
            return UITableViewCell()
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case numbers:
            let cell = tableView.cellForRow(at: indexPath)
            mobileNumber.text = cell?.textLabel?.text
            self.numbers.isHidden = true
            selectedMobileNumber = (cell?.textLabel?.text)!
        case amountUnits:
            let cell = tableView.cellForRow(at: indexPath)
            selectedAmount.text = cell?.textLabel?.text
            self.amountUnits.isHidden = true
        default:
            break
        }
    }
    
    func fillBenificiaryList(benificiary: String) {
        self.mobileNumbers.append(benificiary)
        self.numbers.reloadData()
    }
    
    
    
    /*  func showInputDialog() {
     //Creating UIAlertController and
     //Setting title and message for the alert dialog
     let alertController = UIAlertController(title: "Enter New Number?", message: "", preferredStyle: .alert)
     
     //the confirm action taking the inputs
     let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
     
     //getting the input values from user
     let number = alertController.textFields?[0].text
     self.mobileNums.append(number!)
     self.mobileNumTableView.reloadData()
     }
     
     //the cancel action doing nothing
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
     
     //adding textfields to our dialog box
     alertController.addTextField { (textField) in
     textField.placeholder = "Enter Number"
     }
     
     
     //adding the action to dialogbox
     alertController.addAction(confirmAction)
     alertController.addAction(cancelAction)
     
     //finally presenting the dialog box
     self.present(alertController, animated: true, completion: nil)
     }
     */

    func UpdateLayout() {
        // let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        continueButton.layer.borderWidth = 2
        continueButton.layer.cornerRadius = 10
        continueButton.layer.borderColor = UIColor.white.cgColor
        
        chargeButton.layer.borderWidth = 2
        chargeButton.layer.cornerRadius = 10
        chargeButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func Continue(_ sender: Any) {
        
    }
    @IBAction func selectAmount(_ sender: Any) {
        if self.amountUnits.isHidden {
            self.amountUnits.isHidden = false
        }
        else {
            self.amountUnits.isHidden = true
        }
        // showInputDialog()
    }
  
    
    @IBAction func chargeButtonPressed(_ sender: Any) {
        ApiGatway.api.getInformationOfMobileNumber(mobileNumber: selectedMobileNumber, onComplete: {(status) in
            
            if status == 1 {
                
                
            }
        })
    }
    
    @IBAction func selectMobileNume(_ sender: Any) {
        if self.numbers.isHidden {
            self.numbers.isHidden = false
        }
        else {
            self.numbers.isHidden = true
        }
    }
    func getTopUpBeneficiaries() {
        
        // scan mobile Topup beneficiaries
        let mobileTopUpParams:[String:Any] = [
            "operation": "list",
            "tableName": "Beneficiary",
            "payload": [
                "FilterExpression": "beneficiaryType.beneficiaryTypeName = :val AND customer.userName = :userVal",
                "ExpressionAttributeValues": [
                    ":val": "Mobile TopUp" ,
                    ":userVal":customer!.userName
                ]
            ]
        ]
        ApiGatway.api.scan(params: mobileTopUpParams, onComplete: {(status,resultsArray) in
            if status == 1 {
                print ("success")
                for result in resultsArray { // For each element in resultArray
                    let mobileTopUpBeneficiary = result
                    if mobileTopUpBeneficiary["telecomProvider"] != nil  && mobileTopUpBeneficiary["mobileNumber"] != nil {
                       // let telecomProvider = mobileTopUpBeneficiary["telecomProvider"] as! NSDictionary
                     //   let name = String(describing: telecomProvider["telecomProviderName"]!) + "-" + String(describing: mobileTopUpBeneficiary["mobileNumber"]!)
                        self.mobileNumbers.append(mobileTopUpBeneficiary["mobileNumber"] as! String)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.numbers.reloadData()
                })
            }
            else{
                print("failur")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addMobileNumber" {
            let newBenificiary = segue.destination as! AddMobileBeneficiaryViewController
            newBenificiary.backgroundImageName = "Background"
            newBenificiary.benificiarDelegate = self
        }
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
