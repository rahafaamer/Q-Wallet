//
//  LoginViewController.swift
//  SIM
//
//  Created by SSS on 9/11/17.
//  Copyright © 2017 SSS. All rights reserved.
//
import AWSCognitoIdentityProvider
import UIKit
import NVActivityIndicatorView
import RealmSwift

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    let userDefaults = UserDefaults.standard
    var isNotConfirmed:Bool = true
    var orginalconstraint = 0.0
    let appDelegate = AppDelegate.sharedDelegate()
    var usernameText: String?
    var user: AWSCognitoIdentityUser?
    var pool: AWSCognitoIdentityUserPool?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.password.text = nil
        //self.userName.text = usernameText
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.addBackBtn()
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        if (self.user == nil) {
            self.user = self.pool?.currentUser()
            
        }
        userName.addLineBelowTextField()
        password.addLineBelowTextField()
        
    }
    
    @IBAction func onRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegister", sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // editTextStyle()
        orginalconstraint = Double(bottomConstraint.constant)
        self.navigationController?.viewControllers[0].navigationController?.setViewControllers([self], animated: true)

        self.loginBtn.layer.masksToBounds = true
        self.loginBtn.layer.cornerRadius = 25
        self.loginBtn.layer.borderColor = UIColor.white.cgColor
        self.loginBtn.layer.borderWidth = 2

        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onForgotPassword(_ sender: Any) {
        self.performSegue(withIdentifier: "toForgotPassword", sender: sender)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if bottomConstraint.constant > 200{
            bottomConstraint.constant =  bottomConstraint.constant - 200
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userName {
            self.userName.text = ""
        }
        if bottomConstraint.constant < 200 {
            bottomConstraint.constant =  bottomConstraint.constant + 200
        }
    }
    
    func editTextStyle() {
        let dic = appDelegate.getCurrenttheme()
        userName.layer.cornerRadius = 7
        userName.layer.borderColor = UIColor(hexString: "cfcbcd").cgColor
        loginBtn.layer.cornerRadius = 7
        loginBtn.backgroundColor = UIColor(hexString:"e0dcde")
        userName.layer.borderWidth = 1.5
        password.layer.cornerRadius=7
        password.layer.borderWidth = 1.5
        password.layer.borderColor =  UIColor(hexString: "cfcbcd").cgColor
        backgroundImage.image = UIImage(named: dic["loginBackgroundImage"]!)
        loginBtn.setTitleColor(UIColor(hexString: dic["loginTitleColor"]!) ,for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmSignUpSegue" {
            
            let controller = segue.destination as! VerifyViewController
            
            controller.userName = self.userName.text!
            controller.password = self.password.text!
            controller.isNotConfirmed = self.isNotConfirmed
            controller.fromLogin = true
        }
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        userName.resignFirstResponder()
        password.resignFirstResponder()
        loaderView.isHidden = false
        activityIndicator.startAnimating()
        // doing automatic login
        self.user?.getSession((self.userName.text!), password: (self.password.text!), validationData: nil).continueWith {[weak self] (task) -> Any? in
            guard self != nil else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as? NSError {
                    if error.userInfo["__type"] as? String == "UserNotConfirmedException" {
                        self?.isNotConfirmed = true
                        self?.performSegue(withIdentifier: "confirmSignUpSegue", sender: sender)
                        self?.activityIndicator.stopAnimating()
                        self?.loaderView.isHidden = true
                    }
                    else {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    
                    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                    alertController.addAction(retryAction)
                        self?.isNotConfirmed = false
                    self?.activityIndicator.stopAnimating()
                    self?.loaderView.isHidden = true
                    self?.present(alertController, animated: true, completion:  nil)
                    }
                    
                } else  {
                    self?.isNotConfirmed = false
                    AppDelegate.sharedDelegate().userSession = task.result
                    self?.activityIndicator.stopAnimating()
                    self?.loaderView.isHidden = true
                    self?.loadCustomer(userName: (self?.userName.text!)!)
                   
                }
                
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
                let realm = try! Realm()
                try! realm.write {
                    realm.add(customerObject, update: true)
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "start")
                AppDelegate.sharedDelegate().window?.rootViewController = controller
                self.present(controller, animated: true, completion: {})
                self.activityIndicator.stopAnimating()
                self.loaderView.isHidden = true
            }
            else {
                print("failur")
                self.activityIndicator.stopAnimating()
                self.loaderView.isHidden = true
                
            }
        })
    }

}


