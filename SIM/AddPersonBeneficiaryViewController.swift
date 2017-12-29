//
//  NewBenificiaryViewController.swift
//  SIM
//
//  Created by SSS on 10/5/17.
//  Copyright © 2017 SSS. All rights reserved.
//
import Toast_Swift
import UIKit
import RealmSwift

class AddPersonBeneficiaryViewController: UIViewController ,UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var beneficiaryEmailTextField: UITextField!
    @IBOutlet weak var beneficiaryHousePhoneTextField: UITextField!
    @IBOutlet var IBanTextField: UITextField!
    @IBOutlet weak var beneficiaryWorkPhoneTextField: UITextField!
    @IBOutlet var bankNamesTableView: UITableView!
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet var bankNameArrow: UIImageView!
    @IBOutlet var bankTextField: UITextField!
    @IBOutlet var cityTableView: UITableView!
    @IBOutlet var cityArrowImage: UIImageView!
    @IBOutlet var countryTableView: UITableView!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var countryArrowImage: UIImageView!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var benificiaryTelephoneTextField: UITextField!
    @IBOutlet var benificiaryNameTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var bankBtn: UIButton!
    let userDefaults = UserDefaults.standard
    var countries = [String]()
    var customer:Customer?
    var cities = [String]()
    var banks = [String]()
    var benificiarDelegate:BenificiaryListViewControllerDelegate!
    var selectedCountry = Country()
    var selectedCity = City()
    var selectedBank:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayout()
        
        let realm = try! Realm()
        let customers = realm.objects(Customer.self)
        if customers.count != 0 {
            self.customer = customers.first
        }
        getDataForTables()
        self.beneficiaryEmailTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.beneficiaryEmailTextField.layer.borderWidth = 1.5
        self.beneficiaryEmailTextField.layer.cornerRadius = 3
        
        self.beneficiaryWorkPhoneTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.beneficiaryWorkPhoneTextField.layer.borderWidth = 1.5
        self.beneficiaryWorkPhoneTextField.layer.cornerRadius = 3
        
        self.beneficiaryHousePhoneTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.beneficiaryHousePhoneTextField.layer.borderWidth = 1.5
        self.beneficiaryHousePhoneTextField.layer.cornerRadius = 3
        
        self.benificiaryNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.benificiaryNameTextField.layer.borderWidth = 1.5
        self.benificiaryNameTextField.layer.cornerRadius = 3
        
        self.benificiaryTelephoneTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.benificiaryTelephoneTextField.layer.borderWidth = 1.5
        self.benificiaryTelephoneTextField.layer.cornerRadius = 3
        
        self.IBanTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.IBanTextField.layer.borderWidth = 1.5
        self.IBanTextField.layer.cornerRadius = 3
        
        self.countryTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.countryTextField.layer.borderWidth = 1.5
        self.countryTextField.layer.cornerRadius = 3
        
        self.cityTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.cityTextField.layer.borderWidth = 1.5
        self.cityTextField.layer.cornerRadius = 3
        
        self.bankTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.bankTextField.layer.borderWidth = 1.5
        self.bankTextField.layer.cornerRadius = 3
        
        self.accountTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.accountTextField.layer.borderWidth = 1.5
        self.accountTextField.layer.cornerRadius = 3
        
        
        self.addButton.layer.borderColor = UIColor.lightGray.cgColor
        self.addButton.layer.borderWidth = 1.5
        self.addButton.layer.cornerRadius = 3
        
        self.cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        self.cancelButton.layer.borderWidth = 1.5
        self.cancelButton.layer.cornerRadius = 3
        
        self.countryTableView.delegate = self
        self.cityTableView.delegate = self
        self.bankNamesTableView.delegate = self
        
        self.countryTableView.dataSource = self
        self.cityTableView.dataSource = self
        self.bankNamesTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        beneficiaryEmailTextField.addLineBelowTextField()
        beneficiaryHousePhoneTextField.addLineBelowTextField()
        IBanTextField.addLineBelowTextField()
        beneficiaryWorkPhoneTextField.addLineBelowTextField()
        accountTextField.addLineBelowTextField()
        bankTextField.addLineBelowTextField()
        cityTextField.addLineBelowTextField()
        countryTextField.addLineBelowTextField()
        benificiaryTelephoneTextField.addLineBelowTextField()
        benificiaryNameTextField.addLineBelowTextField()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case countryTableView :
            return countries.count
        case cityTableView :
            return cities.count
        case bankNamesTableView :
            return banks.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case countryTableView  :
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = countries[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
        case cityTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.text = cities[indexPath.row]
        case bankNamesTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "bankCell")!
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.text = banks[indexPath.row]
            
        default: break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        switch tableView {
        case countryTableView :
            self.countryTextField.text = cell?.textLabel?.text
            countryTableView.isHidden = true
            self.selectedCountry.uuid = UUID().uuidString
            self.selectedCountry.countryName = countryTextField.text
            getCityForCountry()
        case cityTableView :
            self.cityTextField.text = cell?.textLabel?.text
            cityTableView.isHidden = true
            self.selectedCity.uuid = UUID().uuidString
            self.selectedCity.cityName = cityTextField.text
            self.selectedCity.country = selectedCountry
        case bankNamesTableView :
            self.bankTextField.text = cell?.textLabel?.text
            bankNamesTableView.isHidden = true
            selectedBank = self.bankTextField.text!
            
            
        default : break
            
        }
    }
    
    @IBAction func onCity(_ sender: Any) {
        if cityTableView.isHidden {
            self.cityTableView.isHidden = false
            self.view.bringSubview(toFront: cityTableView)
        }
        else   {
            self.cityTableView.isHidden = true
        }
    }
    @IBAction func onCountry(_ sender: Any) {
        if countryTableView.isHidden {
            self.countryTableView.isHidden = false
            self.view.bringSubview(toFront: countryTableView)
        }
        else {
            self.countryTableView.isHidden = true
        }
    }
    @IBAction func onBank(_ sender: Any) {
        if bankNamesTableView.isHidden {
            self.bankNamesTableView.isHidden = false
            self.view.bringSubview(toFront: bankNamesTableView)
        }
        else {
            self.bankNamesTableView.isHidden = true
        }
    }
    
    
    @IBAction func onAdd(_ sender: Any) {
        //benificiarDelegate.fillBenificiaryList(benificiary: benificiaryNameTextField.text!)
        self.view.endEditing(true)
        createPersonBeneficiary()
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    func createPersonBeneficiary() {
        //
        let personBeneficiary = Beneficiary()
        personBeneficiary.uuid = UUID().uuidString
        let beneficiaryType = BeneficiaryType()
        beneficiaryType.uuid = UUID().uuidString
        beneficiaryType.beneficiaryTypeName = "Person"
        personBeneficiary.beneficiaryType = beneficiaryType
        personBeneficiary.bankName = self.bankTextField.text
        personBeneficiary.accountNumber = self.accountTextField.text
        personBeneficiary.iban = self.IBanTextField.text
        personBeneficiary.country = selectedCountry
        personBeneficiary.city = selectedCity
        personBeneficiary.bankName = selectedBank
        personBeneficiary.beneficiaryName = self.benificiaryNameTextField.text
        personBeneficiary.workPhone = self.beneficiaryWorkPhoneTextField.text
        personBeneficiary.housePhone = self.beneficiaryHousePhoneTextField.text
        personBeneficiary.mobileNumber = self.benificiaryTelephoneTextField.text
        personBeneficiary.email = self.beneficiaryEmailTextField.text
        personBeneficiary.customer = self.customer
        //set nil value
        personBeneficiary.setNilValueToObject(beneficiary: personBeneficiary)
        //convert to json
        let beneficiaryJson :[String:AnyObject] = (personBeneficiary.toJson(beneficiary: personBeneficiary) as [String : AnyObject])
        // prepaer param array
        let params:[String:Any] = [
            "operation": "create" ,
            "tableName":  "Beneficiary" ,
            "payload": ["Item":beneficiaryJson]
        ]
        //call save function
        let genericServices = ApiGatway.api
        genericServices.save(params: params, onComplete:{ (status) in
            if (status == 1) {
                DispatchQueue.main.async {
                    self.parent?.view.makeToast("adding successful")
                    self.beneficiaryEmailTextField.text = ""
                    self.beneficiaryHousePhoneTextField.text = ""
                    self.IBanTextField.text = ""
                    self.beneficiaryWorkPhoneTextField.text = ""
                    self.accountTextField.text = ""
                    self.bankTextField.text = ""
                    self.cityTextField.text = ""
                    self.countryTextField.text = ""
                    self.benificiaryTelephoneTextField.text = ""
                    self.benificiaryNameTextField.text = ""
                    if self.benificiarDelegate != nil {
                        self.benificiarDelegate.fillBenificiaryList(benificiary: (personBeneficiary.beneficiaryName)!)
                    }
                    self.dismiss(animated: true, completion: {})
                }
            }
            else {
                DispatchQueue.main.async {
                    self.parent?.view.makeToast("adding failed")
                    self.dismiss(animated: true, completion: {})
                }
            }
        })
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
        // let genericServices = ApiGatway.api
        let bankParams:[String:Any] =  [
            "operation": "list" ,
            "tableName":  "Bank" ,
            "payload": []
        ]
        genericServices.scan(params: bankParams, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let bank = result
                    self.banks.append(bank["BankName"] as! String)
                }
                self.bankNamesTableView.reloadData()
            }
        })
    }
    func getCityForCountry() {
        
        let countryName = countryTextField.text!
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
                self.cities.removeAll()
                for result in resultsArray { // For each element in resultArray
                    let city = result
                    if city["cityName"] != nil {
                        self.cities.append(city["cityName"] as! String)
                    }
                }
                DispatchQueue.main.async{
                    self.cityTableView.reloadData()
                }
            }
            
        })
        
    }
    
    
    //keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.scrollRectToVisible(textField.frame, animated: true)
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
    func updateLayout() {
        //let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        //self.benificiaryUsers.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
        // self.addButton.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
        // self.cancelButton.backgroundColor = UIColor(hexString: dic["themeColor1"]!)
        //self.addDefaultSmallView.backgroundColor = UIColor(hexString:dic["themeColor1"]!)
        //self.addNavWithLogo(image: dic["logo"]!)
        //self.navigationController?.navigationBar.barTintColor = UIColor(hexString: dic["themeColor1"]!)
        addButton.layer.borderColor = UIColor.white.cgColor
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        
        
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1
    }
    
    /*
     
     @IBOutlet var bankNameBtnSelected: UIButton!
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
