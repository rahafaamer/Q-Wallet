//
//  HomeViewController.swift
//  SIM
//
//  Created by SSS on 9/24/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import HVTableView
import AWSCognitoIdentityProvider
import RealmSwift

class HomeViewController: BaseViewController {
    
    
    struct Service{
        var name = ""
        var backgroundImage : UIImage?
        var serviceImage : UIImage?
        var desc = ""
    }
    
    let userDefaults = UserDefaults.standard
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    
    @IBOutlet weak var qBillImageView: UIImageView!
    @IBOutlet weak var qBuyImageView: UIImageView!
    @IBOutlet weak var QRewardImageView: UIImageView!
    @IBOutlet weak var qTopUpImageView: UIImageView!
    @IBOutlet weak var qRemitImageView: UIImageView!
    @IBOutlet var table: HVTableView!
    var services : [Service] = []
    var collapsedCells:[String:Bool] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        services.append(Service(name: "Q-Bill", backgroundImage: UIImage(named:"Q-Bill-1"), serviceImage:UIImage(named:"Q-Bill"),desc: "bill payment like electricity and water and loans back home"))
        services.append(Service(name: "Q-Remit", backgroundImage: UIImage(named:"Q-Remit-1"), serviceImage:UIImage(named:"Q-Remit"),desc: "q-remit is a service to make automated money transactions with  beneficiaries,user will navigate through the process step by step to complete the transaction \n  user will navigate through the process step by step to complete the transaction: \n 1- select/add beneficiary \n 2- select the Remittance way \n 3- determine amount, the currency and receiving currency \n 4- check the exchange rate, transfer fee, and FX rate \n 5- check the total amount \n 6- choose the source of money"))
        services.append(Service(name: "Q-buy", backgroundImage: UIImage(named:"Q-Buy-1"), serviceImage:UIImage(named:"Q-buy"),desc: "allows users to buy products and services thru mobile"))
        services.append(Service(name: "Q-TopUp", backgroundImage: UIImage(named:"Q-TopUp-1"), serviceImage:UIImage(named:"Q-TopUp"),desc: "Q-Topup is a service to make automated mobile balance transactions with beneficiaries user will navigate through the process step by step to complete the transaction \n 1- select/add beneficiarie's mobile number \n 2- select top up amount \n 3- check the exchange rate and charges as per \n 4- check the total amount \n 5- choose the source of money"))
        services.append(Service(name: "Q-Reward", backgroundImage: UIImage(named:"Q-Reward-1"), serviceImage:UIImage(named:"Q-Reward"),desc: "Loyalty program that allows you to the users where they can redeem the points in Qatar or home"))
        services.append(Service(name: "Wallet to Wallet", backgroundImage: UIImage(named:"Q-Reward-1"), serviceImage:UIImage(named:"Q-Reward"),desc: "Customer can choose to transfer money from his wallet to another wallet, customer will select his wallet as sender and add beneficiary wallet as receiver"))
        services.append(Service(name: "Add Balance to Wallet", backgroundImage: UIImage(named:"Q-Reward-1"), serviceImage:UIImage(named:"Q-Reward"),desc: "Customer can choose to deposit money in his wallet by transfer money from his bank account to wallet"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        updateLayout()
        let changeTheme = UIBarButtonItem(image: UIImage(named: "theme"), style: .plain, target: self, action: #selector(changetheme))
        //        let notification = UIBarButtonItem(image: UIImage(named: "not"), style: .plain, target: self, action: #selector(notificationPressed))
        
        self.navigationItem.rightBarButtonItem = changeTheme
        // self.table.expandCell(at: IndexPath(row: 0, section: 0))
        // Do any additional setup after loading the view.
        self.pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        if (self.user == nil) {
            self.user = self.pool?.currentUser()
        }
        self.refresh()
      
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateLayout() {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.addNavWithLogo(image: dic["logo"]!)
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
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
    
    //    func notificationPressed() {
    //        performSegue(withIdentifier: "toNot", sender: self)
    //    }
    
    @IBAction func onStart(_ sender: Any) {
        switch (sender as! UIButton).tag{
        case 0:
            self.performSegue(withIdentifier: "toQBill", sender: self)
        case 1:
            self.performSegue(withIdentifier: "toQRemit", sender: self)
        case 2:
            self.performSegue(withIdentifier: "EPayment", sender: self)
        case 3:
            self.performSegue(withIdentifier: "toQTopUp", sender: self)
        case 4:
            self.performSegue(withIdentifier: "toQreward", sender: self)
        case 5:
            self.performSegue(withIdentifier: "ToWalletToWallet", sender: self)
        case 6:
            self.performSegue(withIdentifier: "ToAddBalanceToWallet", sender: self)
        default:
            print("no segue")
        }
    }
    
    
    func refresh() {
        self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
                self.title = self.user?.username
                self.loadCustomer(userName: (self.user?.username)!)
            })
            return nil
        }
    }
    func loadCustomer(userName:String) {
        let params:[String:Any] = [
            "operation": "list",
            "tableName": "Customer",
            "payload": [
                "FilterExpression": "userName = :val",
                "ExpressionAttributeValues": [
                    ":val": userName
                ]
            ]
            
        ]
        let genericServices = ApiGatway.api
        genericServices.scan(params: params, onComplete: {(status,resultsArray) in
            if status == 1 {
                let customer = resultsArray[0]
                let customerObject = Customer().toObject(customerJson: customer as! [String : AnyObject])
                AppDelegate.sharedDelegate().customer = customerObject
                //                // Get the default Realm
                //                let realm = try! Realm()
                //                let customers = realm.objects(Customer.self)
                //                let prevCustomer = customers.first
                //                // You only need to do this once (per thread)
                //                if prevCustomer?.uuid != nil {
                //                    if prevCustomer?.uuid != customerObject.uuid {
                //                        // Add to the Realm inside a transaction
                //                        try! realm.write {
                //                            realm.deleteAll()
                //                            realm.add(customerObject)
                //                        }
                //                    }
                //
                //
                //                }
                //                else {
                //                    try! realm.write {
                //                        realm.deleteAll()
                //                    }
                //                    try! realm.write {
                //                        realm.add(customerObject)
                //                    }
                //
                //                }
            }
            else {
                print("failur")
            }
        })
    }
    
    @IBAction func qRewardService(_ sender: Any) {
        self.performSegue(withIdentifier: "toQreward", sender: self)
        
    }
    @IBAction func qBuyService(_ sender: Any) {
        self.performSegue(withIdentifier: "ToAddBalanceToWallet", sender: self)
    }
    @IBAction func qBillService(_ sender: Any) {
        self.performSegue(withIdentifier: "toQBill", sender: self)
    }
    @IBAction func qTopUpService(_ sender: Any) {
        self.performSegue(withIdentifier: "toQTopUp", sender: self)
    }
    @IBAction func qRemitService(_ sender: Any) {
        self.performSegue(withIdentifier: "toQRemit", sender: self)
        
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
