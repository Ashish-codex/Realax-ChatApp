//
//  ExtDictionary.swift
//  Realax
//
//  Created by Ashish Prajapati on 19/01/24.
//

import Foundation

extension Dictionary where Key == String, Value: Any{
    
    func toJson() -> String{
        
        guard let dict = (self as AnyObject) as? Dictionary<String,Any> else{
            AppHelper.printf(statement:"\nError : unable to cast self Dictionary into Dictionary<String,Any>")
            return ""
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [.withoutEscapingSlashes, .prettyPrinted])
            let jsonStr = String(data: jsonData, encoding: .utf8)
            
            return jsonStr ?? ""
        } catch let err {
            AppHelper.printf(statement:"\nError : \(err.localizedDescription)")
        }
        
        return ""
    }
}
