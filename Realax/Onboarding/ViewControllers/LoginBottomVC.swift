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
    
    let onboardingVM = OnboardingViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnGetLogin.customRoundedButton(radius: 10)
    }
    
    @IBAction func actBtnGetLogin(_ sender: Any) {

        view.endEditing(true)
        guard !viewEmail.getText().elementsEqual("") || !viewPassword.getText().elementsEqual("") else{
            
            AppHelper.getErrorAlert(msg: "Please enter valid email and password", vc: self) { actionTitle in
            }
            return
        }
        
        apiLogin()
        
        
    }
    
    
    
    
    

}



extension LoginBottomVC{
    
    func apiLogin(){
        AppHelper.showProgressHUD(vc: self)
        let reqData = ModelLoginREQ(email: viewEmail.getText(), password: viewPassword.getText())
        
        onboardingVM.apiLogin(reqUrl: .login, reqBody: reqData, reqHttpMethod: .POST) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resDict) :
                
                UserInfo.isLoggedIn = true
                DispatchQueue.main.async {
                    guard let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatHomeVC") as? ChatHomeVC else {
                        AppHelper.printf(statement:"Unable to load DashboardVC")
                        return
                    }
                    
                    let navController = UINavigationController(rootViewController: vc)
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true)
                    
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
