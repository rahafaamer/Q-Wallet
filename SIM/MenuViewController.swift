//
//  MenuViewController.swift
//  SIM
//
//  Created by Rimon on 10/3/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import RealmSwift

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let userDefaults = UserDefaults.standard
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    var isLogOut:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        updateLayout()

       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        switch indexPath.row {
        case 0:
            cell.menuLabel.text = "Home"
            cell.menuImage.image = UIImage(named:"icons8-User Filled-50")
        case 1:
            cell.menuLabel.text = "Profile"
            cell.menuImage.image = UIImage(named:"icons8-User Filled-50")
        case 2:
            cell.menuImage.image = UIImage(named:"icons8-User Groups-50")
            cell.menuLabel.text = "Beneficiary"
        case 3:
            cell.menuLabel.text = "Transactions history"
            cell.menuImage.image = UIImage(named:"icons8-New Filled-50")
        case 4:
            cell.menuLabel.text = "New Offers"
            cell.menuImage.image = UIImage(named:"icons8-New Filled-50")
        case 5:
            cell.menuLabel.text = "Locator"
            cell.menuImage.image = UIImage(named:"icons8-Marker Filled-50")
        case 6:
            cell.menuLabel.text = "Notifications"
            cell.menuImage.image = UIImage(named:"not")
        case 7:
            cell.menuLabel.text = "Legal Informations"
            cell.menuImage.image = UIImage(named:"icons8-About Filled-50")
        case 8:
            cell.menuLabel.text = "Contact Us"
            cell.menuImage.image = UIImage(named:"icons8-Phone Filled-50")
        case 9:
            cell.menuLabel.text = "Q-CRS"
            cell.menuImage.image = UIImage(named:"icons8-Communication Filled-50")
        case 10:
            cell.menuLabel.text = "Invite Friends"
            cell.menuImage.image = UIImage(named:"invite friends")
        default:
            cell.menuLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 6 {
            AppDelegate.sharedDelegate().openControllerWithIndentifier(identifier: "notNav")
        }
        if indexPath.row == 0 {
            AppDelegate.sharedDelegate().openControllerWithIndentifier(identifier: "home")
        }
        if indexPath.row == 1 {
            AppDelegate.sharedDelegate().openControllerWithIndentifier(identifier: "profile")
        }
        if indexPath.row == 3 {
            AppDelegate.sharedDelegate().openControllerWithIndentifier(identifier: "history")
        }
        if indexPath.row == 5 {
            AppDelegate.sharedDelegate().openControllerWithIndentifier(identifier: "location")
        }
        if indexPath.row == 8 {
            AppDelegate.sharedDelegate().openControllerWithIndentifier(identifier: "ContactUSViewController")
        }
        if indexPath.row == 7 {
            AppDelegate.sharedDelegate().openControllerWithIndentifier(identifier: "LegalInfoViewController")
        }
        if indexPath.row == 2 {
            AppDelegate.sharedDelegate().openControllerWithIndentifier(identifier: "ViewBeneficiaryViewController")
        }
    }

    func updateLayout() {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.mainView?.backgroundColor = UIColor(hex: dic["themeColor1"]!)
    }
    @IBAction func onLogout(_ sender: Any) {
       
        let realm = try! Realm()
        let customer = realm.objects(Customer.self).first!
        try! realm.write {
            realm.delete(customer)
        }
        
        self.user?.signOut()
        self.title = nil
        self.response = nil
        self.isLogOut = true
        
        let storyboard = UIStoryboard(name: "LoginViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "login")
        
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "signInNavigationController") as? UINavigationController
        navigationController?.viewControllers[0].navigationController?.setViewControllers([controller], animated: true)
        self.present(navigationController!, animated: true, completion: {})
        
         
        
    
        //self.refresh()
    }
    func refresh() {
       let session =  self.user?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            DispatchQueue.main.async(execute: {
                self.response = task.result
                self.userName.text = self.user?.username
                if !self.isLogOut {
                    //self.loadCustomer(userName: (self.user?.username)!)
                }
                else {
                    
                    
                }
            })
            return nil
        }
        print(session)
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
