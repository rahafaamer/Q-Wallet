//
//  TabBarController.swift
//  SIM
//
//  Created by SSS on 9/11/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import UserNotifications
class TabBarController: UITabBarController ,UNUserNotificationCenterDelegate{
    var notificationNumber :Int = 0
    var isNotgaranted = false
    var messageSubtitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.addBadge), name: NSNotification.Name(rawValue: "addNotification"), object: nil)
        UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
            // Handle Error
        })
        UNUserNotificationCenter.current().delegate = self

       // initNotificationSetupCheck()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "repeat":
            self.sendNotification()
        case "change":
            let textResponse = response
                as! UNTextInputNotificationResponse
            messageSubtitle = textResponse.userText
            self.sendNotification()
        default:
            break
        }
        completionHandler()
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Meeting Reminder"
        content.subtitle = messageSubtitle
        content.body = "Don't forget to bring coffee."
        content.badge = 1
        
        let repeatAction = UNNotificationAction(identifier:"repeat",
                                                title:"Repeat",options:[])
        let changeAction = UNTextInputNotificationAction(identifier:
            "change", title: "Change Message", options: [])
        
        let category = UNNotificationCategory(identifier: "actionCategory",
                                              actions: [repeatAction, changeAction],
                                              intentIdentifiers: [], options: [])
        
        content.categoryIdentifier = "actionCategory"
        
        UNUserNotificationCenter.current().setNotificationCategories(
            [category])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addBadge() {
//        if isNotgaranted{
//            let notification = UNMutableNotificationContent()
//            notification.title = "Danger Will Robinson"
//            notification.subtitle = "Something This Way Comes"
//            notification.body = "I need to tell you something, but first read this."
//            notification.sound = UNNotificationSound.default()
//            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
//            let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        }
        self.notificationNumber = self.notificationNumber + 1
            self.viewControllers?[3].tabBarItem.badgeValue = "\(self.notificationNumber)"
        //sendNotification()
    }
    
//    func initNotificationSetupCheck() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound])
//        { (success, error) in
//            if success {
//                print("Permission Granted")
//                self.isNotgaranted = true
//            } else {
//                self.isNotgaranted = false
//                print("There was a problem!")
//            }
//        }
//    }
    
}
