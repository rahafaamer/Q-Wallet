//
//  RegisterPhase1ViewController.swift
//  SIM
//
//  Created by SSS on 9/11/17.
//  Copyright ? 2017 SSS. All rights reserved.
//

import UIKit
import AWSCognito
import AWSCore
import AWSDynamoDB
import Toast_Swift
import NVActivityIndicatorView



class RegisterPhase1ViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate , UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var rewordLocationTextField: UITextField!
    @IBOutlet weak var rewardLocationLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var qidLabel: UILabel!
    var fromOcr:Bool = false
    var name:String = ""
    var id:String = ""
    var birthDay:String = ""
    var nationality:String = ""
    var socialStatusText: String = ""
    @IBOutlet weak var nationalityTableview: UITableView!
    @IBOutlet weak var singleRadioButton: DLRadioButton!
    @IBOutlet weak var nvActivityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var marriedRadioButton: DLRadioButton!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var dateOfbirth: UITextField!
    var genderText: String = ""
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var datePikerView: UIView!
    var choosenDate:String = ""
    @IBOutlet weak var datePiker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var qidTextField: UITextField!
    @IBOutlet weak var ocrBtn: UIButton!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var viewUnderReg: UIView!
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var bankInfolabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var femaleRadioButton: DLRadioButton!
    @IBOutlet weak var maleRadioButton: DLRadioButton!
    var newCutomer = Customer()
    var isLocationOpend = false
    @IBOutlet weak var rewordLocationTableview: UITableView!
    var locations = ["Qatar","Home"]
    let dateFormatter = DateFormatter()
    var genderType : [DLRadioButton] = [];
    var socialStatus : [DLRadioButton] = [];
    var nationalitiesList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // linit date  of datepicker
        self.addBackBtn()
        let scrollGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterPhase1ViewController.onGesture(sender:)))
        self.maleRadioButton.isMultipleSelectionEnabled = false;
        
        genderType.append(femaleRadioButton)
        maleRadioButton.otherButtons = genderType;
        
        socialStatus.append(singleRadioButton)
        marriedRadioButton.otherButtons = socialStatus
        
        contentView.addGestureRecognizer(scrollGesture)
        // self.navigationController?.navigationBar.barTintColor = UIColor.black
        register.layer.cornerRadius = 2
        updateLayout()
        
        self.ocrBtn.layer.masksToBounds = true
        self.ocrBtn.layer.cornerRadius = 10
        self.ocrBtn.layer.borderWidth = 1
        self.ocrBtn.layer.borderColor = UIColor.white.cgColor
        
        self.register.layer.masksToBounds = true
        self.register.layer.cornerRadius = 10
        self.register.layer.borderWidth = 1
        self.register.layer.borderColor = UIColor.white.cgColor
        
        self.rewardLocationLabel.layer.masksToBounds = true
        self.birthDayLabel.layer.masksToBounds = true
        self.nationalityLabel.layer.masksToBounds = true
        self.nameLabel.layer.masksToBounds = true
        self.qidLabel.layer.masksToBounds = true
        self.rewardLocationLabel.layer.cornerRadius = 5
        self.birthDayLabel.layer.cornerRadius = 5
        self.nationalityLabel.layer.cornerRadius = 5
        self.nameLabel.layer.cornerRadius = 5
        self.qidLabel.layer.cornerRadius = 5
        
        rewordLocationTableview.delegate = self
        rewordLocationTableview.dataSource=self
        
        self.rewordLocationTableview.layer.cornerRadius = 5
        self.rewordLocationTableview.layer.borderWidth = 1
        
        self.nationalityTableview.delegate = self
        self.nationalityTableview.dataSource = self
        
        self.nationalityTableview.layer.cornerRadius = 5
        self.nationalityTableview.layer.borderWidth = 1
        scanNationalities()
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        nationalityTextField.addLineBelowTextField()
        dateOfbirth.addLineBelowTextField()
        nameTextField.addLineBelowTextField()
        qidTextField.addLineBelowTextField()
        rewordLocationTextField.addLineBelowTextField()
        
        if fromOcr {
            fillOcrFields()
            fromOcr = false
        }
    }
    func fillOcrFields() {
        if !name.contains("") {
            self.nameTextField.text = name
        }
        if !nationality.contains(""){
            self.nationalityTextField.text = nationality
        }
        if !id.contains(""){
            self.qidTextField.text = id
        }
        if !birthDay.contains(""){
            self.dateOfbirth.text = birthDay
        }
        
    }
    func scanNationalities()
    {
        
        let genericServices = ApiGatway.api
        let params:[String:Any] = [
            "operation": "list" ,
            "tableName":  "Nationality" ,
            "payload": []
        ]
        genericServices.scan(params: params, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let nationality = result as? NSDictionary
                    self.nationalitiesList.append(nationality?["nationalityName"] as! String)
                }
                DispatchQueue.main.async{
                    if (self.nvActivityIndicatorView.isAnimating) {
                        self.nvActivityIndicatorView.stopAnimating()
                        self.loaderView.isHidden = true
                    }
                    self.nationalityTableview.reloadData()
                }
                
            }
            else {
                if (self.nvActivityIndicatorView.isAnimating) {
                    self.nvActivityIndicatorView.stopAnimating()
                    self.loaderView.isHidden = true
                }
                print("failur")
            }
        })
    }
    @IBAction func selectNationality(_ sender: Any) {
        if (nationalitiesList.isEmpty) {
            loaderView.isHidden = false
            nvActivityIndicatorView.startAnimating()
        }
        else {
            nvActivityIndicatorView.stopAnimating()
            loaderView.isHidden = true
        }
        if(nationalityTextField.layer.borderColor == (UIColor.red).cgColor){
            nationalityTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        if nationalityTableview.isHidden {
            self.nationalityLabel.isHidden = true
            nationalityTableview.isHidden = false
        }
        else{
            nationalityTableview.isHidden = true
            if(nvActivityIndicatorView.isAnimating){
                loaderView.isHidden = true
                nvActivityIndicatorView.stopAnimating()
            }
        }
    }
    
    @IBAction func selectDateOfBirthday(_ sender: Any) {
        if(dateOfbirth.layer.borderColor == (UIColor.red).cgColor){
            dateOfbirth.layer.borderColor = UIColor.lightGray.cgColor
        }
        if datePikerView.isHidden {
            self.view.endEditing(true)
            datePikerView.isHidden = false
            self.birthDayLabel.isHidden = true
        }
        else {
            self.view.endEditing(true)
            datePikerView.isHidden = true
        }
        
    }
    @IBAction func selectMaleRadioButton(_ sender: Any) {
        if(maleRadioButton.backgroundColor == UIColor.red){
            maleRadioButton.backgroundColor = UIColor.clear
            femaleRadioButton.backgroundColor = UIColor.clear
        }
        genderText = "Male"
        maleRadioButton.isSelected = true
    }
    
    
    @IBAction func selectSingleRadioButton(_ sender: Any) {
        if(singleRadioButton.backgroundColor == UIColor.red){
            singleRadioButton.backgroundColor = UIColor.clear
            marriedRadioButton.backgroundColor = UIColor.clear
        }
        socialStatusText = "Single"
        singleRadioButton.isSelected = true
    }
    
    
    @IBAction func selectMarriedRadioButton(_ sender: Any) {
        if(marriedRadioButton.backgroundColor == UIColor.red){
            singleRadioButton.backgroundColor = UIColor.clear
            marriedRadioButton.backgroundColor = UIColor.clear
        }
        socialStatusText = "Married"
        marriedRadioButton.isSelected = true
    }
    
    
    
    @IBAction func selectFemaleRadioButton(_ sender: Any) {
        if(femaleRadioButton.backgroundColor == UIColor.red){
            femaleRadioButton.backgroundColor = UIColor.clear
            maleRadioButton.backgroundColor = UIColor.clear
        }
        genderText = "Female"
        femaleRadioButton.isSelected = true
    }
    @IBAction func clearDate(_ sender: Any) {
        self.datePikerView.isHidden = true // // hide the picker view
        
        // Clear the date of fromDateTextField or toDateTextField depend on choosenDate
        
        self.dateOfbirth.text = ""
    }
    
    @IBAction func chooseDate(_ sender: Any) {
        self.datePikerView.isHidden = true // hide the picker view
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
                self.dateOfbirth.text = ""
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
            self.dateOfbirth.text = date2
        }
    }
    
    
    @IBAction func SelectRewordLocation(_ sender: Any) {
        if(rewordLocationTextField.layer.borderColor == (UIColor.red).cgColor){
            rewordLocationTextField.layer.borderColor = (UIColor.lightGray).cgColor
        }
        if rewordLocationTableview.isHidden {
            self.rewardLocationLabel.isHidden = true
            self.rewordLocationTableview.isHidden = false
        }else{
            
            self.rewordLocationTableview.isHidden = true
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterPhase2ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterPhase2ViewController.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == rewordLocationTableview {
            return locations.count
        }
        else {
            return nationalitiesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == rewordLocationTableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RewordCell")
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.text = locations[indexPath.row]
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nationalityCell")
            cell?.textLabel?.textColor = UIColor.white
            cell?.textLabel?.text = nationalitiesList[indexPath.row]
            if (nvActivityIndicatorView.isAnimating){
                nvActivityIndicatorView.stopAnimating()
                loaderView.isHidden = true
            }
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == rewordLocationTableview {
            self.rewordLocationTableview.isHidden = true
            rewordLocationTextField.text = locations[indexPath.row]
        }
        else {
            self.nationalityTableview.isHidden = true
            if (nvActivityIndicatorView.isAnimating){
                loaderView.isHidden = true
                nvActivityIndicatorView.stopAnimating()
            }
            nationalityTextField.text = nationalitiesList[indexPath.row]
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case qidTextField :
            self.qidLabel.isHidden = true
        case nationalityTextField:
            self.nationalityLabel.isHidden = true
        case nameTextField:
            self.nameLabel.isHidden = true
        case dateOfbirth :
            self.birthDayLabel.isHidden = true
        default :
            break
        }
        if (textField.layer.borderColor == (UIColor.red).cgColor) {
            textField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            return 45
        }
        else {
            return 30
        }
    }
    
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
        
        nationalityTextField.resignFirstResponder()
        dateOfbirth.resignFirstResponder()
        
        nameTextField.resignFirstResponder()
        qidTextField.resignFirstResponder()
    }
    
    func updateLayout() {
        //        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        //        self.register.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        //        self.addNavWithLogo(image: dic["logo"]!)
        //        self.bankInfolabel.textColor = UIColor(hex: dic["themeColor1"]!)
        //        self.registrationLabel.textColor = UIColor(hex: dic["themeColor1"]!)
        //        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
        //        self.viewUnderReg.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        //        self.ocrBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        
    }
    
    @IBAction func onRegister(_ sender: Any) {
        let color = UIColor.red
        if (qidTextField.text == "" || qidTextField.text?.characters.count != 11) {
            self.view.makeToast("QID Number Should be equal 11")
            qidTextField.layer.borderColor = color.cgColor
            self.qidTextField.text = ""
        }
        if(qidTextField.text == "" && nameTextField.text  == "" && genderText == "" && nationalityTextField.text == "" && socialStatusText == "" && rewordLocationTextField.text == "" && dateOfbirth.text == ""){
            nameTextField.layer.borderColor = color.cgColor
            maleRadioButton.backgroundColor = UIColor.red
            femaleRadioButton.backgroundColor = UIColor.red
            nationalityTextField.layer.borderColor = color.cgColor
            singleRadioButton.backgroundColor = UIColor.red
            marriedRadioButton.backgroundColor = UIColor.red
            rewordLocationTextField.layer.borderColor = color.cgColor
            dateOfbirth.layer.borderColor = color.cgColor
            self.view.makeToast("Please fill all required fields")
        }
        else
            if (qidTextField.text == "" || nameTextField.text  == "" || genderText == "" || nationalityTextField.text == "" || socialStatusText == "" || rewordLocationTextField.text == "" || dateOfbirth.text == ""){
                
                if(qidTextField.text == "") {
                    qidTextField.layer.borderColor = color.cgColor
                    self.view.makeToast("Please fill qid field")
                }
                if( nameTextField.text  == ""){
                    self.view.makeToast("Please fill name text field")
                    nameTextField.layer.borderColor = color.cgColor
                }
                if( genderText == ""){
                    self.view.makeToast("Please select gender")
                    maleRadioButton.backgroundColor = UIColor.red
                    femaleRadioButton.backgroundColor = UIColor.red
                }
                if(dateOfbirth.text == ""){
                    self.view.makeToast("Please select date of birthday")
                    dateOfbirth.layer.borderColor = color.cgColor
                }
                
                if( nationalityTextField.text == "") {
                    self.view.makeToast("Please  select nationality")
                    nationalityTextField.layer.borderColor = color.cgColor
                }
                
                if(socialStatusText == "") {
                    self.view.makeToast("Please select social status")
                    singleRadioButton.backgroundColor = UIColor.red
                    marriedRadioButton.backgroundColor = UIColor.red
                }
                if(rewordLocationTextField.text == "") {
                    self.view.makeToast("Please select reword location")
                    rewordLocationTextField.layer.borderColor = color.cgColor
                }
                
            }
                
            else {
                
                let maritalStatusDic =  MaritalStatus()
                maritalStatusDic.uuid = UUID().uuidString
                maritalStatusDic.maritalStatusName = socialStatusText
                newCutomer.maritalStatus = maritalStatusDic
                
                let nationalityDic = Nationality()
                nationalityDic.uuid = UUID().uuidString
                nationalityDic.nationalityName = nationalityTextField.text
                newCutomer.nationality = nationalityDic
                
                newCutomer.birthDay = dateOfbirth.text
                
                let rewordDic = RewardLocation()
                rewordDic.uuid = UUID().uuidString
                rewordDic.rewardLocationName = rewordLocationTextField.text
                newCutomer.rewardLocation = rewordDic
                
                let genderObject = Gender()
                genderObject.uuid = UUID().uuidString
                genderObject.genderName = genderText
                newCutomer.gender = genderObject
                
                newCutomer.customerName = nameTextField.text
                newCutomer.qid = qidTextField.text
                // get a reference to the second view controller
                performSegue(withIdentifier: "toCommunicationInfo", sender: sender)
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCommunicationInfo" {
            
            // get a reference to the second view controller
            let registerPhase2 = segue.destination as! RegisterPhase2ViewController
            
            // set a variable in the second view controller with the String to pass
            registerPhase2.newCustomer = self.newCutomer
        }
        
        
    }
    
    
    
    @IBAction func unwindToRegisterPhase1(segue:UIStoryboardSegue) { }
    
    @IBAction func onOcr(_ sender: Any) {
        let alertController = UIAlertController(title: "What is OCR?", message: "OCR Registration is an alternative way to make registration by using camera to capture your personal information from your personal ID, if you want to use it please click ok, it will guide you to the camera and capture a photo of your ID.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.performSegue(withIdentifier: "toOcr", sender: sender)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
    func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
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
