//
//  NewBillBenViewController.swift
//  SIM
//
//  Created by SSS on 10/23/17.
//  Copyright © 2017 SSS. All rights reserved.

import AWSCognitoIdentityProvider
import AWSDynamoDB
import UIKit
import RealmSwift

class AddBillBeneficiaryViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {

    @IBOutlet weak var serviceProviderTableview: UITableView!
    @IBOutlet weak var countryTableview: UITableView!
    @IBOutlet weak var serviceProviderTextField: UITextField!
    @IBOutlet weak var serviceNumberTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var isCountryFieldopen : Bool = false
    var country : String?
    var customer:Customer?
    var serviceProvider : String?
    var countriesList = [String]()
    var selectedServiceProvider = ServiceProvider()
    var selectedCountry = Country()
    let userDefaults = UserDefaults.standard
    var serviceProvidersList = [String]()
    var isServiceProvidersOpen : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceProviderTableview.dataSource = self
        serviceProviderTableview.delegate = self
        
        countryTableview.delegate = self
        countryTableview.dataSource = self
        let realm = try! Realm()
        let customers = realm.objects(Customer.self)
        if customers.count != 0 {
            self.customer = customers.first
        }
        
        UpdateLayout()
        scanCountries()
        scanServiceProviders()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        serviceProviderTextField.addLineBelowTextField()
        serviceNumberTextField.addLineBelowTextField()
        countryTextField.addLineBelowTextField()
    }
    func scanServiceProviders()
    {
        let genericServices = ApiGatway.api
        let params:[String:Any] =  [
            "operation": "list" ,
            "tableName":  "ServiceProvider" ,
            "payload": []
        ]
        genericServices.scan(params: params, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let serviceProvider = result as? NSDictionary
                    self.serviceProvidersList.append(serviceProvider?["serviceProviderName"] as! String)
                }
                self.serviceProviderTableview.reloadData()
            }
        })
    }
   
    
    @IBAction func onClickCancel(_ sender: Any) {
        
        self.serviceNumberTextField.text = ""
        self.countryTextField.text = ""
        self.serviceProviderTextField.text = ""
    }
    func scanCountries()
    {
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
                    let country = result as? NSDictionary
                    self.countriesList.append(country?["countryName"] as! String)
                }
                self.countryTableview.reloadData()
            }
        })
    }

    @IBAction func onSelectServiceProvider(_ sender: Any) {
        if isServiceProvidersOpen == false {
            serviceProviderTableview.isHidden = false
            serviceProviderTableview.reloadData()
            isServiceProvidersOpen = true
        }
        else {
            serviceProviderTableview.isHidden = true
            isServiceProvidersOpen = false
            
        }
    }
    @IBAction func onSelectCountry(_ sender: Any) {
        if isCountryFieldopen == false {
            countryTableview.isHidden = false
            countryTableview.reloadData()
            isCountryFieldopen = true
        }
        else {
            countryTableview.isHidden = true
            isCountryFieldopen = false
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == countryTableview {
            return countriesList.count
        }
        else {
            return serviceProvidersList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == countryTableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell")
            cell?.textLabel?.text = countriesList[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = UIColor.white
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "serviceProvider")
            cell?.textLabel?.text = serviceProvidersList[indexPath.row]
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            return cell!
        }
    }
    
    
    @IBAction func clickOnSave(_ sender: Any) {
        self.view.endEditing(true)
        createBillBeneficiary()
    }

    func createBillBeneficiary() {
        let billBeneficiary = Beneficiary()
        billBeneficiary.uuid = UUID().uuidString
        let beneficiaryType = BeneficiaryType()
        beneficiaryType.uuid = UUID().uuidString
        beneficiaryType.beneficiaryTypeName = "E-Services (Bill)"
        billBeneficiary.beneficiaryType = beneficiaryType
        billBeneficiary.country = selectedCountry
        billBeneficiary.serviceProvider = selectedServiceProvider
        billBeneficiary.serviceNumber = serviceNumberTextField.text
        billBeneficiary.customer = self.customer
        //set nil value
        billBeneficiary.setNilValueToObject(beneficiary: billBeneficiary)
        //convert to json
        let beneficiaryJson :[String:AnyObject] = (billBeneficiary.toJson(beneficiary: billBeneficiary) as [String : AnyObject])
        let params:[String:Any] = [
            "operation": "create" ,
            "tableName":  "Beneficiary" ,
            "payload": ["Item":beneficiaryJson]
        ]
         print(params)
        //call save function
        let genericServices = ApiGatway.api
        genericServices.save(params: params, onComplete:{ (status) in
            if (status == 1) {
                DispatchQueue.main.async {
                    self.parent?.view.makeToast("adding successful")
                    self.serviceNumberTextField.text = ""
                    self.countryTextField.text = ""
                    self.serviceProviderTextField.text = ""
                }
            }
            else {
                DispatchQueue.main.async {
                    self.parent?.view.makeToast("adding failed")
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func UpdateLayout()
    {
//        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
//        saveBtn.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
//        saveBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
//        
//        cancelBtn.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
//        cancelBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        saveBtn.layer.borderColor = UIColor.white.cgColor
        saveBtn.layer.cornerRadius = 5
        saveBtn.layer.borderWidth = 1
        
        
        cancelBtn.layer.borderColor = UIColor.white.cgColor
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderWidth = 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == countryTableview {
            countryTextField.text = countriesList[indexPath.row]
            self.selectedCountry.uuid = UUID().uuidString
            self.selectedCountry.countryName = countryTextField.text
            countryTableview.isHidden = true
            isCountryFieldopen = false
        }
        else {
            serviceProviderTextField.text = serviceProvidersList[indexPath.row]
            serviceProviderTableview.isHidden = true
            isServiceProvidersOpen = false
            self.selectedServiceProvider.uuid = UUID().uuidString
            self.selectedServiceProvider.serviceProviderName = serviceProviderTextField.text
           
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
