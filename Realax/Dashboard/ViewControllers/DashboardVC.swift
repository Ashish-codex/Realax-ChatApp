//
//  DashboardVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 26/12/23.
//

import UIKit

class DashboardVC: UIViewController {
    
    
    @IBOutlet weak var viewProfileImg: UIView!
    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.setNavigationBarHidden(true, animated: true)
        lblUserName.text = "Hello, \(UserInfo.userName)"
        btnGetStarted.customRoundedButton(radius: 10)
        viewProfileImg.customRoundedView(radius: viewProfileImg.frame.height / 2)
    }
    

    
    @IBAction func actBtnGetStarted(_ sender: Any) {
        
        guard let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatHomeVC") as? ChatHomeVC else {
            AppHelper.printf(statement:"Unable to load ChatHomeVC")
            return
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
        
//        guard let chatUiVC = UIStoryboard(name: "ChatUI", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatUIVC") as? ChatUIVC else {
//            AppHelper.printf(statement:"Unable to load SettingVC")
//            return
//        }
//
//        navigationController?.pushViewController(chatUiVC, animated: true)
//
//        chatUiVC.atIndex = 0
//        chatUiVC.reciverInfo = Participant(
//            id: "",
//            username:  "",
//            email: "",
//            role: "",
//            fullName:  "",
//            avatar: nil,
//            createdAt: "",
//            updatedAt: "",
//            v: 0)
        
        
    }
    
    
    
    
    

}
