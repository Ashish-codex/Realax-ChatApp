//
//  AppHelpler.swift
//  Realax
//
//  Created by Ashish Prajapati on 31/12/23.
//

import Foundation
import UIKit


class AppHelper{
    
    static var windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    static private var statusBar: UIView?
    class func setStatusBarColor(color: UIColor){
        statusBar = UIView(frame: windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        statusBar?.backgroundColor = color
        windowScene?.keyWindow?.addSubview(statusBar ?? UIView())
        
        
    }
    
    class func removeStatusBarColor(){
        statusBar?.removeFromSuperview()
    }
    
    
    
    
}
