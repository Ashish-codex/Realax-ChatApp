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

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            guard let mainLoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_MainViewController") as? MainViewController else{
                AppHelper.printf(statement: "Unable to load ID_MainViewController")
                return
            }
            
//            guard let chatHomeVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatHomeVC") as? ChatHomeVC else{
//                AppHelper.printf(statement: "Unable to load ID_ChatHomeVC")
//                return
//            }
        
            guard let dashboardVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_DashboardVC") as? DashboardVC else{
                AppHelper.printf(statement: "Unable to load ID_DashboardVC")
                return
            }
            
            
            AppHelper.printf(statement: "Access Tokecn: \(UserInfo.accessToken)")
            
            if !UserInfo.accessToken.isEmpty{
                self.navigationController?.pushViewController(dashboardVC, animated: true)
            }else{
                self.navigationController?.pushViewController(mainLoginVC, animated: true)
            }
        }
    }
    
}
