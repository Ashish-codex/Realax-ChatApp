//
//  UserInfo.swift
//  Realax
//
//  Created by Ashish Prajapati on 01/02/24.
//

import Foundation


struct UserInfo{
    
    static var accessToken: String{
        set{
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
        
        get{
            let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String
            return accessToken ?? ""
        }
    }
    
    static var refreshToken: String{
        set{
            UserDefaults.standard.set(newValue, forKey: "refreshToken")
        }
        
        get{
            let accessToken = UserDefaults.standard.value(forKey: "refreshToken") as? String
            return accessToken ?? ""
        }
    }
    
    
    static var isLoggedIn:Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
        }
        
        get{
            let isLogin = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool
            return isLogin ?? false
        }
    }
    
    
    static var avatarURL: String{
        set{
            UserDefaults.standard.set(newValue, forKey: "avatarURL")
        }
        
        get{
            let accessToken = UserDefaults.standard.value(forKey: "avatarURL") as? String
            return accessToken ?? ""
        }
    }
    
    static var role: String{
        set{
            UserDefaults.standard.set(newValue, forKey: "role")
        }
        
        get{
            let accessToken = UserDefaults.standard.value(forKey: "role") as? String
            return accessToken ?? ""
        }
    }
    
    static var fullName: String{
        set{
            UserDefaults.standard.set(newValue, forKey: "fullName")
        }
        
        get{
            let accessToken = UserDefaults.standard.value(forKey: "fullName") as? String
            return accessToken ?? ""
        }
    }
    
    static var userName: String{
        set{
            UserDefaults.standard.set(newValue, forKey: "userName")
        }
        
        get{
            let accessToken = UserDefaults.standard.value(forKey: "userName") as? String
            return accessToken ?? ""
        }
    }
    
    
    static var userID: String{
        set{
            UserDefaults.standard.set(newValue, forKey: "userID")
        }
        
        get{
            let accessToken = UserDefaults.standard.value(forKey: "userID") as? String
            return accessToken ?? ""
        }
    }
    
    
    
    static var email: String{
        set{
            UserDefaults.standard.set(newValue, forKey: "email")
        }
        
        get{
            let accessToken = UserDefaults.standard.value(forKey: "email") as? String
            return accessToken ?? ""
        }
    }
    
    
    static var roomID:String = ""
    
    
    static var chatProfileData: ChatData!
    
}


