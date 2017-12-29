//
//  ViewBeneficiaryViewController.swift
//  SIM
//
//  Created by Rimon on 10/8/17.
//  Copyright � 2017 SSS. All rights reserved.
//

import UIKit
import RealmSwift

protocol RefreshTableView {
    func refresh()
}
class ViewBeneficiaryViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,RefreshTableView {
    
    @IBOutlet weak var benficiaryTableView: UITableView!
    var dic :[String:String] = [:]
     var benificiary = [String:[String]]()
    var walletBeneficiaries = [String]()
    var billBeneficiaries = [String]()
    var mobiletBeneficiaries = [String]()
    var personBeneficiaries = [String]()
    
    var userDefaults = UserDefaults.standard
    var customer :Customer!
    
    @IBOutlet weak var addBeneficiaryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayout()
        self.addBeneficiaryButton.layer.cornerRadius = 5
        self.addBeneficiaryButton.layer.borderWidth = 1
        self.addBeneficiaryButton.layer.borderColor = UIColor.white.cgColor
        self.benficiaryTableView.delegate = self
        self.benficiaryTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as! BenificiaryTableViewCell

            cell.benificiaryName.text = personBeneficiaries[indexPath.row]
            return cell
            
        case 1 :
            let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as! BenificiaryTableViewCell
            cell.benificiaryName.text = walletBeneficiaries[indexPath.row]
            return cell
            
        case 2 :
            let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as! BenificiaryTableViewCell
            cell.benificiaryName.text = mobiletBeneficiaries[indexPath.row]
            return cell
            
        case 3:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as! BenificiaryTableViewCell
            cell.benificiaryName.text = billBeneficiaries[indexPath.row]
            return cell
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") as! BenificiaryTableViewCell
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return (personBeneficiaries.count)
        case 1 :
            return (walletBeneficiaries.count)
        case 2 :
            return (mobiletBeneficiaries.count)
        case 3:
            return (billBeneficiaries.count)
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 10, y: 0, width: self.benficiaryTableView.frame.width - 20, height:tableView.sectionHeaderHeight))
        let label = UILabel(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2 , width: 300 , height: 30))
        label.textColor = UIColor.white
        
        switch section {
        case 0 :
            label.text = "Person"
        case 1 :
            label.text = "Wallet"
        case 2 :
            label.text = "Mobile TopUp"
        case 3:
            label.text = "E-Services (Bill)"
        default:
            return nil
        }
        view.layer.borderWidth = 1
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 3
        
        view.addSubview(label)
        return view
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let realm = try! Realm()
        let customers = realm.objects(Customer.self)
        if customers.count != 0 {
        self.customer = customers.first
        if customer != nil {
            getBeneficaryList()
            }
        }
   //     self.customer = AppDelegate.sharedDelegate().customer
        
    }
    func refresh() {
        getBeneficaryList()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func getBeneficaryList() {
        personBeneficiaries.removeAll()
        walletBeneficiaries.removeAll()
        billBeneficiaries.removeAll()
        mobiletBeneficiaries.removeAll()
        let customerName = self.customer.userName

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        // scan beneficiary withe specific type "Person"
        let personParams:[String:Any] = [
            "operation": "list",
            "tableName": "Beneficiary",
            "payload": [
                "FilterExpression": "beneficiaryType.beneficiaryTypeName = :val AND customer.userName = :userVal",
                "ExpressionAttributeValues": [
                    ":val": "Person" ,
                    ":userVal":customerName!
                ]
            ]
        ]
        print(personParams)
        let genericServices = ApiGatway.api
        genericServices.scan(params: personParams, onComplete: {(status,resultsArray) in
            if status == 1 {
                print ("success")
                for result in resultsArray { // For each element in resultArray
                    let personBeneficiary = result
                    if personBeneficiary["beneficiaryName"] != nil {
                        self.personBeneficiaries.append(personBeneficiary["beneficiaryName"]  as! String)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.benficiaryTableView.reloadData()
                })
            }
            else{
                print("failur")
            }
        })
        // scan wallet beneficiaries
        let walletParams:[String:Any] = [
            "operation": "list",
            "tableName": "Beneficiary",
            "payload": [
                "FilterExpression": "beneficiaryType.beneficiaryTypeName = :val AND customer.userName = :userVal",
                "ExpressionAttributeValues": [
                    ":val": "Wallet" ,
                    ":userVal":customerName!
                ]
        ]
    ]
        genericServices.scan(params: walletParams, onComplete: {(status,resultsArray) in
            if status == 1 {
                print ("success")
                for result in resultsArray { // For each element in resultArray
                    let walletBeneficiary = result
                    if walletBeneficiary["beneficiaryName"] != nil {
                        self.walletBeneficiaries.append(walletBeneficiary["beneficiaryName"]  as! String)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.benficiaryTableView.reloadData()
                })
            }
            else{
                print("failur")
            }
        })
        // scan mobile Topup beneficiaries
        let mobileTopUpParams:[String:Any] = [
            "operation": "list",
            "tableName": "Beneficiary",
            "payload": [
                "FilterExpression": "beneficiaryType.beneficiaryTypeName = :val AND customer.userName = :userVal",
                "ExpressionAttributeValues": [
                    ":val": "Mobile TopUp" ,
                    ":userVal":customerName!
                ]
        ]
            ]
        genericServices.scan(params: mobileTopUpParams, onComplete: {(status,resultsArray) in
            if status == 1 {
                print ("success")
                for result in resultsArray { // For each element in resultArray
                    let mobileTopUpBeneficiary = result 
                    if mobileTopUpBeneficiary["telecomProvider"] != nil  && mobileTopUpBeneficiary["mobileNumber"] != nil {
                        let telecomProvider = mobileTopUpBeneficiary["telecomProvider"] as! NSDictionary
                        let name = String(describing: telecomProvider["telecomProviderName"]!) + "-" + String(describing: mobileTopUpBeneficiary["mobileNumber"]!)
                        self.mobiletBeneficiaries.append(name)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.benficiaryTableView.reloadData()
                })
            }
            else{
                print("failur")
            }
        })

        // scan Bill beneficiaries
        let billParams:[String:Any] = [
            "operation": "list",
            "tableName": "Beneficiary",
            "payload": [
                "FilterExpression": "beneficiaryType.beneficiaryTypeName = :val AND customer.userName = :userVal",
                "ExpressionAttributeValues": [
                    ":val": "E-Services (Bill)" ,
                    ":userVal":customerName!
                ]
        ]
            ]
        genericServices.scan(params: billParams, onComplete: {(status,resultsArray) in
            if status == 1 {
                print ("success")
                for result in resultsArray { // For each element in resultArray
                    let billBeneficiary = result
                    if (billBeneficiary["serviceProvider"] != nil && billBeneficiary["serviceNumber"] != nil) {
                        let serviceprovider = billBeneficiary["serviceProvider"] as! NSDictionary
                    let name = String(describing: serviceprovider["serviceProviderName"]!) + "-" + String(describing: billBeneficiary["serviceNumber"]!)
                        self.billBeneficiaries.append(name)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.benficiaryTableView.reloadData()
                })
            }
            else{
                print("failur")
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBeneficiary" {
            let destination  = segue.destination as! AddBeneficiariesListViewController
            destination.beneficaryDelegate = self
        }
    }
    
    @IBAction func addBeneficiary(_ sender: Any) {
        self.performSegue(withIdentifier: "addBeneficiary", sender: sender)
    }
    func updateLayout() {
        dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
        addBeneficiaryButton.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        addBeneficiaryButton.setTitleColor(UIColor.white, for: .normal)
        
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
