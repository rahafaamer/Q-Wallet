//
//  LocationViewController.swift
//  SIM
//
//  Created by Rimon on 10/7/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: BaseViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var dic :[String:String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = MKMapType.standard
        let location = CLLocationCoordinate2D(latitude: 25.286106,longitude: 51.534817)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Q-Wallet Office"
        annotation.subtitle = "Doha"
        mapView.addAnnotation(annotation)
        
        updateLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
