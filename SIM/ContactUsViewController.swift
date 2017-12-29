//
//  ContactUSViewController.swift
//  SIM
//
//  Created by Rimon on 10/8/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import MapKit


class ContactUsViewController: BaseViewController,MKMapViewDelegate {
    
    
    @IBOutlet var backroundView: UIView!
    
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressBackgroundView: UIView!
    @IBOutlet weak var phoneBckgroundview: UIView!
    @IBOutlet weak var emailBackgroundView: UIView!
    var dic :[String:String] = [:]
    override func viewDidLoad() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard
        let location = CLLocationCoordinate2D(latitude:25.286106 ,longitude: 51.534817)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 25.286106, longitude: 51.534817)
        annotation.title = "Q-Wallet Office"
        mapView.addAnnotation(annotation)
        
        mapView.setRegion(region, animated: true)

        super.viewDidLoad()
        updateLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        // Do any additional setup after loading the view.
    }

   /* override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateLayout() {
        dic = AppDelegate.sharedDelegate().getCurrenttheme()
        backroundView.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        addressBackgroundView.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        phoneBckgroundview.backgroundColor = UIColor(hex: dic["themeColor1"]!)
        emailBackgroundView.backgroundColor = UIColor(hex: dic["themeColor1"]!)
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
