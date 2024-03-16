//
//  AppHelpler.swift
//  Realax
//
//  Created by Ashish Prajapati on 31/12/23.
//

import Foundation
import UIKit
import MBProgressHUD


class AppHelper{
    
    static var windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    static private var statusBar: UIView?
    
    
    
   // MARK: - Set Status Bar Color
    class func setStatusBarColor(color: UIColor){
        statusBar = UIView(frame: windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        statusBar?.backgroundColor = color
        windowScene?.keyWindow?.addSubview(statusBar ?? UIView())
        
        
    }
    
    class func removeStatusBarColor(){
        statusBar?.removeFromSuperview()
    }
    
    
    
    
    // MARK: - Show Progress HUD
    class func showProgressHUD(vc: UIViewController){
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
            hud.mode = .indeterminate
            hud.label.text = AppConstant.kMSG_LOADING
        }
    }
    
    
    class func hideProgessHUD(vc: UIViewController){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: vc.view, animated: true)
        }
    }
    
    
    
    
    
    // MARK: - Show Error Alert
    class func getErrorAlert(msg:String, vc:UIViewController, complition: @escaping(_ actionTitle: String) -> Void){
        
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: AppConstant.kAPP_NAME, message: msg, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { action in
                complition(action.title ?? "")
            }))
            
            vc.present(alertVC, animated: true)
        }
    }
    

    // MARK: - Show Alert
    class func getAlert(msg:String, vc:UIViewController, complition: @escaping(_ actionTitle: String) -> Void){
        
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: AppConstant.kAPP_NAME, message: msg, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                complition(action.title ?? "")
            }))
            
            vc.present(alertVC, animated: true)
        }
    }
    
    

    // MARK: - Printf
    class func printf(statement: String){
        print("\n\(statement)")
    }
    
}



extension AppHelper{
    
    enum SocketEvents: String{
        case connected = "connected"
        case disconnect = "disconnect"
        case joinChat = "joinChat"
        case leaveChat = "leaveChat"
        case updateGroupName = "updateGroupName"
        case messageReceived = "messageReceived"
        case newChat = "newChat"
        case socketError = "socketError"
        case stopTyping = "stopTyping"
        case typing = "typing"
 
    }
}
