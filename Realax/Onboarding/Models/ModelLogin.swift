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
    let accessToken, refreshToken: String
    let user: LoginUser
}

// MARK: - User
struct LoginUser: Codable {
    let v: Int
    let id: String
    let avatar: LoginAvatar
    let createdAt, email: String
    let isEmailVerified: Bool
    let loginType, role, updatedAt, username: String

    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case avatar, createdAt, email, isEmailVerified, loginType, role, updatedAt, username
    }
}

// MARK: - Avatar
struct LoginAvatar: Codable {
    let id, localPath: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case localPath, url
    }
}
