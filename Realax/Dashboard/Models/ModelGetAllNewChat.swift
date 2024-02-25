//
//  ModelGetAllNewChat.swift
//  Realax
//
//  Created by Ashish Prajapati on 03/02/24.
//

import Foundation


struct ModelGetAllNewChat: Codable {
    let statusCode: Int
    let data: [NewChatData]
    let message: String
    let success: Bool
}

// MARK: - Datum
struct NewChatData: Codable {
    let id: String?
    let username, email: String?
    let avatar: LoginAvatar?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, email, avatar
    }
}



