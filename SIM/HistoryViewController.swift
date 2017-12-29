//
//  HistoryViewController.swift
//  SIM
//
//  Created by SSS on 9/11/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class HistoryViewController:BaseViewController ,UITableViewDelegate,UITableViewDataSource,iCarouselDataSource,iCarouselDelegate{

    @IBOutlet weak var carousel: iCarousel!
    var isGrid = true
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var displayImage: UIImageView!
    var images : [String] = []
    var dic :[String:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLayout), name: NSNotification.Name(rawValue: "changeTheme"), object: nil)
        images.append("pol1")
        images.append("pol2")
        images.append("pol3")
        images.append("pol1")
        images.append("pol2")
        images.append("pol3")
        images.append("pol1")
        images.append("pol2")
        images.append("pol3")

        carousel.delegate = self
        carousel.type = .coverFlow
        carousel.reloadData()

        Loader.addLoaderTo(self.tableView)
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(HistoryViewController.loaded), userInfo: nil, repeats: false)


        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loaded()
    {
        Loader.removeLoaderFrom(self.tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewTableViewCell
     // cell.underView.backgroundColor = UIColor.clear
        cell.cellBackground.image = UIImage(named: images[indexPath.row])
        return cell    }
    
    

    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return images.count
        
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        var itemView =  UIImageView()
        itemView = UIImageView(frame:CGRect(x:0, y:0 ,  width: self.view.frame.width , height: self.view.frame.width))
        itemView.layer.cornerRadius = 30
        itemView.layer.shadowOpacity = 0.5
        //itemView.layer.cornerRadius = 30
        itemView.layer.masksToBounds = true
        //itemView.layer.borderWidth =  5
        //itemView.layer.borderColor = UIColor.gray.cgColor
        //itemView.clipsToBounds = true
        itemView.layer.shadowOffset = CGSize(width: 0, height: 40)
        itemView.layer.shadowRadius = 20
        //itemView.backgroundColor = UIColor.gray
        
        
        itemView.contentMode = .center
        itemView.isUserInteractionEnabled = false
        
        itemView.image = UIImage(named: images[index])
        return itemView
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .spacing)
        {
            return value * 1.1
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
       
    }

    
    
    @IBAction func onChangeDisplay(_ sender: Any) {
        if isGrid{
            isGrid = false
            self.gridView.isHidden = true
            self.carousel.isHidden = false
            self.displayLabel.text = "View as grid"
            self.displayImage.image = UIImage(named: "icon 08-1")
        }else{
            isGrid = true
            self.gridView.isHidden = false
            self.carousel.isHidden = true
            self.displayLabel.text = "View as gallery"
            self.displayImage.image = UIImage(named: "icon 09")
        }
    }
    
    func updateLayout() {
        dic = AppDelegate.sharedDelegate().getCurrenttheme()
        self.addNavWithLogo(image: dic["logo"]!)
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: dic["themeColor1"]!)
        self.tableView.reloadData()
    }
}
