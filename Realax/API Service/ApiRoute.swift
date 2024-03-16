//
//  APIRoute.swift
//  Realax
//
//  Created by Ashish Prajapati on 18/01/24.
//

import Foundation

enum ApiRoute: String {
    
//    case baseUrl = "https://chatsapp-nw05.onrender.com"
    case baseUrl = "http://ec2-52-206-76-43.compute-1.amazonaws.com:8000/"
    
    //Auth Api
    case refreshToken = "api/v1/users/refresh-token"
    case logOut = "api/v1/users/logout"
    case register = "api/v1/users/register"
    case login = "api/v1/users/login"
    
    
    //Chat Api
    case getAllChats = "api/v1/chat-app/chats"
    case searchVariableUser = "api/v1/chat-app/chats/users"
    
    
    ///  createGroupChat, addParticipantsInGroup, deleteGroupChat, removeParticipantsFromGroup
    case chatsGroupURL = "api/v1/chat-app/chats/group/"       //{chatId}/{participantId}
    
    case createOneToOneChat = "api/v1/chat-app/chats/c/"  //{/:roomID}
    
    ///sendMessage, reciveMessage
    case messages = "api/v1/chat-app/messages/"        //{/:roomID} send and recive for both
    
    case leaveGroup = "api/v1/chat-app/chats/leave/group/"  //{chatId}
    case deleteOneToOneChat = "api/v1/chat-app/chats/remove/"   //{chatId}
    
}
