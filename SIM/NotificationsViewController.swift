//
//  NotificationsViewController.swift
//  SIM
//
//  Created by SSS on 9/10/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

struct Notefication {
    var notificationName : String
    var notificationText : String
    var notificationTitle : String
    var notificationDate : String
    
}

class NotificationsViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate {
    var saturday: [Notefication] = []
    var sunday: [Notefication] = []
    var monday: [Notefication] = []
    var tuesday: [Notefication] = []
    var wedensday: [Notefication] = []
    var thursday: [Notefication] = []
    var friday: [Notefication] = []
    var sectionHeaderTitleArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateLayout()
        
        let changeTheme = UIBarButtonItem(image: UIImage(named: "theme"), style: .plain, target: self, action: #selector(changetheme))
        self.navigationItem.rightBarButtonItem = changeTheme

        sectionHeaderTitleArray.append("Saturday")
        sectionHeaderTitleArray.append("Sunday")
        sectionHeaderTitleArray.append("Monday")
        sectionHeaderTitleArray.append("Tuesday")
        sectionHeaderTitleArray.append("Wedensday")
        sectionHeaderTitleArray.append("Thuresday")
        sectionHeaderTitleArray.append("Friday")

        saturday.append(Notefication(notificationName: "Transfere", notificationText: "you have received 1000$ from Ahmad", notificationTitle: "receive money", notificationDate: "8-9-2017"))
        saturday.append(Notefication(notificationName: "Transfere", notificationText: "you have received 1000$ from Ahmad", notificationTitle: "receive money", notificationDate: "8-9-2017"))
        
        sunday.append(Notefication(notificationName: "Transfere", notificationText: "you have received 1500$ from saed", notificationTitle: "receive money", notificationDate: "9-9-2017"))
        
        monday.append(Notefication(notificationName: "Transfere money", notificationText: "you have received 1500$ from Saed", notificationTitle: "receive money", notificationDate: "9-9-2017"))
        tuesday.append(Notefication(notificationName: "confirm code", notificationText: "Enter the security code to confirm operation", notificationTitle: "security code", notificationDate: "10-9-2017"))
        tuesday.append(Notefication(notificationName: "confirm code", notificationText: "Enter the security code to confirm operation", notificationTitle: "security code", notificationDate: "10-9-2017"))
        tuesday.append(Notefication(notificationName: "confirm code", notificationText: "Enter the security code to confirm operation", notificationTitle: "security code", notificationDate: "10-9-2017"))
        
        wedensday.append(Notefication(notificationName: "Transfere", notificationText: "you have received 1500$ from Mohammad", notificationTitle: "receive money", notificationDate: "9-9-2017"))
        thursday.append(Notefication(notificationName: "Transfere", notificationText: "you have received 1500$ from Ahmad", notificationTitle: "receive money", notificationDate: "9-9-2017"))
        friday.append(Notefication(notificationName: "Transfere", notificationText: "you have received 1500$ from samer", notificationTitle: "receive money", notificationDate: "9-9-2017"))
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
//        addClose()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return saturday.count
        }
        else
            if(section == 1)
            {
                return sunday.count
            }
            else if(section == 2)
            {
                return monday.count
            }
            else if(section == 3)
            {
                return tuesday.count
            }
            else
                if(section == 4)
                {
                    return wedensday.count
                }
                else
                    if(section == 5)
                    {
                        return thursday.count
                    }
                    else{
                        return friday.count
        }
        
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sectionHeaderTitleArray[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        tableView.backgroundView?.backgroundColor = UIColor.clear
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.white
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notCell", for: indexPath) as! NotificationTableViewCell
        
        if(indexPath.section == 0)
        {
            cell.notificationTitle.text = saturday[indexPath.row].notificationTitle
            cell.notificationDate.text = saturday[indexPath.row].notificationDate
            cell.notificationText.text = saturday[indexPath.row].notificationText
            cell.notificationName.text = saturday[indexPath.row].notificationName
            let image=UIImage(named: "Rouba 01")
            cell.notificationImage.image = image
        }
        else
            if(indexPath.section == 1)
            {
                cell.notificationTitle.text = sunday[indexPath.row].notificationTitle
                cell.notificationDate.text = sunday[indexPath.row].notificationDate
                cell.notificationText.text = sunday[indexPath.row].notificationText
                cell.notificationName.text = sunday[indexPath.row].notificationName
                let image=UIImage(named: "Rouba 02")
                cell.notificationImage.image = image
            }
            else
                if(indexPath.section == 2)
                {
                    cell.notificationTitle.text = monday[indexPath.row].notificationTitle
                    cell.notificationDate.text = monday[indexPath.row].notificationDate
                    cell.notificationText.text = monday[indexPath.row].notificationText
                    cell.notificationName.text = monday[indexPath.row].notificationName
                    let image=UIImage(named: "Rouba 03")
                    cell.notificationImage.image = image
                }
                else
                    if(indexPath.section == 3)
                    {
                        cell.notificationTitle.text = tuesday[indexPath.row].notificationTitle
                        cell.notificationDate.text = tuesday[indexPath.row].notificationDate
                        cell.notificationText.text = tuesday[indexPath.row].notificationText
                        cell.notificationName.text = tuesday[indexPath.row].notificationName
                        let image=UIImage(named: "Rouba 01")
                        cell.notificationImage.image = image
                    }
                    else
                        if(indexPath.section == 4)
                        {
                            cell.notificationTitle.text = wedensday[indexPath.row].notificationTitle
                            cell.notificationDate.text = wedensday[indexPath.row].notificationDate
                            cell.notificationText.text = wedensday[indexPath.row].notificationText
                            cell.notificationName.text = wedensday[indexPath.row].notificationName
                            let image=UIImage(named: "Rouba 02")
                            cell.notificationImage.image = image
                        }
                            
                        else
                            if(indexPath.section == 5)
                            {
                                cell.notificationTitle.text = thursday[indexPath.row].notificationTitle
                                cell.notificationDate.text = thursday[indexPath.row].notificationDate
                                cell.notificationText.text = thursday[indexPath.row].notificationText
                                cell.notificationName.text = thursday[indexPath.row].notificationName
                                let image=UIImage(named: "Rouba 03")
                                cell.notificationImage.image = image
                            }
                            else
                            {
                                cell.notificationTitle.text = friday[indexPath.row].notificationTitle
                                cell.notificationDate.text = friday[indexPath.row].notificationDate
                                cell.notificationText.text = friday[indexPath.row].notificationText
                                cell.notificationName.text = friday[indexPath.row].notificationName
                                let image=UIImage(named: "Rouba 01")
                                cell.notificationImage.image = image
        }
        
        
        return cell
    }


    func updateLayout() {
        let dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.addNavWithLogo(image: dic["logo"]!)
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
    }
    func changetheme()  {
        let actionSheet = UIAlertController(title: "Choose Theme", message: "please choose theme that you want!", preferredStyle: .actionSheet)
        let hamad = UIAlertAction(title: "HAMAD International Airport", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "Hamad"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        let qatar = UIAlertAction(title: "Qatar Airways", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "Qatar"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        let aspire = UIAlertAction(title: "ASPIRE Zone", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "ASPIRE"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        let rail = UIAlertAction(title: "RAIL", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "RAIL"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        
        let Qwallet = UIAlertAction(title: "Q-Wallet", style: .default) { (action) in
            AppDelegate.sharedDelegate().currentTheme = "QWallet"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(Qwallet)
        actionSheet.addAction(hamad)
        actionSheet.addAction(qatar)
        actionSheet.addAction(aspire)
        actionSheet.addAction(rail)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
//    func addClose()  {
//        let back = UIBarButtonItem(image: UIImage(named:"smallBack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.close))
//        back.tintColor = UIColor.black
//        self.navigationItem.setLeftBarButton(back, animated: false)
//    }
//    func close()  {
//        self.dismiss(animated: true, completion: nil)
//    }
    

}
