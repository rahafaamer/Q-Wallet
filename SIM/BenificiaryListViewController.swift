//
//  BenificiaryListViewController.swift
//  SIM
//
//  Created by SSS on 10/5/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import RealmSwift

protocol BenificiaryListViewControllerDelegate {
    func fillBenificiaryList(benificiary:String)
}
class BenificiaryListViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate , BenificiaryListViewControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var sendCurrencyTextfield: UITextField!
    @IBOutlet weak var exchangeHouseTableView: UITableView!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var sendingCurrencyTableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var exchangeHouseTextField: UITextField!
    @IBOutlet var continueBtn: UIButton!
    @IBOutlet var receivingCurrencyTableView: UITableView!
    @IBOutlet var receivingCurrencyTextfield: UITextField!
    @IBOutlet var amountTextField: UITextField!
    var remittanceWayList = ["TT", "Western Union Money", "Transfer To", "Express Money", "Telecom"]
    var benificiaryList = [String]()
    var customer :Customer!
    var receivingCurrencyList = ["Dollar","euro","Estrleini","Dinar","Syrian Bound","QR"]
    var sendingCurrencyList = ["Dollar","euro","Estrleini","Dinar","Syrian Bound","QR"]
    var cityList = ["Dollar","euro","Estrleini","Dinar","Syrian Bound","QR"]
    var selectedCurr = "QR"
   var selectedSendingCurrency = "QR"
    @IBOutlet var benificairyTextfield: UITextField!
    @IBOutlet var newBenificiaryBtn: UIButton!
    @IBOutlet var benificaryListTableView: UITableView!
      var userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayout()
        self.addBackBtn()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        self.sendingCurrencyTableView.delegate = self
        self.cityTableView.delegate = self
        self.exchangeHouseTableView.delegate = self
        self.benificaryListTableView.delegate = self
        self.receivingCurrencyTableView.delegate = self
        
        self.benificairyTextfield.layer.borderColor = UIColor.lightGray.cgColor
        self.benificairyTextfield.layer.borderWidth = 1.5
        self.benificairyTextfield.layer.cornerRadius = 3

        self.receivingCurrencyTextfield.layer.borderColor = UIColor.lightGray.cgColor
        self.receivingCurrencyTextfield.layer.borderWidth = 1.5
        self.receivingCurrencyTextfield.layer.cornerRadius = 3
        
        self.amountTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.amountTextField.layer.borderWidth = 1.5
        self.amountTextField.layer.cornerRadius = 3
        
        self.exchangeHouseTableView.layer.borderColor = UIColor.lightGray.cgColor
        self.exchangeHouseTableView.layer.borderWidth = 1.5
        self.exchangeHouseTableView.layer.cornerRadius = 3
       
        self.sendingCurrencyTableView.layer.borderColor = UIColor.lightGray.cgColor
        self.sendingCurrencyTableView.layer.borderWidth = 1.5
        self.sendingCurrencyTableView.layer.cornerRadius = 3
        
        self.sendCurrencyTextfield.layer.borderColor = UIColor.lightGray.cgColor
        self.sendCurrencyTextfield.layer.borderWidth = 1.5
        self.sendCurrencyTextfield.layer.cornerRadius = 3
        
        self.cityTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.cityTextField.layer.borderWidth = 1.5
        self.cityTextField.layer.cornerRadius = 3
        
        self.cityTableView.layer.borderColor = UIColor.lightGray.cgColor
        self.cityTableView.layer.borderWidth = 1.5
        self.cityTableView.layer.cornerRadius = 3
        
        self.exchangeHouseTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.exchangeHouseTextField.layer.borderWidth = 1.5
        self.exchangeHouseTextField.layer.cornerRadius = 3
