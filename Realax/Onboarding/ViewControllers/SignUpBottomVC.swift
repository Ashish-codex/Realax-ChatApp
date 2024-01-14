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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }

    
    
    
    @IBAction func actBtnSingUp(_ sender: Any) {
        
        guard let selectGenderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_SelectGenderVC") as? SelectGenderVC else {
            print("Unable to found Login ViewController")
            return
        }
        
        let navController = UINavigationController(rootViewController: selectGenderVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
//        navigationController?.pushViewController(selectGenderVC, animated: true)
        
        
        
    }
    
    

    func setupUI(){
        
        viewFullName.setPlaceHolder(placeholder: "Full Name")
        viewEmail.setPlaceHolder(placeholder: "Email")
        viewPassword.setPlaceHolder(placeholder: "Password")
        viewRole.setPlaceHolder(placeholder: "Role")
        
        viewPassword.setImageFieldIcon(icon: UIImage(named: "visibility_eye")!)
        viewRole.setImageFieldIcon(icon: UIImage(named: "arrow_drop_down")!)
        
        btnSingUp.customRoundedButton(radius: 10)
    }
    

}
