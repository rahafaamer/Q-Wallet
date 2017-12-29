//
//  AddNewWalletBenViewController.swift
//  SIM
//
//  Created by SSS on 10/23/17.
//  Copyright � 2017 SSS. All rights reserved.
//
import AWSCognitoIdentityProvider
import AWSDynamoDB
import UIKit
import RealmSwift

class AddWalletBeneficiaryViewController: UIViewController {
    
    @IBOutlet weak var walletNumTextField: UITextField!
    @IBOutlet weak var benNameTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    let userDefaults = UserDefaults.standard
    var customer:Customer?
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateLayout()
        let realm = try! Realm()
        let customers = realm.objects(Customer.self)
        if customers.count != 0 {
            self.customer = customers.first
        }
        hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.benNameTextField.addLineBelowTextField()
        self.walletNumTextField.addLineBelowTextField()
        
    }
    
    func UpdateLayout() {
        saveBtn.layer.borderColor = UIColor.white.cgColor
        saveBtn.layer.cornerRadius = 5
        saveBtn.layer.borderWidth = 1
        
        
        cancelBtn.layer.borderColor = UIColor.white.cgColor
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
        
//        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
//        saveBtn.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
//        saveBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
//
//        cancelBtn.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
//        cancelBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.benNameTextField.text = ""
        self.walletNumTextField.text = ""
    }
    
    func createWalletBeneficiary() {
        let walletBeneficiary = Beneficiary()
        walletBeneficiary.uuid = UUID().uuidString
        let beneficiaryType = BeneficiaryType()
        beneficiaryType.uuid = UUID().uuidString
        beneficiaryType.beneficiaryTypeName = "Wallet"
        walletBeneficiary.beneficiaryType = beneficiaryType
        walletBeneficiary.beneficiaryName = benNameTextField.text
        walletBeneficiary.walletId = walletNumTextField.text
        
        walletBeneficiary.customer = self.customer

        //set nil value
        walletBeneficiary.setNilValueToObject(beneficiary: walletBeneficiary)
        //convert to json
        let beneficiaryJson :[String:AnyObject] = (walletBeneficiary.toJson(beneficiary: walletBeneficiary) as [String : AnyObject])
        let params:[String:Any] = [
            "operation": "create" ,
            "tableName":  "Beneficiary" ,
            "payload": ["Item":beneficiaryJson]
        ]
        print(params)
        let genericServices = ApiGatway.api
        genericServices.save(params: params, onComplete:{ (status) in
            if (status == 1) {
                DispatchQueue.main.async {
                    self.parent?.view.makeToast("adding successful")
                    self.benNameTextField.text = ""
                    self.walletNumTextField.text = ""
                    
                }
            }
            else {
                DispatchQueue.main.async {
                    self.parent?.view.makeToast("adding failed")
                }
            }
        })
    }
    
    @IBAction func onSaveClick(_ sender: Any) {
        self.view.endEditing(true)
        createWalletBeneficiary()
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
