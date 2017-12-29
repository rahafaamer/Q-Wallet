//
//  FirstViewController.swift
//  SIM
//
//  Created by SSS on 9/10/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

struct User {
    var firstName:String
    var lastName :String
    var countryCode:String
    var amount:String
    var message:String
    var destinationCountry:String
    var destinationState:String
    var mobileMoney:String
    init() {
        firstName = ""
        lastName = ""
        countryCode = ""
        amount = ""
        message = ""
        destinationCountry = ""
        destinationState = ""
        mobileMoney = ""
    }
}
class MoneyTransfereViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet var newUser: UIButton!
    @IBOutlet var defaultUser: UITableView!
    @IBOutlet var userName: UITextField!
    
    @IBOutlet var okButton: UIButton!
    @IBOutlet var addDefaultSmallView: UIView!
    @IBOutlet var amount: GrayTextField!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var addDefaultUser: UIView!
    @IBOutlet var countryCodeButton: UIButton!
    @IBOutlet var usersCollectionView: UICollectionView!
    @IBOutlet var addUserView: UIView!
    @IBOutlet var countryFlag: UIImageView!
    @IBOutlet var countryCodeLabel: UILabel!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var contryCodeContainer: UIView!
    @IBOutlet var mobileMoneyImg: UIImageView!
    @IBOutlet var destinationCountryImg: UIImageView!
    @IBOutlet var destinationStateImg: UIImageView!
    @IBOutlet var mobileMoney: UITableView!
    @IBOutlet var destinationState: UITableView!
    @IBOutlet var destinationCountry: UITableView!
    @IBOutlet var mobileMoneyTextField: UITextField!
    @IBOutlet var destinationStateTextField: UITextField!
    @IBOutlet var destinationCountryTextField: UITextField!
    
    @IBOutlet var benificiaryUsers: UIButton!
    @IBOutlet var firstName: GrayTextField!
    @IBOutlet var lastName: GrayTextField!
    @IBOutlet var messageTextField: GrayTextField!
    @IBOutlet var amountTextField: GrayTextField!
    var savedUser = User()
    var selectedCountry:SRCountry!
    var destinationStates = [String]()
    var destinationCountries = [String]()
    var mobileMoneys = [String]()
    var hitoryUsers = [User]()
    var userCollectionViewLayout:AWCollectionViewDialLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize the users for colection view
        
        self.addBackBtn()
        //fill arrays
        mobileMoneys = ["Exchange houses","Bank transfer","Ooredoo money transfer"]
        //filldestination countries and states dictionary
        destinationStates =  ["Asweida","Damascus","Raqa","Saida","Soor"]
        destinationCountries = ["labanon","syria","Iraq","America"]
        // Do any additional setup after loading the view, typically from a nib.
        updateLayout()
        addSavedUserbtn()
        setupCollectionView()
        setupHistoryUsers()
        self.countryCodeButton.layer.borderColor = UIColor.lightGray.cgColor
        self.countryCodeButton.layer.borderWidth = 1.5
        self.countryCodeButton.layer.cornerRadius = 3
        self.createButton.layer.cornerRadius = 3
        self.benificiaryUsers.layer.cornerRadius = 3
        
        self.addDefaultSmallView.layer.borderColor = UIColor.lightGray.cgColor
        self.addDefaultSmallView.layer.borderWidth = 1.5
        self.addDefaultSmallView.layer.cornerRadius = 3
        self.addDefaultSmallView.layer.cornerRadius = 3
        
        self.okButton.layer.borderColor = UIColor.lightGray.cgColor
        self.okButton.layer.borderWidth = 1.5
        self.okButton.layer.cornerRadius = 3
        
        self.newUser.layer.borderColor = UIColor.lightGray.cgColor
        self.newUser.layer.borderWidth = 1.5
        self.newUser.layer.cornerRadius = 3
        
