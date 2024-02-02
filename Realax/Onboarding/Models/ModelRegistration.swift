//
//  ModelRegistration.swift
//  Realax
//
//  Created by Ashish Prajapati on 18/01/24.
//

import Foundation

struct ModelRegistrationREQ: Codable{
    
    var email, password, role, username, fullName, avatar: String
    
}


// MARK: - Temperatures
struct ModelRegistrationRES: Codable {
    let data: RegistrationDataClass
    let message: String
    let statusCode: Int
    let success: Bool
}

// MARK: - DataClass
struct RegistrationDataClass: Codable {
    let user: RegistrationUser
}

// MARK: - User
struct RegistrationUser: Codable {
    let v: Int
    let id: String
    let avatar: RegistrationAvatar
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
struct RegistrationAvatar: Codable {
    let id, localPath: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case localPath, url
    }
}
