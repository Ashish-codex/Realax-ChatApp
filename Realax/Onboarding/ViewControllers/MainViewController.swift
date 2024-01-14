//
//  ViewController.swift
//  Realax
//
//  Created by Ashish Prajapati on 16/12/23.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var btnRegistrationType: UIButton!
    
    var registorType: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
        
        
    }
    

    
    @IBAction func actBtnRegistrationType(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Get Login"{
            dismiss(animated: true)
            btnRegistrationType.setTitle("Sign Up", for: .normal)
            presentBottomSheet(className: "LoginBottomVC")
        }else{
            dismiss(animated: true)
            btnRegistrationType.setTitle("Get Login", for: .normal)
            presentBottomSheet(className: "SignUpBottomVC")
        }
        
        
    }
    
    
    
    @IBAction func actBtnGetLogin(_ sender: Any) {
        
//        dismiss(animated: true)
//        presentBottomSheet(className: "LoginViewController")
        
//        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_LoginViewController") as? LoginViewController
//
//        navigationController?.pushViewController(loginViewController!, animated: true)
        
    }
    
    
    
    
    func setupUI(){

        btnRegistrationType.setTitle(registorType ?? "Get Login", for: .normal)
    
        if btnRegistrationType.titleLabel?.text == "Get Login"{
            btnRegistrationType.setTitle("Sign Up", for: .normal)
            presentBottomSheet(className: "LoginBottomVC")
        }else{
            btnRegistrationType.setTitle("Get Login", for: .normal)
            presentBottomSheet(className: "SignUpBottomVC")
        }
    }
    
    
    func presentBottomSheet(className: String){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_\(className)")
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.presentedViewController.isModalInPresentation = true
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        
        self.present(vc, animated: true)
    }

}



