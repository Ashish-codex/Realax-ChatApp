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
    
    @IBOutlet weak var lblUserFullName: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    
    
    private var dashboardViewModel = DashboardViewModel()
    
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
        
        setUserDetail()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppHelper.printf(statement:"Setting Disappear")
        AppHelper.removeStatusBarColor()

    }
    
    
    @IBAction func actBtnProfileClick(_ sender: Any) {
    }
    
    
    
    @IBAction func actBtnSwitchIsOnline(_ sender: UISwitch) {
        
    }
    
    
    @IBAction func actBtnAppInfo(_ sender: Any) {
    }
    
   
    @IBAction func actBtnLogout(_ sender: Any) {
        
        let alertVC = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.apiLogout()
        }))
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertVC, animated: true)
    }
    
    
    @IBAction func actBtnDeleteAccount(_ sender: Any) {
    }
    
    
    
    
    func setUserDetail(){
    
        imgProfileImage.image = UIImage(named: "icon_profile_placeholder")
        lblUserFullName.text = UserInfo.fullName
        lblUserName.text = "@\(UserInfo.userName)"
    }
    
    
}





// MARK: - Api Service
extension SettingVC {
    
    func apiLogout(){
        
        AppHelper.showProgressHUD(vc: self)
        let logoutReq = ModelLogoutREQ()
        
        dashboardViewModel.apiLogout(reqUrl: .logOut, reqBody: logoutReq, reqHttpMethod: .POST) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let logoutRes) :
                DispatchQueue.main.async {
                    
                    guard let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_MainViewController") as? MainViewController else{
                        AppHelper.printf(statement: "Unable to load ID_MainViewController after logout")
                        return
                    }
                    
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
                break
                
                
            case.failure(.message(let msg)) :
                AppHelper.getErrorAlert(msg: msg, vc: self) { actionTitle in}
                break
                
                
            case.failure(.error(let err)) :
                AppHelper.getErrorAlert(msg: err.localizedDescription, vc: self) { actionTitle in}
                break
                
            }
        }
        
    }
}
