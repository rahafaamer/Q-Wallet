//
//  VerifyViewController.swift
//  SIM
//
//  Created by Rimon on 10/5/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import Toast_Swift
import NVActivityIndicatorView
import RealmSwift

class VerifyViewController: UIViewController,UITextFieldDelegate {
    
    
    var userName:String?
    var password:String?
    var sentTo: String?
    var stringCode: String?
    var customer:Customer?
    var fromQRemit:Bool = false
    var fromLogin:Bool = false
    var isNotConfirmed:Bool = false
    let userDefaults = UserDefaults.standard
    var characterArray = [Character] ()
    @IBOutlet weak var loaderView: UIView!
    
    @IBOutlet weak var pinTextField4: UITextField!
    @IBOutlet weak var pinTextField3: UITextField!
    @IBOutlet weak var pinTextField2: UITextField!
    @IBOutlet weak var pinTextField5: UITextField!
    @IBOutlet weak var pinTextField6: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var code: UITextField!
    
    @IBOutlet weak var loader: NVActivityIndicatorView!
    var response: AWSCognitoIdentityUserGetDetailsResponse?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.addBackBtn()
        pinTextField.resignFirstResponder()
        confirmBtn.layer.cornerRadius = 10
        resendBtn.layer.cornerRadius = 10
        resendBtn.layer.borderWidth = 2
        resendBtn.layer.borderColor = UIColor.white.cgColor
        confirmBtn.layer.borderWidth = 2
        confirmBtn.layer.borderColor = UIColor.white.cgColor
        
        
        // Do any additional setup after loading the view.
        
        pinTextField.delegate = self
        pinTextField2.delegate = self
        pinTextField3.delegate = self
        pinTextField4.delegate = self
        pinTextField5.delegate = self
        pinTextField6.delegate = self
        
        pinTextField.addLineBelowTextField()
        pinTextField2.addLineBelowTextField()
        pinTextField3.addLineBelowTextField()
        pinTextField4.addLineBelowTextField()
        pinTextField5.addLineBelowTextField()
        pinTextField6.addLineBelowTextField()
        
        pinTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        pinTextField2.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        pinTextField3.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        pinTextField4.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        pinTextField5.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        pinTextField6.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        self.pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        if (self.user == nil) {
            self.user = self.pool?.getUser(self.userName!)
        }
        if fromLogin {
            getConfirmationCode()
        }
        
        
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if ((textField.text!.characters.count) > maxLength) {
            textField.deleteBackward()
        }
    }
    func textFieldDidChange(textField: UITextField){
        
        
        let text = textField.text
        if (text?.utf16.count)! >= 1{
            switch textField {
            case pinTextField:
                pinTextField2.becomeFirstResponder()
            case pinTextField2:
                pinTextField3.becomeFirstResponder()
            case pinTextField3:
                pinTextField4.becomeFirstResponder()
            case pinTextField4:
                pinTextField5.becomeFirstResponder()
            case pinTextField5:
                pinTextField6.becomeFirstResponder()
            case pinTextField6:
                pinTextField6.resignFirstResponder()
            default:
                break
            }
            
        }
        else{
            
        }
        
    }
    override func addBackBtn()  {
        let back = UIBarButtonItem(image: UIImage(named:"smallBack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.pop))
        back.tintColor = UIColor.black
        self.navigationItem.setLeftBarButton(back, animated: false)
    }
    override func pop()  {
        let realm = try! Realm()
        let customer = realm.objects(Customer.self).first!
        try! realm.write {
            realm.delete(customer)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /*   func addCustomBackBtn()  {
     let back = UIBarButtonItem(image: UIImage(named:"smallBack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.popViewController))
     back.tintColor = UIColor.black
     self.navigationItem.setLeftBarButton(back, animated: false)
     }
     func popViewController()  {
     self.pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
     self.pool?.currentUser()?.delete().continueWith {[weak self] (task) -> Any? in
     guard self != nil else { return nil }
     DispatchQueue.main.async(execute: {
     if (task.error as? NSError) != nil {
     print(task.error)
     self?.user?.signOut()
     self?.title = nil
     self?.response = nil
     
     } else if task.result != nil  {
     _ = self?.navigationController?.popViewController(animated: true)
     }
     
     })
     return nil
     }
     }*/
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pinTextField4.resignFirstResponder()
        pinTextField3.resignFirstResponder()
        pinTextField5.resignFirstResponder()
        pinTextField6.resignFirstResponder()
        pinTextField2.resignFirstResponder()
        pinTextField.resignFirstResponder()
    }
    
    func cancelVerifyUser(action:UIAlertAction) {
        self.pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        
        self.pool?.currentUser()?.delete().continueWith {[weak self] (task) -> Any? in
            guard self != nil else { return nil }
            DispatchQueue.main.async(execute: {
                if (task.error as? NSError) != nil {
                    self?.user?.signOut()
                    self?.title = nil
                    self?.response = nil
                    
                } else if task.result != nil  {
                    _ = self?.navigationController?.popViewController(animated: true)
                }
                
            })
            return nil
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
    
    // handle confirm sign up
    @IBAction func confirm(_ sender: AnyObject) {
        self.loader.startAnimating()
        self.loaderView.isHidden = false
        
        pinTextField4.resignFirstResponder()
        pinTextField3.resignFirstResponder()
        pinTextField2.resignFirstResponder()
        pinTextField.resignFirstResponder()
        pinTextField5.resignFirstResponder()
        pinTextField6.resignFirstResponder()
        if (pinTextField.text == "" || pinTextField2.text == "" || pinTextField3.text == "" || pinTextField4.text == "" || pinTextField5.text == "" || pinTextField6.text == "") {
            self.view.makeToast("please enter all fields of pin code!")
            
        }
        else {
            characterArray.append(Character(pinTextField.text!))
            characterArray.append(Character(pinTextField2.text!))
            characterArray.append(Character(pinTextField3.text!))
            characterArray.append(Character(pinTextField4.text!))
            characterArray.append(Character(pinTextField5.text!))
            characterArray.append(Character(pinTextField6.text!))
            stringCode = String(characterArray)
        }
        
        if !fromQRemit && !fromLogin {
            guard let confirmationCodeValue = self.stringCode,!confirmationCodeValue.isEmpty else {
                let alertController = UIAlertController(title: "Confirmation code missing.",
                                                        message: "Please enter a valid confirmation code.",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion:  nil)
                self.characterArray.removeAll()
                return
            }
            
            confirmSignUp()
            
        }
        else {
            if !fromLogin {
                //from Q-Remit
                self.navigationController?.dismiss(animated: true, completion: {})
            }
            else {
                
                confirmSignUp()
                
            }
            
        }
    }
    
    
    
    // handle code resend action
    @IBAction func resend(_ sender: AnyObject) {
        pinTextField4.resignFirstResponder()
        pinTextField3.resignFirstResponder()
        pinTextField2.resignFirstResponder()
        pinTextField.resignFirstResponder()
        pinTextField5.resignFirstResponder()
        pinTextField6.resignFirstResponder()
        self.characterArray.removeAll()
        if !fromQRemit && !fromLogin {
            self.user?.resendConfirmationCode().continueWith {[weak self] (task: AWSTask) -> AnyObject? in
                guard let _ = self else { return nil }
                DispatchQueue.main.async(execute: {
                    if let error = task.error as? NSError {
                        let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                                message: error.userInfo["message"] as? String,
                                                                preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        
                        self?.present(alertController, animated: true, completion:  nil)
                        self?.characterArray.removeAll()
                    } else if let result = task.result {
                        let alertController = UIAlertController(title: "Code Resent",
                                                                message: "Code resent to \(result.codeDeliveryDetails?.destination!)",
                            preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self?.present(alertController, animated: true, completion: nil)
                        self?.characterArray.removeAll()
                    }
                })
                return nil
            }
        }
        else {
            getConfirmationCode()
            
            
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
                let realm = try! Realm()
                try! realm.write {
                    realm.add(customerObject, update: true)
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "start")
                AppDelegate.sharedDelegate().window?.rootViewController = controller
                self.present(controller, animated: true, completion: {})
                self.loader.stopAnimating()
                self.loaderView.isHidden = true
            }
            else {
                print("failur")
                self.loader.stopAnimating()
                self.loaderView.isHidden = true
                
            }
        })
    }
    func confirmSignUp(){
        
        self.user?.confirmSignUp(String(self.characterArray), forceAliasCreation: true).continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else { return nil }
            
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self?.loader.stopAnimating()
                    self?.loaderView.isHidden = true
                    strongSelf.present(alertController, animated: true, completion:  nil)
                    self?.characterArray.removeAll()
                } else {
                    self?.loader.stopAnimating()
                    self?.loaderView.isHidden = true
                    //self?.loadCustomer(userName: (self?.userName!)!)
                    self?.navigationController?.popToRootViewController(animated: true)
                    
                }
            })
            
            return nil
        }
    }
    func getConfirmationCode() {
        
        self.user?.resendConfirmationCode().continueWith {[weak self] (task: AWSTask) -> AnyObject? in
            guard let _ = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                    self?.characterArray.removeAll()
                } else if let result = task.result {
                    let alertController = UIAlertController(title: "Code Resent",
                                                            message: "Code resent to UnConfirmedUser to be confirmed",
                                                            preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true, completion: nil)
                    self?.characterArray.removeAll()
                }
            })
            return nil
        }
        
    }
}
