//
//  AddBalanceToWalletViewController.swift
//  SIM
//
//  Created by SSS on 10/23/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class AddBalanceToWalletViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
          UpdateLayout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func UpdateLayout()
    {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        saveBtn.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
        saveBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        
        cancelBtn.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
        cancelBtn.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        
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
