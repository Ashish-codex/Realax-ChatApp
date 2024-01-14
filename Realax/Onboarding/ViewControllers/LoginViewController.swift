//
//  LoginViewController.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import UIKit

class LoginViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_LoginBottomVC")
        
        if let sheet = loginVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.presentedViewController.isModalInPresentation = true
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        self.present(loginVC, animated: true)
    }
    
    
    @IBAction func actBtnSignup(_ sender: Any) {
        
        dismiss(animated: true)
        
        let singupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_SingupViewController")
        
        navigationController?.pushViewController(singupViewController, animated: true)
    }
    

}
