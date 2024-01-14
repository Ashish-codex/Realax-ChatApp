//
//  ExtTextField.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import Foundation
import UIKit

extension UITextField{
    
    func customRoundedTxtField(
        radius: CGFloat = 10.0,
        borderColor: CGColor = UIColor.clear.cgColor,
        borderWidth: CGFloat = 0.0){
        
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.borderColor = borderColor
            layer.borderWidth = borderWidth
            
    }
}


extension UIApplication {

    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }

}
