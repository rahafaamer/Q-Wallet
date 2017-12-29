//
//  TourViewController.swift
//  SIM
//
//  Created by Rimon on 9/12/17.
//  Copyright © 2017 SSS. All rights reserved.
//

import UIKit

class TourViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    var sentences = ["Below is a sample of “Lorem ipsum dolor sit” dummy copy text often used to show font face samples, for page layout and design as sample layout text by printers","this is the first sentence in tour view controller welcom to the application sad asdasda sdkla nasd"]
    var currentIndex:IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        currentIndex = IndexPath(row: 0, section: 0)
        skipBtn.layer.cornerRadius = 10
        skipBtn.layer.borderColor = UIColor.white.cgColor
        skipBtn.layer.borderWidth = 1.5
        
        leftBtn.isEnabled = false
        rightBtn.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tourCell", for: indexPath) as! TourCollectionViewCell
        cell.descLebel.text = sentences[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width - 5, height: self.collectionView.frame.height)
    }
    @IBAction func onSkip(_ sender: Any) {
    }
    @IBAction func onLeft(_ sender: Any) {
        if currentIndex.row != 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.currentIndex = IndexPath(row: self.currentIndex.row + 1, section: 0)
                self.collectionView.scrollToItem(at: self.currentIndex, at: .centeredHorizontally, animated: true)
                self.backgroundImage.image = UIImage(named:"Background-1")
            })
        }
    }

    @IBAction func onRight(_ sender: Any) {
        if currentIndex.row != 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.currentIndex = IndexPath(row: self.currentIndex.row - 1, section: 0)
                self.collectionView.scrollToItem(at: self.currentIndex, at: .centeredHorizontally, animated: true)
                self.backgroundImage.image = UIImage(named:"Background")
            })
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
