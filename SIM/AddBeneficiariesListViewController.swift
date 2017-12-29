//
//  AddBeneficiariesListViewController.swift
//  SIM
//
//  Created by SSS on 11/1/17.
//  Copyright � 2017 SSS. All rights reserved.
//

import AWSCognitoIdentityProvider
import AWSDynamoDB
import UIKit

class AddBeneficiariesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var beneficaryDelegate:RefreshTableView?
    @IBOutlet weak var benTypesTableview: UITableView!
    @IBOutlet weak var addBillBenContainerview: UIView!
    @IBOutlet weak var benTypeTextField: UITextField!
    @IBOutlet weak var addWalletBenContainerview: UIView!
    @IBOutlet weak var addMobileBenContainerView: UIView!
    @IBOutlet weak var addPersonContainerview: UIView!
    var benTypesNames = [String]()
    var customer:Customer?
    var bentype = BeneficiaryType()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackBtn()
        benTypesTableview.delegate = self
        benTypesTableview.dataSource = self
    
        //scan Beneficiary table
        let genericServices = ApiGatway.api
        let beneficiaryParams:[String:Any] = [
            "operation": "list" ,
            "tableName":  "BeneficiaryType" ,
            "payload": []
        ]
        genericServices.scan(params: beneficiaryParams, onComplete: {(status,resultsArray) in
            if (status == 1) {
                for result in resultsArray { // For each element in resultArray
                    let beneficiaryType = result as? NSDictionary
                    self.benTypesNames.append(beneficiaryType?["beneficiaryTypeName"] as! String)
                }
                DispatchQueue.main.async {
                self.benTypesTableview.reloadData()
                }
            }
        })

        
        addWalletBenContainerview.isHidden=true
        addPersonContainerview.isHidden = true
        addBillBenContainerview.isHidden = true
        addMobileBenContainerView.isHidden = true
        
              // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        benTypeTextField.addLineBelowTextField()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return benTypesNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "SelectBenTypeCell")!
        cell.textLabel?.text = benTypesNames[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    @IBAction func selectBenType(_ sender: Any) {
        if benTypesTableview.isHidden {
            benTypesTableview.isHidden = false
            benTypesTableview.reloadData()
        }
        else {
            benTypesTableview.isHidden = true
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        benTypeTextField.text = benTypesNames[indexPath.row]
        benTypesTableview.isHidden = true
        if benTypeTextField.text == "Wallet" {
            DispatchQueue.main.async{
                self.addWalletBenContainerview.isHidden=false
                self.addPersonContainerview.isHidden = true
                self.addBillBenContainerview.isHidden = true
                self.addMobileBenContainerView.isHidden = true
            }
        }
        else
            if benTypeTextField.text == "Mobile TopUp" {
                DispatchQueue.main.async{
                    self.addWalletBenContainerview.isHidden=true
                    self.addPersonContainerview.isHidden = true
                    self.addBillBenContainerview.isHidden = true
                    self.addMobileBenContainerView.isHidden = false
                }
            }
            else
                if benTypeTextField.text == "E-Services (Bill)" {
                    DispatchQueue.main.async{
                        self.addWalletBenContainerview.isHidden=true
                        self.addPersonContainerview.isHidden = true
                        self.addBillBenContainerview.isHidden = false
                        self.addMobileBenContainerView.isHidden = true
                    }
                }
                else {
                    DispatchQueue.main.async{
                        self.addWalletBenContainerview.isHidden=true
                        self.addPersonContainerview.isHidden = false
                        self.addBillBenContainerview.isHidden = true
                        self.addMobileBenContainerView.isHidden = true
                    }
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
