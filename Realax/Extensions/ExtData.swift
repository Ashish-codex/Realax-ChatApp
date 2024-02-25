//
//  ExtData.swift
//  Realax
//
//  Created by Ashish Prajapati on 19/01/24.
//

import Foundation

extension Data{
    
    func toJson() -> String{
        do {
            let jsonObj = try JSONSerialization.jsonObject(with: self, options: [])
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObj, options: [.withoutEscapingSlashes, .prettyPrinted])
            let jsonBeuatyfied = String(data: jsonData, encoding: .utf8)
            return jsonBeuatyfied ?? ""
        } catch let err {
            AppHelper.printf(statement:"\nError : \(err.localizedDescription)")
        }
        
        return ""
    }
    
    
    func toDict() -> [String:Any]? {
        do {
            guard let dict = try JSONSerialization.jsonObject(with: self, options: []) as? [String:Any] else{
                AppHelper.printf(statement:"\nUnable to cast Data to [String:Any]")
                return nil
            }
            
            return dict
            
        } catch let err {
            AppHelper.printf(statement:"\nError : \(err.localizedDescription)")
        }
        
        return nil
    }
    
    
    mutating func append(_ string: String,encoding: String.Encoding = .utf8) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
    
}
