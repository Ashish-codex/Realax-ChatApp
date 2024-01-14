//
//  ExtUIImage.swift
//  Realax
//
//  Created by Ashish Prajapati on 30/12/23.
//

import Foundation
import UIKit

extension UIImageView{
    
    func circularImage(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
//        self.layer.masksToBounds = false
    }
    
    func setImageColor(color: UIColor){
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
