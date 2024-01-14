//
//  ExtView.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import Foundation
import UIKit

extension UIView{
    func customRoundedView(
        radius: CGFloat = 10.0,
        borderColor: CGColor? = UIColor.clear.cgColor,
        borderWidth: CGFloat = 0.0){
        
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.borderColor = borderColor
            layer.borderWidth = borderWidth
            
    }
    
    
    func byRoundingCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
    
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

//      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//      layer.shouldRasterize = true
//      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
