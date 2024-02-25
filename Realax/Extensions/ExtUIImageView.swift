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
    
    
    func loadImageUrl(url: URL) {
      DispatchQueue.global().async { [weak self] in
          if let data = try? Data(contentsOf: url) {
              if let image = UIImage(data: data) {
                  DispatchQueue.main.async {
                      self?.image = image
                  }
              }
          }
          else{
              AppHelper.printf(statement: "Image Error: Failed to load image")
              self?.image = UIImage(named: "img_photo_placeholder")
          }
       }
     }
     
    
}
