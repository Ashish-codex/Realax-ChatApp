//
//  UserInfo.swift
//  Realax
//
//  Created by Ashish Prajapati on 01/02/24.
//

import Foundation


struct UserInfo{
    
    static var accessToken: String = ""
    static var refreshToken: String = ""
    static var isLoggedIn:Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
//            self.isLoggedIn = newValue
        }
        
        get{
            let isLogin = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool
            return isLogin ?? false
        }
    }
}
