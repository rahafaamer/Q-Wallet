//
//  AskAddBeneficiaryViewController.swift
//  SIM
//
//  Created by SSS on 11/1/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class AskAddBeneficiaryViewController: UIViewController {
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.addBackBtn()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSkipAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
