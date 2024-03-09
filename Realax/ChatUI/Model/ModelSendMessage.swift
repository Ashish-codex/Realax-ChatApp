//
//  ModelSendMessage.swift
//  Realax
//
//  Created by Ashish Prajapati on 17/02/24.
//

import Foundation

struct ModelSendMessageREQ:Codable{
    var content: String? = nil
    var attachments: Data? = nil
}


struct ModelSendMessageRES: Codable {
    let statusCode: Int
    let data: DataGellAllMessages
    let message: String
    let success: Bool
}

// MARK: - DataClass
//struct DataSendMessage: Codable {
//    let id: String?
//    let sender: SenderData?
//    let content: String?
//    let attachments: [String?]?
//    let chat, createdAt, updatedAt: String?
//    let v: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case sender, content, attachments, chat, createdAt, updatedAt
//        case v = "__v"
//    }
//}
//
//
//struct SenderData: Codable {
//    let id, username, email: String?
//    let avatar: LoginAvatar?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case username, email, avatar
//    }
//}
//
