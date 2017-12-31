///
//  AppDelegate.swift
//  SIM
//
//  Created by SSS on 9/10/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import UserNotifications
import AWSCore
import AWSCognito
import AWSPinpoint
import AWSMobileAnalytics
import AWSCognitoIdentityProvider
import RealmSwift
import AWSPushManager
import AWSSNS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
    
    var window: UIWindow?
    var  globalTimer:Timer!
    let userDefaults = UserDefaults.standard
    var currentTheme = "QWallet"
    var pinpoint: AWSPinpoint?
    static let remoteNotificationKey = "RemoteNotification"
    var userSession:AWSCognitoIdentityUserSession?
    var signInViewController: LoginViewController?
    var navigationController: UINavigationController?
    var storyboard: UIStoryboard?
    var rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>?
    var customer:Customer?
    let platformARN = "arn:aws:sns:us-east-1:240015028744:app/APNS_SANDBOX/Qwallet"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        fillThemes()
        self.startTimer()
        initNotificationSetupCheck()
        // --------------- AWS -------------
        AWSLogger.default().logLevel = .verbose
        //     pinpoint = AWSPinpoint.init(configuration:AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions))
        let cognitoProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider.init(regionType: AWSRegionType.USEast1, identityPoolId: "us-east-1:60fa2fa4-f145-4da6-a451-61f6bcca779d");
        let serviceConfig:AWSServiceConfiguration = AWSServiceConfiguration.init(region: AWSRegionType.USEast1, credentialsProvider: cognitoProvider);
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfig;
      
        // setup logging*/
        AWSLogger.default().logLevel = .verbose
        
        // setup service configuration
        let serviceConfiguration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: nil)
        
        // create pool configuration
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: "662p4iq4mtfm41imsrsmd28aqu",
                                                                        clientSecret: "1nbilkieq5t46uoastvd7v5tvqqr6f3dd9r18i94103gdlj1opj9",
                                                                        poolId: "us-east-1_7H8bNWENM")
        // initialize user pool client
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: "UserPool")
        
        // fetch the user pool client we initialized in above step
        let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let realm = try! Realm()
        if realm.objects(Customer.self).count != 0 {
            self.customer = realm.objects(Customer.self).first!
            
            if self.customer != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "start")
                self.window?.rootViewController = controller
            }
        }
        //---------- SNS Notification-----
        
        registerForPushNotifications(application: application)
        return true
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        pinpoint!.notificationManager.interceptDidReceiveRemoteNotification(response.notification.request.content.userInfo) { (UIBackgroundFetchResult) in
            
        }
    }
    
    func registerForPushNotifications(application: UIApplication) {
        /// The notifications settings
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        } else {
            let settings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    // Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    // Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Attach the device token to the user defaults
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        print(token)
        
        UserDefaults.standard.set(token, forKey: "deviceTokenForSNS")
        
        /// Create a platform endpoint. In this case,  the endpoint is a
        /// device endpoint ARN
        let sns = AWSSNS.default()
        let request = AWSSNSCreatePlatformEndpointInput()
        request?.token = token
        request?.platformApplicationArn = platformARN
        sns.createPlatformEndpoint(request!).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask!) -> AnyObject! in
            if task.error != nil {
                print("Error: \(String(describing: task.error))")
            } else {
                let createEndpointResponse = task.result! as AWSSNSCreateEndpointResponse
                
                if let endpointArnForSNS = createEndpointResponse.endpointArn {
                    print("endpointArn: \(endpointArnForSNS)")
                    UserDefaults.standard.set(endpointArnForSNS, forKey: "endpointArnForSNS")
                }
            }
            
            return nil
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        AWSPushManager.default().interceptApplication(application,
                                                      didFailToRegisterForRemoteNotificationsWithError: error)
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // pinpoint!.notificationManager.interceptDidReceiveRemoteNotification(userInfo, fetchCompletionHandler: completionHandler)
        AWSPushManager.default().interceptApplication(application,
                                                      didReceiveRemoteNotification: userInfo)
        // This is where you intercept push notifications.
        if (application.applicationState == .active) {
            let alert = UIAlertController(title: "Notification Received",
                                          message: userInfo.description,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion:nil)
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    // MARK: - Private Methods
    func openControllerWithIndentifier(identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        let rootController = window?.rootViewController as! MSSlidingPanelController
        
        rootController.centerViewController = controller
        rootController.closePanel()
    }
    
    
    func fillThemes()  {
        let firstThemeDictionary = retrieveDictionary(withKey: "ASPIRE")
        // exist
        if firstThemeDictionary == nil {
            let firstDic = ["logo" : "LOGO Aspire","themeColor1":"184685","themeColor2":"cbced1","loginBackgroundImage":"Login Background ASPIRE","loginTitleColor":"8a8a8a"]
            save(dictionary: firstDic, forKey: "ASPIRE")
        }
        
        let secondThemeDictionary = retrieveDictionary(withKey: "RAIL")
        // exist
        if secondThemeDictionary == nil {
            let firstDic = ["logo" : "LOGO Rial","themeColor1":"a79373","themeColor2":"cbced1","loginBackgroundImage":"Login Background RAIL","loginTitleColor":"867252"]
            save(dictionary: firstDic, forKey: "RAIL")
        }
        
        let thirdThemeDictionary = retrieveDictionary(withKey: "Qatar")
        // exist
        if thirdThemeDictionary == nil {
            let firstDic = ["logo" : "LOGO Qatar","themeColor1":"5c0632","themeColor2":"cbced1","loginBackgroundImage":"Login Background Qater","loginTitleColor":"5c1f3e"]
            save(dictionary: firstDic, forKey: "Qatar")
        }
        
        
        let fourthThemeDictionary = retrieveDictionary(withKey: "Hamad")
        // exist
        if fourthThemeDictionary == nil {
            let firstDic = ["logo" : "LOGO hamad","themeColor1":"000033","themeColor2":"cbced1","loginBackgroundImage":"Login Background Hamad","loginTitleColor":"07073e"]
            save(dictionary: firstDic, forKey: "Hamad")
        }
        
        let fifthThemeDictionary = retrieveDictionary(withKey: "QWallet")
        // exist
        if fifthThemeDictionary == nil {
            let firstDic = ["logo" : "LOGO QWallet","themeColor1":"5c0632","themeColor2":"cbced1","loginBackgroundImage":"Login Background QWallet","loginTitleColor":"5c1f3e"]
            save(dictionary: firstDic, forKey: "QWallet")
        }
    }
    
    func save(dictionary: [String: String], forKey key: String) {
        let archiver = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        UserDefaults.standard.set(archiver, forKey: key)
    }
    
    func retrieveDictionary(withKey key: String) -> [String: String]? {
        
        // Check if data exists
        let data = userDefaults.object(forKey: key)
        
        
        // Check if retrieved data has correct type
        let retrievedData = data as? Data
        
        
        // Unarchive data
        if retrievedData == nil {
            return nil
        }else{
            let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: retrievedData!)
            return unarchivedObject as? [String: String]
        }
    }
    
    func getCurrenttheme() -> [String:String]{
        return retrieveDictionary(withKey: currentTheme)!
    }
    
    func stopTimer (){
        if globalTimer != nil {
            self.globalTimer.invalidate()
            self.globalTimer = nil
        }
    }
    
    func startTimer() {
        if globalTimer == nil {
            self.globalTimer =  Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(addPushNotification), userInfo: nil, repeats: true)
        }
    }
    func addPushNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addNotification"), object: nil)
    }
    
    
    
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
    
}

// MARK:- AWSCognitoIdentityInteractiveAuthenticationDelegate protocol delegate
