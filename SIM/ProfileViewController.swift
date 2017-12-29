//
//  ProfileViewController.swift
//  SIM
//
//  Created by Rimon on 10/3/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RealmSwift

class ProfileViewController: BaseViewController ,UITextFieldDelegate , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var datePiker: UIDatePicker!
    var languagearray = [String]()
    @IBOutlet weak var datePickerView: UIView!
    var countryarray = [String]()
    var cityarray = [String]()
    var nationaltyArray = [String]()
    var rewardLocationArray = [String]()
    var regionArray = [String]()
    var isEdit: Bool = false
    var customer:Customer!
    var userDefaults =  UserDefaults.standard
    var ispreferedlang :Bool = false
    var updatedCustomer = Customer()
    @IBOutlet weak var loader: NVActivityIndicatorView!
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var city: GrayTextField!
    @IBOutlet weak var DateOfBirthdayTextField: GrayTextField!
    @IBOutlet weak var country: GrayTextField!
    @IBOutlet weak var address: GrayTextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var preferdLang: GrayTextField!
    @IBOutlet weak var nationalityTextField: GrayTextField!
    @IBOutlet weak var homePhone: GrayTextField!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var workPhone: GrayTextField!
    @IBOutlet weak var mobileNumber: GrayTextField!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var femaleRadioButton: DLRadioButton!
    @IBOutlet weak var regionButton: UIButton!
    @IBOutlet weak var rewardLocationButton: UIButton!
    @IBOutlet weak var marriedButton: UIButton!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var preferredLanguage: UIButton!
    @IBOutlet weak var nationalityButton: UIButton!
    @IBOutlet weak var regionTextField: GrayTextField!
    @IBOutlet weak var MarriedRadioButton: DLRadioButton!
    @IBOutlet weak var singleRadioButton: DLRadioButton!
    @IBOutlet weak var mailBoxTextField: GrayTextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rewordLocationTextField: GrayTextField!
    @IBOutlet weak var maleRadioButton: DLRadioButton!
    @IBOutlet weak var Name: GrayTextField!
    
    @IBOutlet weak var langTbelview: UITableView!
    @IBOutlet weak var countryTabelview: UITableView!
    @IBOutlet weak var cityTabelview: UITableView!
    @IBOutlet weak var regionTableView: UITableView!
    @IBOutlet weak var rewardLocationTableView: UITableView!
    @IBOutlet weak var nationalityTableView: UITableView!
    @IBOutlet weak var loaderView: UIView!
    var updateValue :String = " "
    var expressionAttributeValues = [String:Any]()
    
    @IBOutlet weak var birthDay: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataForTables()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        updateLayout()
        let scrollGesture = UITapGestureRecognizer(target: self, action: #selector(self.onGesture(sender:)))
        contentView.addGestureRecognizer(scrollGesture)
        // Do any additional setup after loading the view.
        langTbelview.delegate = self
        langTbelview.isHidden = true
        countryTabelview.delegate = self
        countryTabelview.isHidden = true
        cityTabelview.delegate = self
        cityTabelview.isHidden = true
        
        let realm = try! Realm()
        if realm.objects(Customer.self).count != 0 {
            self.customer = realm.objects(Customer.self).first!
        }
        
        if customer.userName != nil {
            fillTextField(realmCustomer: self.customer)
        }
        
        langTbelview.dataSource = self
        countryTabelview.dataSource = self
        cityTabelview.dataSource = self
        regionTableView.dataSource = self
        rewardLocationTableView.dataSource = self
        nationalityTableView.dataSource = self
        
        langTbelview.delegate = self
        countryTabelview.delegate = self
        cityTabelview.delegate = self
        regionTableView.delegate = self
        rewardLocationTableView.delegate = self
        nationalityTableView.delegate = self
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
                    self.countryarray.append(country["countryName"] as! String)
                }
                self.countryTabelview.reloadData()
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
                    self.languagearray.append(language["preferredLanguageName"] as! String)
                }
                self.langTbelview.reloadData()
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
                    self.regionArray.append(region["regionName"] as! String)
                }
                self.regionTableView.reloadData()
            }
        })
        // scan rewardLocation Table
        let rewardLocationParams:[String:Any] =  [
            "operation": "list" ,
            "tableName":  "RewardLocation" ,
            "payload": []
        ]
        genericServices.scan(params: rewardLocationParams, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let rewardLocation = result
                    self.rewardLocationArray.append(rewardLocation["rewardLocationName"] as! String)
                }
                self.rewardLocationTableView.reloadData()
            }
        })
        // scan nationality Table
        let nationalityParams:[String:Any] =  [
            "operation": "list" ,
            "tableName":  "Nationality" ,
            "payload": []
        ]
        genericServices.scan(params: nationalityParams, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let nationality = result
                    self.nationaltyArray.append(nationality["nationalityName"] as! String)
                }
                self.nationalityTableView.reloadData()
            }
        })
        
    }
    
    func fillTextField(realmCustomer:Customer) {
        
        if realmCustomer.city != nil {
            self.city.text = realmCustomer.city.cityName
        }
        if realmCustomer.country != nil {
            self.country.text = realmCustomer.country.countryName
        }
        if realmCustomer.nationality != nil {
            self.nationalityTextField.text = realmCustomer.nationality.nationalityName
        }
        if realmCustomer.preferredLanguage  != nil {
            self.preferdLang.text = realmCustomer.preferredLanguage.preferredLanguageName
        }
        if realmCustomer.region  != nil {
            self.regionTextField.text = realmCustomer.region.regionName
        }
        if realmCustomer.birthDay != nil {
            self.DateOfBirthdayTextField.text = realmCustomer.birthDay
        }
        if realmCustomer.address != nil {
            self.address.text = realmCustomer.address
        }
        if realmCustomer.workPhone != nil {
            self.workPhone.text = realmCustomer.workPhone
        }
        if realmCustomer.housePhone != nil {
            self.homePhone.text = realmCustomer.housePhone
        }
        if realmCustomer.mobileNumber != nil {
            self.mobileNumber.text = realmCustomer.mobileNumber
        }
        if realmCustomer.email != nil {
            self.email.text = realmCustomer.email
        }
        
        if realmCustomer.userName != nil {
            self.userName.text = realmCustomer.userName
        }
        if realmCustomer.gender  != nil {
            if realmCustomer.gender.genderName == "Female" {
                self.femaleRadioButton.isSelected = true
            }
            else {
                self.maleRadioButton.isSelected = true
            }
        }
        if realmCustomer.maritalStatus != nil {
            if realmCustomer.maritalStatus.maritalStatusName == "Single" {
                self.singleRadioButton.isSelected = true
            }
            else {
                self.MarriedRadioButton.isSelected = true
            }
        }
        if realmCustomer.rewardLocation != nil {
            self.rewordLocationTextField.text = realmCustomer.rewardLocation.rewardLocationName
        }
        if realmCustomer.customerName != nil {
            self.Name.text = realmCustomer.customerName
        }
        if realmCustomer.mailBox != nil {
            self.mailBoxTextField.text = realmCustomer.mailBox
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func onSelectNationality(_ sender: Any) {
        if nationalityTableView.isHidden {
            self.nationalityTableView.isHidden = false
        }
        else {
            self.nationalityTableView.isHidden = true
        }
    }
    
    @IBAction func selectMaleRadioButton(_ sender: Any) {
        self.maleRadioButton.isSelected = true
        let gender = Gender()
        gender.genderName = "Male"
        gender.uuid = UUID().uuidString
        self.updatedCustomer.gender = gender
    }
    
    @IBAction func selectFemaleRadioButton(_ sender: Any) {
        self.femaleRadioButton.isSelected = true
        let gender = Gender()
        gender.genderName = "Female"
        gender.uuid = UUID().uuidString
        self.updatedCustomer.gender = gender
    }
    @IBAction func onSelectPrefLang(_ sender: Any) {
        if langTbelview.isHidden {
            self.langTbelview.isHidden = false
            self.view.bringSubview(toFront: langTbelview)
        } else {
            self.langTbelview.isHidden = true
        }
    }
    @IBAction func onSelectCountry(_ sender: Any) {
        if  countryTabelview.isHidden {
            self.countryTabelview.isHidden = false
            self.view.bringSubview(toFront: countryTabelview)
        } else {
            self.countryTabelview.isHidden = true
        }
    }
    @IBAction func onSelectCity(_ sender: Any) {
        if cityTabelview.isHidden  {
            self.cityTabelview.isHidden = false
            self.view.bringSubview(toFront: cityTabelview)
        } else {
            self.cityTabelview.isHidden = true
        }
    }
    
    @IBAction func selectSingleRadioButton(_ sender: Any) {
        self.singleRadioButton.isSelected = true
        let maritalStatus = MaritalStatus()
        maritalStatus.maritalStatusName = "Single"
        maritalStatus.uuid = UUID().uuidString
        self.updatedCustomer.maritalStatus = maritalStatus
        
    }
    @IBAction func selectMarriedRadioButton(_ sender: Any) {
        self.MarriedRadioButton.isSelected = true
        let maritalStatus = MaritalStatus()
        maritalStatus.maritalStatusName = "Married"
        maritalStatus.uuid = UUID().uuidString
        self.updatedCustomer.maritalStatus = maritalStatus
        
    }
    
    @IBAction func onSelectRegion(_ sender: Any) {
        if regionTableView.isHidden {
            self.regionTableView.isHidden = false
        }
        else {
            self.regionTableView.isHidden = true
        }
    }
    
    
    @IBAction func onSelectRewordLocation(_ sender: Any) {
        if self.rewardLocationTableView.isHidden {
            self.rewardLocationTableView.isHidden = false
        }
        else {
            self.rewardLocationTableView.isHidden = true
        }
    }
    @IBAction func clearDate(_ sender: Any) {
        self.datePickerView.isHidden = true // // hide the picker view
        
        // Clear the date of fromDateTextField or toDateTextField depend on choosenDate
        
        self.DateOfBirthdayTextField.text = ""
        
    }
    
    @IBAction func chooseDate(_ sender: Any) {
        self.datePickerView.isHidden = true // hide the picker view
        // Create dateFormatter and set the format which i want
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy"
        let date = self.datePiker.date
        var dateComponent = DateComponents()
        dateComponent.year = -10
        let newDate = Calendar.current.date(byAdding: dateComponent, to: NSDate() as Date)
        
        if date > newDate! {
            let alertController = UIAlertController(title: "Error",
                                                    message: "Please enter valid date",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default ,handler: { (action) in
                self.DateOfBirthdayTextField.text = ""
            })
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion:  nil)
        }
        else  {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat="MM/dd/yyyy"
            let date2 = dateFormatter2.string(from: self.datePiker.date)
            self.DateOfBirthdayTextField.text = date2
            self.updatedCustomer.birthDay = date2
        }
        
    }
    
    
    
    @IBAction func selectBirthDay(_ sender: Any) {
        if datePickerView.isHidden {
            self.view.endEditing(true)
            datePickerView.isHidden = false
        }
        else {
            self.view.endEditing(true)
            datePickerView.isHidden = true
        }
        
    }
    
    //keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.scrollRectToVisible(textField.frame, animated: true)
        
        
    }
    func textFieldDidEndEditing (_ textField: UITextField) {
        switch textField {
        case address:
            self.updatedCustomer.address = address.text
        case Name:
            self.updatedCustomer.customerName = Name.text
            
        case DateOfBirthdayTextField:
            self.updatedCustomer.birthDay = DateOfBirthdayTextField.text
            
        case address:
            self.updatedCustomer.address = address.text
        case mailBoxTextField:
            self.updatedCustomer.mailBox = mailBoxTextField.text
            
        case workPhone:
            self.updatedCustomer.workPhone = workPhone.text
            
        case homePhone:
            self.updatedCustomer.housePhone = homePhone.text
            
            
        default:
            break
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
        city.resignFirstResponder()
        country.resignFirstResponder()
        address.resignFirstResponder()
        preferdLang.resignFirstResponder()
        homePhone.resignFirstResponder()
        workPhone.resignFirstResponder()
        mobileNumber.resignFirstResponder()
        
    }
    
    
    func updateLayout() {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.addNavWithLogo(image: dic["logo"]!)
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
        self.savebtn.backgroundColor = UIColor(hex:dic["themeColor1"]!)
        self.savebtn.titleLabel?.textColor = UIColor.white
        self.langTbelview.layer.borderColor = UIColor(hex: dic["themeColor1"]!).cgColor
        self.countryTabelview.layer.borderColor = UIColor(hex: dic["themeColor1"]!).cgColor
        self.cityTabelview.layer.borderColor = UIColor(hex: dic["themeColor1"]!).cgColor
        self.regionTableView.layer.borderColor = UIColor(hex: dic["themeColor1"]!).cgColor
        self.nationalityTableView.layer.borderColor = UIColor(hex: dic["themeColor1"]!).cgColor
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case langTbelview :
            return languagearray.count
        case countryTabelview :
            return countryarray.count
        case cityTabelview :
            return cityarray.count
        case nationalityTableView :
            return nationaltyArray.count
        case regionTableView :
            return regionArray.count
        case rewardLocationTableView :
            return rewardLocationArray.count
        default :
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case langTbelview :
            cell = tableView.dequeueReusableCell(withIdentifier: "celllang", for: indexPath)
            cell.textLabel?.text = languagearray[indexPath.row]
            return cell
        case countryTabelview :
            cell = tableView.dequeueReusableCell(withIdentifier: "cellcountry", for: indexPath)
            cell.textLabel?.text = countryarray[indexPath.row]
            return cell
        case cityTabelview :
            cell = tableView.dequeueReusableCell(withIdentifier: "cellcity", for: indexPath)
            cell.textLabel?.text = cityarray[indexPath.row]
            return cell
        case nationalityTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "nationality", for: indexPath)
            cell.textLabel?.text = nationaltyArray[indexPath.row]
            return cell
        case regionTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "region", for: indexPath)
            cell.textLabel?.text = regionArray[indexPath.row]
            return cell
        case rewardLocationTableView :
            cell = tableView.dequeueReusableCell(withIdentifier: "rewardLocation", for: indexPath)
            cell.textLabel?.text = rewardLocationArray[indexPath.row]
            return cell
        default :
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case langTbelview :
            let cell = langTbelview.cellForRow(at: indexPath)
            self.preferdLang.text = cell?.textLabel?.text
            langTbelview.isHidden = true
            let newLanguage = Languages()
            newLanguage.preferredLanguageName = self.preferdLang.text
            newLanguage.uuid = UUID().uuidString
            self.updatedCustomer.preferredLanguage = newLanguage
            
            
            
        case countryTabelview :
            let cell = countryTabelview.cellForRow(at: indexPath)
            self.country.text = cell?.textLabel?.text
            countryTabelview.isHidden = true
            let newCountry = Country()
            newCountry.countryName = self.country.text
            newCountry.uuid = UUID().uuidString
            self.updatedCustomer.country = newCountry
            getCityForCountry()
            
        case cityTabelview :
            let  cell = cityTabelview.cellForRow(at: indexPath)
            self.city.text = cell?.textLabel?.text
            cityTabelview.isHidden = true
            let newCity = City()
            newCity.cityName = self.city.text
            newCity.uuid = UUID().uuidString
            newCity.country = updatedCustomer.country
            self.updatedCustomer.city = newCity
            
        case nationalityTableView :
            let  cell = nationalityTableView.cellForRow(at: indexPath)
            self.nationalityTextField.text = cell?.textLabel?.text
            nationalityTableView.isHidden = true
            let nationality = Nationality()
            nationality.nationalityName = self.nationalityTextField.text
            nationality.uuid = UUID().uuidString
            self.updatedCustomer.nationality = nationality
            
        case regionTableView :
            let  cell = regionTableView.cellForRow(at: indexPath)
            self.regionTextField.text = cell?.textLabel?.text
            regionTableView.isHidden = true
            let region = Region()
            region.regionName = self.regionTextField.text
            region.uuid = UUID().uuidString
            self.updatedCustomer.region = region
            
        case rewardLocationTableView :
            let  cell = rewardLocationTableView.cellForRow(at: indexPath)
            self.rewordLocationTextField.text = cell?.textLabel?.text
            rewardLocationTableView.isHidden = true
            let rewardLocation = RewardLocation()
            rewardLocation.rewardLocationName = self.rewordLocationTextField.text
            rewardLocation.uuid = UUID().uuidString
            self.updatedCustomer.rewardLocation = rewardLocation
            
        default :
            break
        }
        
    }
    
    @IBAction func onSave(_ sender: Any) {
        saveCustomer(sender as AnyObject)
        
    }
    
    
    func getCityForCountry() {
        
        let countryName = country.text!
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
                self.cityarray.removeAll()
                for result in resultsArray { // For each element in resultArray
                    let city = result
                    if city["cityName"] != nil {
                        self.cityarray.append(city["cityName"] as! String)
                    }
                }
                DispatchQueue.main.async{
                    self.cityTabelview.reloadData()
                }
            }
            
        })
        
    }
    @IBAction func onEdit(_ sender: UIButton) {
        if isEdit == false {
            //startUpdate()
            editProfileButton.setTitle("cancel", for: .normal)
            editFields()
            isEdit = true
        }else {
            isEdit = false
            cancelEdit()
            editProfileButton.setTitle("Edit Profile", for: .normal)
            
        }
        
    }
    
    func editFields() {
        DateOfBirthdayTextField.isUserInteractionEnabled = true
        maleRadioButton.isUserInteractionEnabled = true
        femaleRadioButton.isUserInteractionEnabled = true
        singleRadioButton.isUserInteractionEnabled = true
        MarriedRadioButton.isUserInteractionEnabled = true
        birthDay.isUserInteractionEnabled = true
        country.isUserInteractionEnabled = true
        address.isUserInteractionEnabled = true
        maleButton.isUserInteractionEnabled = true
        homePhone.isUserInteractionEnabled = true
        femaleButton.isUserInteractionEnabled = true
        workPhone.isUserInteractionEnabled = true
        mobileNumber.isUserInteractionEnabled = false
        regionButton.isUserInteractionEnabled = true
        mailBoxTextField.isUserInteractionEnabled = true
        rewardLocationButton.isUserInteractionEnabled = true
        marriedButton.isUserInteractionEnabled = true
        singleButton.isUserInteractionEnabled = true
        cityButton.isUserInteractionEnabled = true
        countryButton.isUserInteractionEnabled = true
        preferredLanguage.isUserInteractionEnabled = true
        nationalityButton.isUserInteractionEnabled = true
        Name.isUserInteractionEnabled = true
        self.saveView.isHidden = false
        self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y, width: self.contentView.frame.width, height: self.saveView.frame.height + self.contentView.frame.height + 50)
        self.contentView.layoutIfNeeded()
        
    }
    func cancelEdit() {
        
        DispatchQueue.main.async {
            self.fillTextField(realmCustomer: self.customer)
            
        }
        
        disableTextFields()
        
    }
    func disableTextFields() {
    
        fillTextField(realmCustomer: self.updatedCustomer)
        maleRadioButton.isUserInteractionEnabled = false
        femaleRadioButton.isUserInteractionEnabled = false
        singleRadioButton.isUserInteractionEnabled = false
        MarriedRadioButton.isUserInteractionEnabled = false
        birthDay.isUserInteractionEnabled = false
        DateOfBirthdayTextField.isUserInteractionEnabled = false
        country.isUserInteractionEnabled = false
        mailBoxTextField.isUserInteractionEnabled = false
        address.isUserInteractionEnabled = false
        maleButton.isUserInteractionEnabled = false
        homePhone.isUserInteractionEnabled = false
        femaleButton.isUserInteractionEnabled = false
        workPhone.isUserInteractionEnabled = false
        mobileNumber.isUserInteractionEnabled = false
        regionButton.isUserInteractionEnabled = false
        rewardLocationButton.isUserInteractionEnabled = false
        marriedButton.isUserInteractionEnabled = false
        singleButton.isUserInteractionEnabled = false
        cityButton.isUserInteractionEnabled = false
        countryButton.isUserInteractionEnabled = false
        preferredLanguage.isUserInteractionEnabled = false
        nationalityButton.isUserInteractionEnabled = false
        mailBoxTextField.isUserInteractionEnabled = false
        Name.isUserInteractionEnabled = false
        self.saveView.isHidden = true
        self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y, width: self.contentView.frame.width, height: self.contentView.frame.height - self.saveView.frame.height - 50)
        self.contentView.layoutIfNeeded()

    }
    func startUpdate()  {
        address.isEnabled = true
        homePhone.isEnabled = true
        workPhone.isEnabled = true
        mobileNumber.isEnabled = true
        
    }
    
    func saveCustomer(_ sender :AnyObject) {
        loaderView.isHidden = false
        loader.startAnimating()
        // customer?.setNilValueToObject(customer: self.customer!)
        let genericServices = ApiGatway.api
        if updatedCustomer.customerName != nil {
            if   updatedCustomer.customerName != "" {
                updateValue.append(" set customerName = :val1 ")
                expressionAttributeValues[":val1"] = self.updatedCustomer.customerName
                
            }
        }
        if updatedCustomer.gender != nil  {
            if updatedCustomer.gender.genderName != nil || updatedCustomer.gender.genderName != "" {
                if updateValue.contains("set") {
                    updateValue.append(", gender = :val2")
                }
                else {
                    updateValue.append(" set gender = :val2")
                }
                expressionAttributeValues[":val2"] = Gender().toDictionary(gender: self.updatedCustomer.gender)
                
            }
        }
        if updatedCustomer.birthDay != nil {
            if updatedCustomer.birthDay != ""  {
                if updateValue.contains("set") {
                    updateValue.append(" , birthDay = :val3")
                }
                else {
                    updateValue.append("set birthDay = :val3")
                }
                expressionAttributeValues[":val3"] = self.updatedCustomer.birthDay
            }
        }
        if updatedCustomer.nationality != nil {
            if updatedCustomer.nationality.nationalityName != nil || updatedCustomer.nationality.nationalityName != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , nationality = :val4")
                }
                else {
                    updateValue.append(" set nationality = :val4")
                }
                expressionAttributeValues[":val4"] = Nationality().toDictionary(nationality:self.updatedCustomer.nationality)
            }
        }
        if updatedCustomer.mobileNumber != nil {
            if updatedCustomer.mobileNumber != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , mobileNumber = :val5")
                }
                else {
                    updateValue.append("set  mobileNumber = :val5")
                }
                expressionAttributeValues[":val5"] = self.updatedCustomer.mobileNumber
                
            }
        }
        if updatedCustomer.workPhone != nil {
            if updatedCustomer.workPhone != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , workPhone = :val6")
                }
                else {
                    updateValue.append(" set workPhone = :val6")
                }
                expressionAttributeValues[":val6"] = self.updatedCustomer.workPhone
            }
        }
        if updatedCustomer.housePhone != nil {
            if updatedCustomer.housePhone != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , housePhone = :val7")
                }
                else {
                    updateValue.append(" set housePhone = :val7")
                    
                }
                expressionAttributeValues[":val7"] = self.updatedCustomer.housePhone
            }
        }
        if updatedCustomer.email != nil {
            if updatedCustomer.email != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , email = :val8")
                }
                else {
                    updateValue.append("set email = :val8")
                }
                expressionAttributeValues[":val8"] = self.updatedCustomer.email
            }
        }
        if updatedCustomer.preferredLanguage != nil  {
            if updatedCustomer.preferredLanguage.preferredLanguageName != nil || updatedCustomer.preferredLanguage.preferredLanguageName != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , preferredLanguage = :val9")
                }
                else {
                    updateValue.append(" set preferredLanguage = :val9")
                }
                expressionAttributeValues[":val9"] = Languages().toDictionary(languages: self.updatedCustomer.preferredLanguage)
            }
        }
        if updatedCustomer.address != nil {
            if  updatedCustomer.address != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , address = :val10")
                }
                else {
                    updateValue.append(" set address = :val10")
                }
                expressionAttributeValues[":val10"] = self.updatedCustomer.address
            }
        }
        if updatedCustomer.country != nil  {
            if updatedCustomer.country.countryName != nil || updatedCustomer.country.countryName != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , country = :val11")
                }
                else {
                    updateValue.append(" set country = :val11")
                }
                expressionAttributeValues[":val11"] = Country().toDictionary(country: (self.updatedCustomer.country)!)
            }
        }
        
        if updatedCustomer.city != nil  {
            if updatedCustomer.city.cityName != nil || updatedCustomer.city.cityName != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , city = :val12")
                }
                else {
                    updateValue.append(" set city = :val12")
                }
                expressionAttributeValues[":val12"] = City().toDictionary(city: (self.updatedCustomer.city)!)    }
        }
        if updatedCustomer.mailBox != nil {
            if  updatedCustomer.mailBox != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , mailBox = :val13")
                }
                else {
                    updateValue.append("set mailBox = :val13")
                }
                expressionAttributeValues[":val13"] = self.updatedCustomer.mailBox
            }
        }
        if updatedCustomer.maritalStatus != nil  {
            if updatedCustomer.maritalStatus.maritalStatusName != nil || updatedCustomer.maritalStatus.maritalStatusName != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , maritalStatus = :val14")
                }
                else {
                    updateValue.append(" set maritalStatus = :val14")
                }
                expressionAttributeValues[":val14"] = MaritalStatus().toDictionary(maritalStatus:(self.updatedCustomer.maritalStatus!))
            }
        }
        
        if updatedCustomer.rewardLocation != nil  {
            if updatedCustomer.rewardLocation.rewardLocationName != nil || updatedCustomer.rewardLocation.rewardLocationName != "" {
                if updateValue.contains("set") {
                    updateValue.append(" , rewardLocation = :val16")
                }
                else {
                    updateValue.append(" set rewardLocation = :val16")
                }
                expressionAttributeValues[":val16"] = RewardLocation().toDictionary(rewardLocation:(self.updatedCustomer.rewardLocation)!)
            }
        }
        
        var params = [String:Any]()
        if updatedCustomer.region != nil  {
            if updatedCustomer.region.regionName != nil || updatedCustomer.region.regionName != "" {
                updateValue.append(" , region = :val15")
                expressionAttributeValues[":val15"] = Region().toDictionary(region:(self.updatedCustomer.region)!)
                params =  [
                    "tableName": "Customer",
                    "operation" : "update" ,
                    "payload" : [
                        "Key": [ "uuid" : self.customer.uuid],
                        "UpdateExpression" : self.updateValue ,
                        "ExpressionAttributeNames" : ["#n" : "region"],
                        "ExpressionAttributeValues" : expressionAttributeValues
                    ]
                    ] as [String : Any]
                
            }
        }
        else {
            params =
                [
                    "tableName": "Customer",
                    "operation" : "update" ,
                    "payload" : [
                        "Key": [ "uuid" : self.customer.uuid],
                        "UpdateExpression" : self.updateValue ,
                        "ExpressionAttributeValues" : expressionAttributeValues
                    ]
                ] as [String : Any]
            
        }
        
        genericServices.save(params: params, onComplete:{ (status) in
            
            if (status == 1) {
                
                self.loader.stopAnimating()
                self.loaderView.isHidden = true
                self.view.makeToast("Saving successful")
                self.updateValue.removeAll()
                self.expressionAttributeValues.removeAll()
                self.commitChangesToRealmCustomer()
                //self.disableTextFields()
                self.onEdit(sender as! UIButton)
                
            }
            else {
                print("failur")
                let alertController = UIAlertController(title: "Error",
                                                        message: "Your profie isn't be saved",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Retry Now", style: .default, handler: self.saveCustomer)
                let cancel = UIAlertAction(title: "Retry later", style: .default, handler: nil)
                self.loaderView.isHidden = true
                self.loader.stopAnimating()
                alertController.addAction(okAction)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion:  nil)
                self.updateValue.removeAll()
                self.expressionAttributeValues.removeAll()
                self.view.makeToast("Saving Failed!")
                
            }
        })
        
        
    }
    
    func commitChangesToRealmCustomer() {
        
        self.customer.realm?.beginWrite()
        if updatedCustomer.customerName != nil {
            self.customer.customerName = self.updatedCustomer.customerName
            
        }
        if updatedCustomer.gender != nil  {
            self.customer.gender = self.updatedCustomer.gender
            
        }
        if updatedCustomer.birthDay != nil {
            self.customer.birthDay = self.updatedCustomer.birthDay
        }
        if updatedCustomer.nationality != nil {
            self.customer.nationality = self.updatedCustomer.nationality
        }
        
        if updatedCustomer.workPhone != nil {
            self.customer.workPhone = self.updatedCustomer.workPhone
        }
        if updatedCustomer.housePhone != nil {
            self.customer.housePhone = self.updatedCustomer.housePhone
        }
        if updatedCustomer.email != nil {
            self.customer.email = self.updatedCustomer.email
        }
        if updatedCustomer.preferredLanguage != nil  {
            self.customer.preferredLanguage = self.updatedCustomer.preferredLanguage
            
        }
        if updatedCustomer.address != nil {
            self.customer.address = self.updatedCustomer.address
            
        }
        if updatedCustomer.country != nil  {
            self.customer.country = self.updatedCustomer.country
            
        }
        
        if updatedCustomer.city != nil  {
            self.customer.city = self.updatedCustomer.city
        }
        if updatedCustomer.mailBox != nil {
            self.customer.mailBox = self.updatedCustomer.mailBox
        }
        if updatedCustomer.maritalStatus != nil  {
            self.customer.maritalStatus = self.updatedCustomer.maritalStatus
        }
        
        if updatedCustomer.rewardLocation != nil  {
            self.customer.rewardLocation = self.updatedCustomer.rewardLocation
        }
        
        if updatedCustomer.region != nil  {
            self.customer.region = self.updatedCustomer.region
            
        }
        
        try! self.customer.realm?.commitWrite()
        
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
