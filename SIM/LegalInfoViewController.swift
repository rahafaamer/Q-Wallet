//
//  LegalInfoViewController.swift
//  SIM
//
//  Created by Rimon on 10/8/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class LegalInfoViewController: BaseViewController {
    var dic :[String:String] = [:]

    @IBOutlet weak var websiteBtn: UIButton!
    var attrs = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 14.0),
        NSForegroundColorAttributeName : UIColor.blue,
        NSUnderlineStyleAttributeName : 1] as [String : Any]
    var attributedString = NSMutableAttributedString(string:"")

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        self.navigationItem.title = "legal Info"

        let buttonTitleStr = NSMutableAttributedString(string:"Visit our website", attributes:attrs)
        attributedString.append(buttonTitleStr)
        websiteBtn.setAttributedTitle(attributedString, for: .normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickWesite(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "http://www.google.com")! as URL)
    }
    func updateLayout() {
        dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
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
