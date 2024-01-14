//
//  SettingVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 31/12/23.
//

import UIKit

class SettingVC: UIViewController {

    
    @IBOutlet weak var viewContainer1: UIView!
    @IBOutlet weak var viewContainer2: UIView!
    @IBOutlet weak var viewProfileImage: UIView!
    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var viewContainerProfile: UIView!
    @IBOutlet weak var viewHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .primaryThemeColor
        navigationController?.navigationBar.backgroundColor = .primaryThemeColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font : UIFont(name: "HelveticaNeue-Bold", size: 28)
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        title = "Setting"

        AppHelper.setStatusBarColor(color: .primaryThemeColor)
        
        viewContainer1.customRoundedView(radius: 10)
        viewContainer2.customRoundedView(radius: 10)
        viewContainerProfile.customRoundedView(radius: 10)
        viewHeader.layer.cornerRadius = 15
        viewHeader.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        viewContainerProfile.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: -1, height: 1), radius: 8, scale: true)
        viewProfileImage.customRoundedView(radius: imgProfileImage.frame.height / 2, borderColor: UIColor.primaryThemeColor.cgColor, borderWidth: 2)
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Setting Disappear")
        AppHelper.removeStatusBarColor()

    }
    
    
    @IBAction func actBtnProfileClick(_ sender: Any) {
    }
    
    
    
    @IBAction func actBtnSwitchIsOnline(_ sender: UISwitch) {
        
    }
    
    
    @IBAction func actBtnAppInfo(_ sender: Any) {
    }
    
   
    @IBAction func actBtnLogout(_ sender: Any) {
    }
    
    
    @IBAction func actBtnDeleteAccount(_ sender: Any) {
    }
    
    
}
