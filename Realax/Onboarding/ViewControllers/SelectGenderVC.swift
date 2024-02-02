//
//  TempViewController.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import UIKit

class SelectGenderVC: UIViewController {

    
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var viewFemale: UIView!
    
    @IBOutlet weak var imgMaleCheckIcon: UIImageView!
    @IBOutlet weak var imgFemaleCheckIcon: UIImageView!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
 
   
    @IBAction func actBtnSelectMale(_ sender: Any) {
        selectGender(isMale: true)
    }
    
    @IBAction func actBtnSelectFemale(_ sender: Any) {
        selectGender(isMale: false)
    }
    
    
    
    
    @IBAction func actBtnContinue(_ sender: Any) {
        
        guard let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ID_MainViewController") as? MainViewController else{
            AppHelper.printf(statement:"Unable to found Login ViewController")
            return
        }
        
        navigationController?.pushViewController(mainVC, animated: true)
        mainVC.registorType = "Get Login"
    }
    
    
    func setupUI(){
        
        //Default color n radius
        viewMale.customRoundedView(radius: 8)
        viewFemale.customRoundedView(radius: 8)
        viewMale.backgroundColor = UIColor(rgb: 0xF1F2F4)
        viewFemale.backgroundColor = UIColor(rgb: 0xF1F2F4)
        imgMaleCheckIcon.image = UIImage(named: "uncheck_icon")
        imgFemaleCheckIcon.image = UIImage(named: "uncheck_icon")
        
        btnContinue.customRoundedButton(radius: 10)
    }
    
    func selectGender(isMale: Bool){
        
        if isMale{
            
            UIView.animate(withDuration: 0.4, delay: 0.0,options: .allowAnimatedContent) { [self] in
                
                //Male
                viewMale.backgroundColor = UIColor.white
                viewMale.customRoundedView(radius: 8, borderColor: UIColor(rgb: 0x00A9FF).cgColor, borderWidth: 1.5)
                viewMale.dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
                imgMaleCheckIcon.image = UIImage(named: "check_icon")
                
                
                
                //Female
                viewFemale.backgroundColor = UIColor(rgb: 0xF1F2F4)
                viewFemale.customRoundedView(radius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
                viewFemale.dropShadow(color: UIColor.clear, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 0)
                
                imgFemaleCheckIcon.image = UIImage(named: "uncheck_icon")
            }
            
        
        }else{
            
            UIView.animate(withDuration: 0.4, delay: 0.0,options: .allowAnimatedContent) { [self] in
                
                
                //Female
                viewFemale.backgroundColor = UIColor.white
                viewFemale.customRoundedView(radius: 8, borderColor: UIColor(rgb: 0x00A9FF).cgColor, borderWidth: 1.5)
                viewFemale.dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
                imgFemaleCheckIcon.image = UIImage(named: "check_icon")
                
                
                
                //Male
                viewMale.backgroundColor = UIColor(rgb: 0xF1F2F4)
                viewMale.customRoundedView(radius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
                viewMale.dropShadow(color: UIColor.clear, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 0)
                imgMaleCheckIcon.image = UIImage(named: "uncheck_icon")

            }
            
        }
        
        
        
    }
    
}
