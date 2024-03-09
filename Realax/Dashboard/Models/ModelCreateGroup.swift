//
//  ModelCreateGroup.swift
//  Realax
//
//  Created by Ashish Prajapati on 27/02/24.
//

import Foundation


struct ModelCreateGroupREQ: Codable {
    let name: String
    let participants: [String]
}



struct ModelCreateGroupRES: Codable {
    let statusCode: Int
    let data: DataGroupChat
    let message: String
    let success: Bool
}



struct DataGroupChat: Codable {
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
