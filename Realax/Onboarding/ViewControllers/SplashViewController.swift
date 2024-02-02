//
//  SplashViewController.swift
//  Realax
//
//  Created by Ashish Prajapati on 31/01/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            guard let mainLoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_MainViewController") as? MainViewController else{
                AppHelper.printf(statement: "Unable to load ID_MainViewController")
                return
            }
            
            guard let chatHomeVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatHomeVC") as? ChatHomeVC else{
                AppHelper.printf(statement: "Unable to load ID_ChatHomeVC")
                return
            }
        
            if UserInfo.isLoggedIn{
                self.navigationController?.pushViewController(chatHomeVC, animated: true)
            }else{
                self.navigationController?.pushViewController(mainLoginVC, animated: true)
            }
        }
    }
    
}