//        
//        let changeTheme = UIBarButtonItem(image: UIImage(named: "theme"), style: .plain, target: self, action: #selector(changetheme))
//        self.navigationItem.rightBarButtonItem = changeTheme
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupHistoryUsers() {
        var user:User = User()
        user.firstName = "rahaf"
        user.lastName = "aamer"
        user.amount = "50000"
        user.message = "And to cover the integration part we will build a Generic webservice layer (ECM web services) and utilize this layer to cover the requested integration modules"
        user.countryCode = "+971"
        user.destinationCountry = "Qatar"
        user.destinationState = "Dawha"
        user.mobileMoney = "Exchange houses"
        
        hitoryUsers.append(user)
        
        var user2:User = User()
        user2.firstName = "Rawan"
        user2.lastName = "Koroni"
        user2.amount = "80000"
        user2.message = "And to cover the integration part we will build a Generic webservice layer (ECM web services) and utilize this layer to cover the requested integration modules"
        user2.countryCode = "+971"
        user2.destinationCountry = "Qatar"
        user2.destinationState = "Dawha"
        user2.mobileMoney = "Bank Transfere"
        
        hitoryUsers.append(user2)
        
        var user3:User = User()
        user3.firstName = "Omran"
        user3.lastName = "Aleed"
        user3.amount = "570000"
        user3.message = "And to cover the integration part we will build a Generic webservice layer (ECM web services) and utilize this layer to cover the requested integration modules"
        user3.countryCode = "+971"
        user3.destinationCountry = "Qatar"
        user3.destinationState = "Dawha"
        user3.mobileMoney = "Ooredoo money transfer"
        
        hitoryUsers.append(user3)
        
        var user4:User = User()
        user4.firstName = "Rouba"
        user4.lastName = "Break"
        user4.amount = "580000"
        user4.message = "And to cover the integration part we will build a Generic webservice layer (ECM web services) and utilize this layer to cover the requested integration modules"
        user4.countryCode = "+971"
        user4.destinationCountry = "Qatar"
        user4.destinationState = "Dawha"
        user4.mobileMoney = "Ooredoo money transfer"
        
        hitoryUsers.append(user4)
        
        
        
    }
    func setupCollectionView() {
        if(userCollectionViewLayout == nil) {
            userCollectionViewLayout = AWCollectionViewDialLayout(radius: 400, andAngularSpacing: 15, andCellSize: CGSize(width: 200, height: 100), andAlignment: WHEELALIGNMENTLEFT, andItemHeight: 100, andXOffset: 75) // create collection view layout
        }
        else {
            userCollectionViewLayout = userCollectionViewLayout.update(400, andAngularSpacing: 14, andCellSize: CGSize(width: 200, height: 100), andAlignment: WHEELALIGNMENTLEFT, andItemHeight: 122, andXOffset: 75) as! AWCollectionViewDialLayout!  // update collection view layout
            
        }
        
        usersCollectionView.setCollectionViewLayout(userCollectionViewLayout, animated: true)
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hitoryUsers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! customCollectionViewCell
        cell.userName.text = hitoryUsers[indexPath.row].firstName
        cell.userPhoto.image = UIImage(named:"person2")
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1, animations: {
            self.addUserView.alpha = 0
        })
        self.firstName.text = hitoryUsers[indexPath.row].firstName
        self.lastName.text = hitoryUsers[indexPath.row].lastName
        self.amountTextField.text = hitoryUsers[indexPath.row].amount
        self.countryCodeLabel.text = hitoryUsers[indexPath.row].countryCode
        self.destinationStateTextField.text = hitoryUsers[indexPath.row].destinationState
        self.destinationCountryTextField.text = hitoryUsers[indexPath.row].destinationCountry
        self.mobileMoneyTextField.text = hitoryUsers[indexPath.row].mobileMoney
        self.messageTextField.text = hitoryUsers[indexPath.row].message
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mobileMoney {
            return mobileMoneys.count
        }
        if tableView == destinationState {
            return destinationStates.count
        }
        if tableView == defaultUser {
            return hitoryUsers.count
        }
        else {
            return destinationCountries.count
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mobileMoney {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mobileMoneyCell")
            cell?.textLabel?.text = mobileMoneys[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell!
        }
        if tableView == destinationState {
            let cell = tableView.dequeueReusableCell(withIdentifier: "destinationStatesCell")
            cell?.textLabel?.text = destinationStates[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell!
        }
        if tableView == defaultUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultUser")
            cell?.textLabel?.text = hitoryUsers[indexPath.row].firstName
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "destinationCountriesCell")
            cell?.textLabel?.text = destinationCountries[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mobileMoney {
            mobileMoneyTextField.text = mobileMoneys[indexPath.row]
        }
        if tableView == destinationState {
            destinationStateTextField.text = destinationStates[indexPath.row]
        }
        if tableView == destinationCountry {
            destinationCountryTextField.text = destinationCountries[indexPath.row]
        }
        if tableView == defaultUser {
            self.userName.text = hitoryUsers[indexPath.row].firstName
            savedUser.firstName = hitoryUsers[indexPath.row].firstName
            self.savedUser.lastName = hitoryUsers[indexPath.row].lastName
            self.savedUser.amount = amount.text!
            self.savedUser.countryCode = hitoryUsers[indexPath.row].countryCode
            self.savedUser.destinationState = hitoryUsers[indexPath.row].destinationState
            self.savedUser.destinationCountry = hitoryUsers[indexPath.row].destinationCountry
            self.savedUser.mobileMoney = hitoryUsers[indexPath.row].mobileMoney
            self.savedUser.message = hitoryUsers[indexPath.row].message
            
           }
        tableView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if textField == userName {
            if defaultUser.isHidden {
            defaultUser.isHidden = false
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amount {
            //let value = Double(amount.text!)! * 0.08
            amountLabel.text = "Fees: 20 QAR"
        }
    }
    
    @IBAction func mobileMoneyPressed(_ sender: Any) {
        if mobileMoney.isHidden {
            mobileMoney.isHidden = false
            mobileMoneyImg.image = UIImage(named:"icon 04")
        }
        else {
            mobileMoney.isHidden = true
            mobileMoneyImg.image = UIImage(named:"icon 03")
        }
    }
    @IBAction func destinationStatesPressed(_ sender: Any) {
        if destinationState.isHidden {
            destinationState.isHidden = false
            destinationStateImg.image = UIImage(named:"icon 04")
        }
        else {
            destinationState.isHidden = true
            destinationStateImg.image = UIImage(named:"icon 03")
        }
    }
    @IBAction func destinationCountryPressed(_ sender: Any) {
        if destinationCountry.isHidden {
            destinationCountry.isHidden = false
            destinationCountryImg.image = UIImage(named:"icon 04")
        }
        else {
            destinationCountry.isHidden = true
            destinationCountryImg.image = UIImage(named:"icon 03")
        }
    }
    
    @IBAction func countryCodeBtnPressed(_ sender: Any) {
        if (contryCodeContainer.isHidden) {
            contryCodeContainer.isHidden = false
            (self.childViewControllers[0] as! SRCountryPickerController).countryDelegate = self
        }
        else {
            contryCodeContainer.isHidden = true
        }
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
    }
    
    func updateLayout() {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.benificiaryUsers.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
        self.createButton.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
        self.addDefaultSmallView.backgroundColor = UIColor(hexString:dic["themeColor1"]!)
        self.addNavWithLogo(image: dic["logo"]!)
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: dic["themeColor1"]!)
    }
    
    func addSavedUserbtn()  {
        //let userButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        //userButton.setTitle("Users", for: .normal)
        //userButton.setTitleColor(UIColor.white, for: .normal)
        //userButton.addTarget(self, action: #selector(showUsers), for:.touchUpInside )
        var imageView = UIImageView(image: UIImage(named:"users"))
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let userButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        //userButton.setTitle("Users", for: .normal)
        //userButton.setTitleColor(UIColor.white, for: .normal)
        userButton.addTarget(self, action: #selector(showUsers), for:.touchUpInside )
        userButton.backgroundColor = UIColor.clear
        view.addSubview(userButton)
        view.addSubview(imageView)
        
        
        let barButton = UIBarButtonItem.init(customView: view)
        
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func showUsers()  {
        UIView.animate(withDuration: 1, animations: {
            self.addUserView.alpha = 0.8
        })
        
        
    }
    
    @IBAction func addBenificiaryUsers(_ sender: Any) {
        self.firstName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.messageTextField.resignFirstResponder()
        self.amountTextField.resignFirstResponder()
        self.amount.resignFirstResponder()
        self.mobileMoneyTextField.resignFirstResponder()
        self.destinationStateTextField.resignFirstResponder()
        self.destinationCountryTextField.resignFirstResponder()
        userName.resignFirstResponder()
        UIView.animate(withDuration: 2, animations: {
            self.addDefaultUser.alpha = 0.8
        })
    }
    @IBAction func okButton(_ sender: Any) {
        self.firstName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.messageTextField.resignFirstResponder()
        self.amountTextField.resignFirstResponder()
        self.amount.resignFirstResponder()
        userName.resignFirstResponder()
        self.mobileMoneyTextField.resignFirstResponder()
        self.destinationStateTextField.resignFirstResponder()
        self.destinationCountryTextField.resignFirstResponder()

        if userName.text != " " {
            fillCell(user: savedUser)
        }
        else {
            UIView.animate(withDuration: 2, animations: {
                self.addDefaultUser.alpha = 0
            })
        }
        
    }
    @IBAction func newUser(_ sender: Any) {
        self.firstName.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.messageTextField.resignFirstResponder()
        self.amountTextField.resignFirstResponder()
        self.amount.resignFirstResponder()
        userName.resignFirstResponder()

        self.mobileMoneyTextField.resignFirstResponder()
        self.destinationStateTextField.resignFirstResponder()
        self.destinationCountryTextField.resignFirstResponder()
        UIView.animate(withDuration: 2, animations:{
            self.addDefaultUser.alpha = 0
        })
    }
    func fillCell(user:User) {
        UIView.animate(withDuration: 2, animations:{
            self.addDefaultUser.alpha = 0
        })
        self.firstName.text = user.firstName
        self.lastName.text = user.lastName
        self.amountTextField.text = user.amount
        self.countryCodeLabel.text = user.countryCode
        self.destinationStateTextField.text = user.destinationState
        self.destinationCountryTextField.text = user.destinationCountry
        self.mobileMoneyTextField.text = user.mobileMoney
        self.messageTextField.text = user.message
        
    
    }
//    
//    func changetheme()  {
//        let actionSheet = UIAlertController(title: "Choose Theme", message: "please choose theme that you want!", preferredStyle: .actionSheet)
//        let hamad = UIAlertAction(title: "HAMAD International Airport", style: .default) { (action) in
//            AppDelegate.sharedDelegate().currentTheme = "Hamad"
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
//        }
//        let qatar = UIAlertAction(title: "Qatar Airways", style: .default) { (action) in
//            AppDelegate.sharedDelegate().currentTheme = "Qatar"
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
//        }
//        let aspire = UIAlertAction(title: "ASPIRE Zone", style: .default) { (action) in
//            AppDelegate.sharedDelegate().currentTheme = "ASPIRE"
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
//        }
//        let rail = UIAlertAction(title: "RAIL", style: .default) { (action) in
//            AppDelegate.sharedDelegate().currentTheme = "RAIL"
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
//        }
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        actionSheet.addAction(hamad)
//        actionSheet.addAction(qatar)
//        actionSheet.addAction(aspire)
//        actionSheet.addAction(rail)
//        actionSheet.addAction(cancel)
//        self.present(actionSheet, animated: true, completion: nil)
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension MoneyTransfereViewController: CountrySelectedDelegate {
    
    func SRcountrySelected(countrySelected country: SRCountry,countryFlag :UIImage ) {
        self.selectedCountry = country
        countryCodeLabel.text = self.selectedCountry.country_code + "   " + self.selectedCountry.dial_code
        countryCodeLabel.textColor = UIColor.black
        self.countryFlag.image = countryFlag
        self.contryCodeContainer.isHidden = true
    }
    
    
}


