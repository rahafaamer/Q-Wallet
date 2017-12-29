//
//  RegisterViewController.swift
//  SIM
//
//  Created by SSS on 9/11/17.
//  Copyright ? 2017 SSS. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSCognito
import AWSCore
import AWSDynamoDB
import NVActivityIndicatorView
import RealmSwift

class RegisterPhase2ViewController:UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    //test committ
    @IBOutlet weak var housePhoneLabel: UILabel!
    @IBOutlet weak var workPhoneLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var preferredLAnguageLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var regionImage: UIImageView!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var regionTableView: UITableView!
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var viewUnderReg: UIView!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var personalInfolabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndecatorView: NVActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var housePhoneTextField: GrayTextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var mailBoxTextField: UITextField!
    @IBOutlet weak var countrytextField: UITextField!
    @IBOutlet weak var addresstextField: UITextField!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var preferedLangTextField: UITextField!
    @IBOutlet weak var workPhoneTextField: UITextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var addDefaultUsers: UIButton!
    
    var mobileMoneys = ["Exchange houses","Bank transfer","Ooredoo money transfer"]
    var countrController :SRCountryPickerController?
    var isLanguageOpend = false
    var languages = [String]()
    var pool: AWSCognitoIdentityUserPool?
    var sentTo: String?
    var countries = [String]()
    var citiesList = [String]()
    var regions = [String]()
    var selectedCountry = Country()
    var selectedRegion = Region()
    var selectedCity = City()
    var selectedLanguage = Languages()
    var newCustomer:Customer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackBtn()
        let scrollGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterPhase2ViewController.onGesture(sender:)))
        contentView.addGestureRecognizer(scrollGesture)
        //self.navigationController?.navigationBar.barTintColor = UIColor.black
        updateLayout()
        
        
        languageTableView.delegate = self
        languageTableView.dataSource = self
        cityTableView.delegate = self
        cityTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.dataSource = self
        regionTableView.delegate = self
        regionTableView.dataSource = self
        
        self.pool = AWSCognitoIdentityUserPool.init(forKey: "UserPool")
        self.countryCodeLabel.text = "+963"
        self.housePhoneLabel.text = "+963"
        self.workPhoneLabel.text = "+963"
        getDataForTables()
        
        self.addDefaultUsers.layer.masksToBounds = true
        self.addDefaultUsers.layer.cornerRadius = 10
        self.addDefaultUsers.layer.borderWidth = 1
        self.addDefaultUsers.layer.borderColor = UIColor.white.cgColor
        
        
        self.preferredLAnguageLabel.layer.masksToBounds = true
        self.numberLabel.layer.masksToBounds = true
        self.emailLabel.layer.masksToBounds = true
        self.userNameLabel.layer.masksToBounds = true
        self.passwordLabel.layer.masksToBounds = true
        self.confirmPasswordLabel.layer.masksToBounds = true
        
        self.preferredLAnguageLabel.layer.cornerRadius = 5
        self.numberLabel.layer.cornerRadius = 5
        self.emailLabel.layer.cornerRadius = 5
        self.userNameLabel.layer.cornerRadius = 5
        self.passwordLabel.layer.cornerRadius = 5
        self.confirmPasswordLabel.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func RegisterUser ()
    {
        newCustomer.city = selectedCity
        newCustomer.country = selectedCountry
        newCustomer.region = selectedRegion
        newCustomer.email = emailTextField.text
        newCustomer.mobileNumber = String(countryCodeLabel.text! + mobileTextField.text!)
        newCustomer.housePhone = String(countryCodeLabel.text! + housePhoneTextField.text!)
        newCustomer.mailBox = mailBoxTextField.text
        newCustomer.address = addresstextField.text
        newCustomer.walletId = usernameField.text!+"-"+self.newCustomer.qid
        newCustomer.walletBalance = "1"
        newCustomer.preferredLanguage = selectedLanguage
        newCustomer.workPhone = String(countryCodeLabel.text! + workPhoneTextField.text!)
        newCustomer.userName = self.usernameField.text!
    }
    override func viewDidAppear(_ animated: Bool) {
        confirmPasswordField.addLineBelowTextField()
        passwordField.addLineBelowTextField()
        usernameField.addLineBelowTextField()
        mobileTextField.addLineBelowTextField()
        emailTextField.addLineBelowTextField()
        cityTextField.addLineBelowTextField()
        housePhoneTextField.addLineBelowTextField()
        regionTextField.addLineBelowTextField()
        mailBoxTextField.addLineBelowTextField()
        countrytextField.addLineBelowTextField()
        addresstextField.addLineBelowTextField()
        preferedLangTextField.addLineBelowTextField()
        workPhoneTextField.addLineBelowTextField()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterPhase2ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterPhase2ViewController.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        case languageTableView :
            return languages.count
        case cityTableView:
            return citiesList.count
        case countryTableView:
            return countries.count
        case regionTableView:
            return regions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case languageTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "languageCell")!
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.text = languages[indexPath.row]
        case cityTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
            cell.textLabel?.text = citiesList[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
            if activityIndecatorView.isAnimating {
                loaderView.isHidden = true
                self.activityIndecatorView.stopAnimating()
            }
        case countryTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "countryCell")!
            cell.textLabel?.text = countries[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
        case regionTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "regionCell")!
            cell.textLabel?.text = regions[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
        default:
            return cell
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case languageTableView :
            self.preferedLangTextField.text = languages[indexPath.row]
            self.languageTableView.isHidden = true
            self.dropDownImageView.image = UIImage(named:"icon 04")
            self.selectedLanguage.uuid = UUID().uuidString
            self.selectedLanguage.preferredLanguageName = preferedLangTextField.text 
        case cityTableView:
            if citiesList.isEmpty && activityIndecatorView.isAnimating {
                self.cityTableView.isUserInteractionEnabled = false
            }
            else {
                self.activityIndecatorView.stopAnimating()
                self.cityTableView.isUserInteractionEnabled = true
                self.cityTextField.text = citiesList[indexPath.row]
                self.cityTableView.isHidden = true
                self.cityImage.image = UIImage(named:"icon 04")
                selectedCity.uuid = UUID().uuidString
                selectedCity.cityName = cityTextField.text
                selectedCity.country = selectedCountry
            }
        case countryTableView:
            self.countrytextField.text = countries[indexPath.row]
            self.countryTableView.isHidden = true
            self.countryImage.image = UIImage(named:"icon 04")
            self.selectedCountry.uuid = UUID().uuidString
            self.selectedCountry.countryName = countrytextField.text
        case regionTableView:
            self.regionTextField.text = regions[indexPath.row]
            self.regionTableView.isHidden = true
            self.regionImage.image = UIImage(named:"icon 04")
            self.selectedRegion.uuid = UUID().uuidString
            self.selectedRegion.regionName = regionTextField.text
            
        default: break
            
        }
    }
    
    
    //keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
       // self.scrollView.scrollRectToVisible(textField.frame, animated: true)
        switch textField {
        case mobileTextField:
            self.numberLabel.isHidden = true
        case emailTextField:
            self.emailLabel.isHidden = true
        case usernameField:
            self.userNameLabel.isHidden = true
        case passwordField:
            self.passwordLabel.isHidden = true
        case confirmPasswordField:
            self.confirmPasswordLabel.isHidden = true
        default:
            break
        }
        if (textField.layer.borderColor == (UIColor.red).cgColor) {
            textField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameField {
            let userName = usernameField.text
            if (userName?.contains(" "))! {
                let alertController = UIAlertController(title: "Error",
                                                        message: "Please enter valid user name without spaces",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default ,handler: { (action) in
                    self.usernameField.text = ""
                    self.usernameField.becomeFirstResponder()
                })
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion:  nil)
                
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as! Dictionary<String, AnyObject>
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]!.cgRectValue
        let keyboardFrameConvertedToViewFrame = view.convert(keyboardFrame!, from: nil)
        let insetHeight : CGFloat = keyboardFrameConvertedToViewFrame.origin.y - 50
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, insetHeight, 0)
        self.scrollView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, insetHeight, 0)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.scrollView.scrollIndicatorInsets  = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func onGesture(sender:Any)  {
        mobileTextField.resignFirstResponder()
        regionTextField.resignFirstResponder()
        mailBoxTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        countrytextField.resignFirstResponder()
        addresstextField.resignFirstResponder()
        preferedLangTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        housePhoneTextField.resignFirstResponder()
        workPhoneTextField.resignFirstResponder()
    }
    func getDataForTables() {
        //scan Country table
        let genericServices = ApiGatway.api
        let countryParams:[String:Any] =  [
            "operation": "list" ,
            "tableName":  "Country" ,
            "payload": []
        ]
        genericServices.scan(params: countryParams, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let country = result
                    self.countries.append(country["countryName"] as! String)
                }
                self.countryTableView.reloadData()
            }
        })
        //scan language table
        let languageParams:[String:Any] = [
            "operation": "list" ,
            "tableName":  "Languages" ,
            "payload": []
        ]
        genericServices.scan(params: languageParams, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let language = result
                    self.languages.append(language["preferredLanguageName"] as! String)
                }
                self.languageTableView.reloadData()
            }
        })
        //scan Region table
        let regionParams:[String:Any] = [
            "operation": "list" ,
            "tableName":  "Region" ,
            "payload": []
        ]
        genericServices.scan(params: regionParams, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let region = result
                    self.regions.append(region["regionName"] as! String)
                }
                self.regionTableView.reloadData()
            }
        })
    }
    @IBAction func onSelectLanguage(_ sender: Any) {
        if(preferedLangTextField.layer.borderColor == (UIColor.red).cgColor){
            preferedLangTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        if self.languageTableView.isHidden {
            self.preferredLAnguageLabel.isHidden = true
            self.languageTableView.isHidden = false
            self.dropDownImageView.image = UIImage(named:"icon 03")
        }
        else {
            self.languageTableView.isHidden = true
            self.dropDownImageView.image = UIImage(named:"icon 04")
        }
        
    }
    @IBAction func selectCountry(_ sender: Any) {
        if(!citiesList.isEmpty){
            citiesList.removeAll()
            cityTextField.text = ""
        }
        if (activityIndecatorView.isAnimating){
            activityIndecatorView.stopAnimating()
        }
        
        if self.countryTableView.isHidden {
            self.countryTableView.isHidden = false
            self.countryImage.image = UIImage(named:"icon 03")
        }
        else {
            self.countryTableView.isHidden = true
        }
    }
    @IBAction func selectCity(_ sender: Any) {
        
        let countryName = countrytextField.text!
        if (citiesList.isEmpty) {
            loaderView.isHidden = false
            self.activityIndecatorView.startAnimating()
        }
        let params:[String:Any] = [
            "operation": "list",
            "tableName": "City",
            "payload": [
                "FilterExpression": "country.countryName = :val",
                "ExpressionAttributeValues": [
                    ":val": countryName
                ]
            ]

        ]
        let genericServices = ApiGatway.api
        genericServices.scan(params: params, onComplete: {(status,resultsArray) in
            if status == 1 {
                print ("success")
                self.citiesList.removeAll()
                for result in resultsArray { // For each element in resultArray
                    let city = result
                    if city["cityName"] != nil {
                        self.citiesList.append(city["cityName"] as! String)
                    }
                }
                DispatchQueue.main.async{
                    if (self.activityIndecatorView.isAnimating){
                        self.loaderView.isHidden = true
                        self.activityIndecatorView.stopAnimating()
                    }
                    self.cityTableView.reloadData()
                }
            }
            else{
                print("failur")
                if(self.activityIndecatorView.isAnimating){
                    self.loaderView.isHidden = true
                    self.activityIndecatorView.stopAnimating()
                }
            }
        })
        
        if self.cityTableView.isHidden {
            self.cityTableView.isHidden = false
            self.cityImage.image = UIImage(named:"icon 03")
            
        }
        else {
            self.cityTableView.isHidden = true
            if activityIndecatorView.isAnimating {
                loaderView.isHidden = true
                activityIndecatorView.stopAnimating()
            }
        }
    }
    @IBAction func selectRegion(_ sender: Any) {
        if self.regionTableView.isHidden {
            self.regionTableView.isHidden = false
            self.regionImage.image = UIImage(named:"icon 04")
        }
        else {
            self.regionTableView.isHidden = true
        }
    }
    
    
    func updateLayout() {
//        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
//        self.addNavWithLogo(image: dic["logo"]!)
//        self.personalInfolabel.textColor = UIColor(hex: dic["themeColor1"]!)
//        self.registrationLabel.textColor = UIColor(hex: dic["themeColor1"]!)
//        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
//        self.viewUnderReg.backgroundColor = UIColor(hex: dic["themeColor1"]!)
//        self.addDefaultUsers.backgroundColor = UIColor(hex: dic["themeColor1"]!)
//        self.languageTableView.layer.borderColor = UIColor(hex: dic["themeColor1"]!).cgColor
//        self.countryTableView.layer.borderColor = UIColor(hex: dic["themeColor1"]!).cgColor
//        self.cityTableView.layer.borderColor = UIColor(hex: dic["themeColor1"]!).cgColor
//        self.regionTableView.layer.borderColor = UIColor(hex: dic["themeColor1"]!).cgColor
    }
    
    
    
    @IBAction func onSelectCountryCode(_ sender: Any) {
        performSegue(withIdentifier: "toCountrySelection", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCountrySelection" {
            let des = segue.destination as! SRCountryPickerController
            des.countryDelegate = self
            countrController = des
        }
        if let signUpConfirmationViewController = segue.destination as? VerifyViewController {
            
            signUpConfirmationViewController.sentTo = self.sentTo
            signUpConfirmationViewController.customer = self.newCustomer
            signUpConfirmationViewController.userName = self.usernameField.text!
            signUpConfirmationViewController.password = self.passwordField.text!
            signUpConfirmationViewController.user = self.pool?.getUser(self.usernameField.text!)
        }
    }
  
    func checkEmailInDynamoDB(userMail: String,onComplete:@escaping (Int) -> Void){
        
        let genericServices = ApiGatway.api
        let params:[String:Any] = [
            "operation": "list" ,
            "tableName":  "Customer" ,
            "payload": [
                "FilterExpression": "email = :val",
                "ExpressionAttributeValues": [
                    ":val": userMail
                ]
        ]
        ]

        genericServices.scan(params: params, onComplete: {(status,resultsArray) in
//            if status == 1 {
//                onComplete(1)
//            }
//            else{
                onComplete(0)
            //}
        })
        
    
    }
    
  
    @IBAction func signUp(_ sender: AnyObject) {
        self.RegisterUser()
        self.view.endEditing(true)
        self.loaderView.isHidden = false
        self.activityIndecatorView.startAnimating()
        if !( mobileTextField.text == "" || emailTextField.text == "" || preferedLangTextField.text == "" || usernameField.text == "" || passwordField.text == "" ||  confirmPasswordField.text == "") {
            
            if (passwordField.text != confirmPasswordField.text) {
                self.loaderView.isHidden = true
                self.activityIndecatorView.stopAnimating()
                view.makeToast("Please the password fields are not identical!!!")
                passwordField.layer.borderColor = (UIColor.red).cgColor
                confirmPasswordField.layer.borderColor = (UIColor.red).cgColor
            }
            else {
                guard let userNameValue = self.usernameField.text, !userNameValue.isEmpty,
                    let passwordValue = self.passwordField.text, !passwordValue.isEmpty else {
                        let alertController = UIAlertController(title: "Missing Required Fields",
                                                                message: "Username / Password are required for registration.",
                                                                preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.loaderView.isHidden = true
                        self.activityIndecatorView.stopAnimating()
                        self.present(alertController, animated: true, completion:  nil)
                        return
                }
                checkEmailInDynamoDB(userMail: emailTextField.text!, onComplete: {(status) in
                    if status == 1{
                        //self.view.endEditing(true)
                        self.loaderView.isHidden = true
                        self.activityIndecatorView.stopAnimating()
                        self.view.makeToast("The email is already exist!")
                    }
                    else {
                        
                        var attributes = [AWSCognitoIdentityUserAttributeType]()
                        
                        let phoneValue = (self.countryCodeLabel.text)! + (self.mobileTextField.text!)
                        let phone = AWSCognitoIdentityUserAttributeType()
                        phone?.name = "phone_number"
                        phone?.value = phoneValue
                        attributes.append(phone!)
                        
                        
                        if let emailValue = self.emailTextField.text, !emailValue.isEmpty {
                            let email = AWSCognitoIdentityUserAttributeType()
                            email?.name = "email"
                            email?.value = emailValue
                            attributes.append(email!)
                        }
                        
                        
                        
                        //sign up the user
                        self.pool?.signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
                            guard let strongSelf = self else { return nil }
                            DispatchQueue.main.async(execute: {
                                if let error = task.error as? NSError {
                                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                                            message: error.userInfo["message"] as? String,
                                                                            preferredStyle: .alert)
                                    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                                    alertController.addAction(retryAction)
                                    self?.loaderView.isHidden = true
                                    self?.activityIndecatorView.stopAnimating()
                                    self?.present(alertController, animated: true, completion:  nil)
                                } else if let result = task.result  {
                                    // handle the case where user has to confirm his identity via email / SMS
                                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                                        strongSelf.sentTo = result.codeDeliveryDetails?.destination
                                        
                                        self?.saveCustomer(sender as AnyObject)
                                            } else {
                                        self?.loaderView.isHidden = true
                                        self?.activityIndecatorView.stopAnimating()
                                        let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                                
                            })
                            return nil
                        }
                    }
                })
 
        }
        }
        else {
            let color = UIColor.red
            mobileTextField.layer.borderColor = color.cgColor
            emailTextField.layer.borderColor = color.cgColor
            preferedLangTextField.layer.borderColor = color.cgColor
            usernameField.layer.borderColor = color.cgColor
            passwordField.layer.borderColor = color.cgColor
            confirmPasswordField.layer.borderColor = color.cgColor
            self.loaderView.isHidden = true
            self.activityIndecatorView.stopAnimating()
            self.view.makeToast("Please fill Requierd Fields")
        }
    }
    func saveCustomer(_ sender: AnyObject){
        newCustomer?.uuid = UUID().uuidString
        newCustomer?.setNilValueToObject(customer: self.newCustomer!)
        let genericServices = ApiGatway.api
        let customerJson :[String:Any] = newCustomer!.toJson(customer: newCustomer!)
        
        let params:[String:Any] = [
            "operation": "create" ,
            "tableName":  "Customer" ,
            "payload": ["Item":customerJson]
        ]
        
        genericServices.save(params: params, onComplete:{ (status) in
            
            if (status == 1) {
                var realmCustomer = Customer()
                realmCustomer = self.newCustomer
                // Get the default Realm
                let realm = try! Realm()
                // You only need to do this once (per thread)
                
                // Add to the Realm inside a transactionß
                try! realm.write {
                    realm.add(realmCustomer, update: true)
                }
                
                //AppDelegate.sharedDelegate().customer = self.customer
                
                self.activityIndecatorView.stopAnimating()
                self.loaderView.isHidden = true
                self.performSegue(withIdentifier: "confirmSignUpSegue", sender:sender)

                
                
            }
            else {
                print("failur")
                let alertController = UIAlertController(title: "Error",
                                                        message: "Your profie isn't be saved",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Retry Now", style: .default, handler: self.saveCustomer)
                let cancel = UIAlertAction(title: "Retry later", style: .default, handler: nil)
                self.loaderView.isHidden = true
                self.activityIndecatorView.stopAnimating()
                alertController.addAction(okAction)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion:  nil)
            }
        })
        
    }
    

    
}
extension RegisterPhase2ViewController: CountrySelectedDelegate {
    func SRcountrySelected(countrySelected country: SRCountry, countryFlag: UIImage) {
        self.countryCodeLabel.text = country.dial_code
        self.housePhoneLabel.text = country.dial_code
        self.workPhoneLabel.text = country.dial_code
        countrController?.dismiss(animated: true, completion: nil)
    }
}