//        let realm = try! Realm()
//        let customers = realm.objects(Customer.self)
//        self.customer = customers.first
//        
        self.customer = AppDelegate.sharedDelegate().customer

        fillPersonBeneficiaryList()
        // Do any additional setup after loading the view.
    }
 
       
    
    func fillPersonBeneficiaryList() {
        let customerName = self.customer.userName
//        let beneficiaryService = BeneficiaryService()
//        beneficiaryService.scanWithExpression(beneficiaryTypeName: "Person", customerName: customerName!, onComplete: {(status,beneficiaries) in
//            if status == 1 {
//                print ("Success")
//                for beneficiaryItem in beneficiaries {
//                    if beneficiaryItem.beneficiaryName != nil {
//                        self.benificiaryList.append(beneficiaryItem.beneficiaryName)
//                    }
//                }
//                DispatchQueue.main.async(execute: {
//                    self.benificaryListTableView.reloadData()
//                })
//            }
//            else {
//                print ("Failer")
//            }
//        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
            case benificaryListTableView :
                return benificiaryList.count
        case exchangeHouseTableView :
            return remittanceWayList.count
        case receivingCurrencyTableView :
            return receivingCurrencyList.count
        case sendingCurrencyTableView :
            return sendingCurrencyList.count
        case cityTableView :
            return cityList.count
        default :
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case benificaryListTableView :
           cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
           cell.textLabel?.text = benificiaryList[indexPath.row]
           cell.textLabel?.textAlignment = NSTextAlignment.center
        case exchangeHouseTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "remittanceWayCell")!
            cell.textLabel?.text = remittanceWayList[indexPath.row]
           
        case receivingCurrencyTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "receivingCurrency")!
            cell.textLabel?.text = receivingCurrencyList[indexPath.row]
        case sendingCurrencyTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "sendingCurrencyCell")!
            cell.textLabel?.text = sendingCurrencyList[indexPath.row]
        case cityTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
            cell.textLabel?.text = cityList[indexPath.row]
            
        default : break
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell =  tableView.cellForRow(at: indexPath)
         switch tableView {
        case benificaryListTableView :
            self.benificairyTextfield.text = cell?.textLabel?.text
            benificaryListTableView.isHidden = true
         case exchangeHouseTableView :
            self.exchangeHouseTextField.text = cell?.textLabel?.text
            exchangeHouseTableView.isHidden = true
         case receivingCurrencyTableView :
            self.receivingCurrencyTextfield.text = cell?.textLabel?.text
            self.selectedCurr = (cell?.textLabel?.text)!
            receivingCurrencyTableView.isHidden = true
         case sendingCurrencyTableView :
            self.sendCurrencyTextfield.text = cell?.textLabel?.text
            self.selectedSendingCurrency = (cell?.textLabel?.text)!
            sendingCurrencyTableView.isHidden = true
         case cityTableView :
            self.cityTextField.text = cell?.textLabel?.text
            cityTableView.isHidden = true
         default : break
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "newPersonBenificiary" {
            let newBenificiary = segue.destination as! AddPersonBeneficiaryViewController
            newBenificiary.benificiarDelegate = self
        }
    }
    
 

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func fillBenificiaryList(benificiary:String) {
        self.benificiaryList.append(benificiary)
        self.benificaryListTableView.reloadData()
    }


    @IBAction func continueButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toRemitDetails", sender: sender)
    }
    @IBAction func onSelectBeneficiary(_ sender: Any) {
        if benificaryListTableView.isHidden {
            self.benificaryListTableView.isHidden = false
            self.view.bringSubview(toFront: benificaryListTableView)
        }
        else {
            self.benificaryListTableView.isHidden = true
        }
    }

    @IBAction func onReceivingCurrency(_ sender: Any) {
        if receivingCurrencyTableView.isHidden {
            self.receivingCurrencyTableView.isHidden = false
        }
        else {
            self.receivingCurrencyTableView.isHidden = true
        }
    }
    @IBAction func onSendCurrency(_ sender: Any) {
        if sendingCurrencyTableView.isHidden {
            self.sendingCurrencyTableView.isHidden = false
        }
        else {
            self.sendingCurrencyTableView.isHidden = true
        }
    }
    @IBAction func onCity(_ sender: Any) {
        if cityTableView.isHidden {
            self.cityTableView.isHidden = false
        }
        else {
            self.cityTableView.isHidden = true
        }
    }

    @IBAction func onExchangeHouse(_ sender: Any) {
        if exchangeHouseTableView.isHidden {
            self.exchangeHouseTableView.isHidden = false
        }
        else {
            self.exchangeHouseTableView.isHidden = true
        }
        
    }
 
    func updateLayout() {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        //self.benificiaryUsers.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
        self.newBenificiaryBtn.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
        self.continueBtn.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
        //self.addDefaultSmallView.backgroundColor = UIColor(hexString:dic["themeColor1"]!)
        //self.addNavWithLogo(image: dic["logo"]!)
        //self.navigationController?.navigationBar.barTintColor = UIColor(hexString: dic["themeColor1"]!)
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
