//
//  ModelGetAllChated.swift
//  Realax
//
//  Created by Ashish Prajapati on 03/02/24.
//

import Foundation


struct ModelGetAllChated: Codable {
    let statusCode: Int
    let data: [ChatData]
    let message: String
    let success: Bool
}

// MARK: - Datum
struct ChatData: Codable {
    let id, name: String
    let isGroupChat: Bool
    let participants: [Participant]
    let admin, createdAt, updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, isGroupChat, participants, admin, createdAt, updatedAt
        case v = "__v"
    }
}

// MARK: - Participant
struct Participant: Codable {
    let id, username, email, role: String
    let fullName: String
    let avatar: LoginAvatar?
    let createdAt, updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, email, role, fullName, avatar, createdAt, updatedAt
        case v = "__v"
    }
}
