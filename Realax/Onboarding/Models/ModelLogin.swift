//
//  ModelLoginREQ.swift
//  Realax
//
//  Created by Ashish Prajapati on 28/01/24.
//

import Foundation

struct ModelLoginREQ: Codable{
    
    var email, password: String
    
}




struct ModelLoginRES: Codable {
    let data: LoginDataClass
    let message: String
    let statusCode: Int
    let success: Bool
}


// MARK: - DataClass
struct LoginDataClass: Codable {
    let accessToken: String?
    let user: LoginUser?
    let refreshToken: String?
}

// MARK: - User
struct LoginUser: Codable {
    let id: String?
    let avatar: LoginAvatar?
    let v: Int?
    let role, fullName, username, email: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case avatar
        case v = "__v"
        case role, fullName, username, email, createdAt, updatedAt
    }
}

// MARK: - Avatar
struct LoginAvatar: Codable {
    let id, localPath: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case localPath, url
    }
}
