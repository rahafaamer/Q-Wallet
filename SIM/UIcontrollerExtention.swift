

import Foundation
import UIKit
extension UIViewController{
    func addBackBtn()  {
        let back = UIBarButtonItem(image: UIImage(named:"smallBack")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.pop))
        back.tintColor = UIColor.black
        self.navigationItem.setLeftBarButton(back, animated: false)
    }
    func pop()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNavWithLogo(image:String)  {
        let imageContainer = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 35))
        imageContainer.contentMode = .scaleAspectFit
        imageContainer.image = UIImage(named: image)
        self.navigationItem.titleView = imageContainer
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    // Put this piece of code anywhere you like
   
//    func addNavWithPizzaLogoLeft()  {
//        let imageContainer = UIImageView(frame: CGRect(x: 0, y: 0, width: 174, height: 44))
//        imageContainer.contentMode = .scaleAspectFit
//        imageContainer.image = UIImage(named: "ph-logo")
//        self.navigationItem.titleView = imageContainer
//    }
//    
//    func addNavWithJustPizzaLogoLeft()  {
//        let imageContainer = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
//        imageContainer.contentMode = .scaleAspectFit
//        imageContainer.image = UIImage(named: "ph-header")
//        self.navigationItem.titleView = imageContainer
//    }
//    
//    func addNavWithJustPizzaLogoLeftAndCenterName(name:String)  {
//        let TView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        imageView.contentMode = .scaleToFill
//        imageView.image = UIImage(named: "ph-header")
//        
//        let sectionLabel = UILabel(frame: CGRect(x: 45, y: 0, width: 150, height: 40))
//        sectionLabel.textColor = UIColor.black
//        sectionLabel.font = UIFont(name: "MuseoSansW01-Rounded700", size: 17)
//        sectionLabel.text = name
//        
//        TView.addSubview(imageView)
//        TView.addSubview(sectionLabel)
//        
//        self.navigationItem.titleView = TView
//    }

}
