//
//  ModelLogout.swift
//  Realax
//
//  Created by Ashish Prajapati on 30/01/24.
//

import Foundation

struct ModelLogoutREQ:Codable {}


struct ModelLogoutRES: Codable {
    let message: String
    let statusCode: Int
    let success: Bool
}
