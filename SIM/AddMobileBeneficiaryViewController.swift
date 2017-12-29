//
//  AddNewMobileNumViewController.swift
//  SIM
//
//  Created by SSS on 10/23/17.
//  Copyright � 2017 SSS. All rights reserved.
//
import AWSCognitoIdentityProvider
import AWSDynamoDB
import UIKit
import RealmSwift


class AddMobileBeneficiaryViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var telecomCompanyTableView: UITableView!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var telecomCompanyTextField: UITextField!
    @IBOutlet weak var mobileNumTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var countriesList = [String]()
    var backgroundImageName:String?
    var customer:Customer?
    var telecomCompanyList = [String]()
    var selectedCountry = Country()
    let userDefaults = UserDefaults.standard
    var selectedTelecomProvider = TelecomProvider()
    var benificiarDelegate:BenificiaryListViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        telecomCompanyTableView.delegate = self
        telecomCompanyTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.dataSource = self
        UpdateLayout()
        let realm = try! Realm()
        let customers = realm.objects(Customer.self)
        if customers.count != 0 {
            self.customer = customers.first
        }
        scanCountries()
        scanTelecomProviders()
        hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if backgroundImageName != nil {
            
            self.background.image = UIImage(named:backgroundImageName!)
        }
        self.telecomCompanyTextField.addLineBelowTextField()
        self.mobileNumTextField.addLineBelowTextField()
        self.countryTextField.addLineBelowTextField()
    }
    
    func scanCountries() {
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
                self.countryTableView.reloadData()
            }
        })
    }
    func scanTelecomProviders() {
        let genericServices = ApiGatway.api
        let params:[String:Any] =  [
            "operation": "list" ,
            "tableName":  "TelecomProvider" ,
            "payload": []
        ]
        genericServices.scan(params: params, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let telecomProvider = result as? NSDictionary
                    self.telecomCompanyList.append(telecomProvider?["telecomProviderName"] as! String)
                }
                self.telecomCompanyTableView.reloadData()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == countryTableView {
            return countriesList.count
        }
        else {
            return telecomCompanyList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == countryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell")
            cell?.textLabel?.text = countriesList[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = UIColor.white
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "telecomCell")
            cell?.textLabel?.text = telecomCompanyList[indexPath.row]
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.textColor = UIColor.white
            return cell!
        }
    }
    @IBAction func onCancelClick(_ sender: Any) {
        self.telecomCompanyTextField.text = ""
        self.countryTextField.text = ""
        self.mobileNumTextField.text = ""
    }
    
    func createMobileBeneficiary() {
        let mobileBeneficiary = Beneficiary()
        mobileBeneficiary.uuid = UUID().uuidString
        let beneficiaryType = BeneficiaryType()
        beneficiaryType.uuid = UUID().uuidString
        beneficiaryType.beneficiaryTypeName = "Mobile TopUp"
        mobileBeneficiary.beneficiaryType = beneficiaryType
        mobileBeneficiary.customer = self.customer
        mobileBeneficiary.mobileNumber = mobileNumTextField.text
        mobileBeneficiary.country = selectedCountry
        mobileBeneficiary.telecomProvider = selectedTelecomProvider
        mobileBeneficiary.customer = self.customer
        //set nil value
        mobileBeneficiary.setNilValueToObject(beneficiary: mobileBeneficiary)
        //convert to json
        let beneficiaryJson :[String:AnyObject] = (mobileBeneficiary.toJson(beneficiary: mobileBeneficiary) as [String : AnyObject])

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
                    if self.benificiarDelegate != nil {
                        self.benificiarDelegate.fillBenificiaryList(benificiary: (mobileBeneficiary.mobileNumber)!)
                    }
                    self.telecomCompanyTextField.text = ""
                    self.countryTextField.text = ""
                    self.mobileNumTextField.text = ""
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
        createMobileBeneficiary()
    }
    
    @IBAction func onSelectCountry(_ sender: Any) {
        if countryTableView.isHidden {
            countryTableView.isHidden = false
            countryTableView.reloadData()
        }
        else {
            countryTableView.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectTelecomCompany(_ sender: Any) {
        if telecomCompanyTableView.isHidden{
            telecomCompanyTableView.isHidden = false
            telecomCompanyTableView.reloadData()
        }
        else{
            telecomCompanyTableView.isHidden = true
        }
    }
    
    func UpdateLayout() {
//        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
//        saveBtn.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
//        saveBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
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
        if tableView == countryTableView {
            countryTextField.text = countriesList[indexPath.row]
            countryTableView.isHidden = true
            self.selectedCountry.uuid = UUID().uuidString
            self.selectedCountry.countryName = countryTextField.text
           }
        else {
            telecomCompanyTextField.text = telecomCompanyList[indexPath.row]
            telecomCompanyTableView.isHidden = true
            self.selectedTelecomProvider.uuid = UUID().uuidString
            self.selectedTelecomProvider.telecomProviderName = telecomCompanyTextField.text
         
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
