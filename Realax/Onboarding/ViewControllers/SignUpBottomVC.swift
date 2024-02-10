//
//  SignUpVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import UIKit

class SignUpBottomVC: UIViewController {

    
    @IBOutlet weak var viewFullName: TextFieldPlainView!
    @IBOutlet weak var viewEmail: TextFieldPlainView!
    @IBOutlet weak var viewPassword: TextFieldWithIconView!
    @IBOutlet weak var viewRole: TextFieldWithIconView!
    @IBOutlet weak var btnSingUp: UIButton!
    
    
    
    
    let onboardingVM = OnboardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }

    
    
    
    @IBAction func actBtnSelectRole(_ sender: Any) {
        
        let alertVC = UIAlertController(title: "Select Role", message: "", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Admin", style: .default, handler: { _ in
            self.viewRole.setText(text: "Admin")
        }))
        alertVC.addAction(UIAlertAction(title: "User", style: .default, handler: { _ in
            self.viewRole.setText(text: "User")
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alertVC, animated: true)
        
    }
    
    
    @IBAction func actBtnSingUp(_ sender: Any) {
        
        guard !viewFullName.getText().elementsEqual("") else{
            AppHelper.getErrorAlert(msg: "Full Name is requried", vc: self) { actionTitle  in}
            return
        }
        
        guard !viewEmail.getText().elementsEqual("") else{
            AppHelper.getErrorAlert(msg: "Email is requried", vc: self) { actionTitle  in}
            return
        }
        
        guard !viewPassword.getText().elementsEqual("") else{
            AppHelper.getErrorAlert(msg: "Password is requried", vc: self) { actionTitle  in}
            return
        }
        
        guard !viewRole.getText().elementsEqual("") else{
            AppHelper.getErrorAlert(msg: "Role  is requried", vc: self) { actionTitle  in}
            return
        }
        
        apiRegistration()
        
    }
    
    

    func setupUI(){
        
        viewFullName.setPlaceHolder(placeholder: "Full Name")
        viewFullName.setKeyboardType(type: .alphabet)
        
        viewEmail.setPlaceHolder(placeholder: "Email")
        viewEmail.setKeyboardType(type: .emailAddress)
        
        viewPassword.setPlaceHolder(placeholder: "Password")
        viewPassword.setKeyboardType(type: .default)
        viewPassword.delegate = self
        
        
        viewRole.setPlaceHolder(placeholder: "Role")
        viewRole.isSecureTextField(isSecure: false)
        
        viewPassword.setImageFieldIcon(icon: UIImage(named: "icon_visibility_eye_hide")!)
        viewRole.setImageFieldIcon(icon: UIImage(named: "arrow_drop_down")!)
        
        btnSingUp.customRoundedButton(radius: 10)
    }
    

}


//MARK: - Protocol
extension SignUpBottomVC:TextFieldWithIconViewDelegate {
    func onClickTextFieldIcon() {
        if viewPassword.getImageFieldIcon() == UIImage(named: "icon_visibility_eye_hide") {
            viewPassword.setImageFieldIcon(icon: UIImage(named: "icon_visibility_eye_unhide")!)
            viewPassword.isSecureTextField(isSecure: false)
        }else{
            viewPassword.setImageFieldIcon(icon: UIImage(named: "icon_visibility_eye_hide")!)
            viewPassword.isSecureTextField(isSecure: true)
        }
        
    }
  
}


//MARK: - Api Service
extension SignUpBottomVC {
    
    func apiRegistration(){
        
        AppHelper.showProgressHUD(vc: self)
        
        let reqData = ModelRegistrationREQ(
            email: viewEmail.getText(),
            password: viewPassword.getText(),
            role: viewRole.getText(),
            username: viewFullName.getText(),
            fullName: viewFullName.getText() )
//            avatar: "")
        
        onboardingVM.apiRegisteration(reqUrl: .register, reqBody: reqData, reqHttpMethod: .POST) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resDict) :
                
                
                guard let selectGenderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_SelectGenderVC") as? SelectGenderVC else {
                    AppHelper.printf(statement:"Unable to found Login ViewController")
                    return
                }
                
                let navController = UINavigationController(rootViewController: selectGenderVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
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
