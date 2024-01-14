//
//  LoginBottomVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import UIKit

class LoginBottomVC: UIViewController {

    
    
    @IBOutlet weak var btnGetLogin: UIButton!
    
    
    @IBOutlet weak var viewEmail: TextFieldPlainView!
    
    @IBOutlet weak var viewPassword: TextFieldWithIconView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnGetLogin.customRoundedButton(radius: 10)
    }
    
    @IBAction func actBtnGetLogin(_ sender: Any) {
        
        guard let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatHomeVC") as? ChatHomeVC else {
            print("Unable to load DashboardVC")
            return
        }
        
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
//        navigationController?.pushViewController(navController, animated: true)
        
        
    }
    
    
    
    
    

}
