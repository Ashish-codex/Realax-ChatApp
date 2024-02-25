//
//  ModelGetAllChats.swift
//  Realax
//
//  Created by Ashish Prajapati on 17/02/24.
//

import Foundation

// MARK: - Welcome
struct ModelGetAllMessages: Codable {
    let success: Bool
    let statusCode: Int
    let data: [DataGellAllMessages]
    let message: String
}

// MARK: - Datum
struct DataGellAllMessages: Codable {
    let id: String?
    let sender: SenderMessage?
    let content: String?
    let v: Int?
    let chat: String?
    let attachments: [Attachment]?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sender, content
        case v = "__v"
        case chat, attachments, createdAt, updatedAt
    }
}

// MARK: - Attachment
struct Attachment: Codable {
    let url: String?
    let localPath, id: String?

    enum CodingKeys: String, CodingKey {
        case url, localPath
        case id = "_id"
    }
}



// MARK: - Sender
struct SenderMessage: Codable {
    let username, email, id: String?
    let avatar: LoginAvatar?

    enum CodingKeys: String, CodingKey {
        case username, email
        case id = "_id"
        case avatar
    }
}



