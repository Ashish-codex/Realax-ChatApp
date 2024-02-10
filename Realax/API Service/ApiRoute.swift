//
//  APIRoute.swift
//  Realax
//
//  Created by Ashish Prajapati on 18/01/24.
//

import Foundation

enum ApiRoute: String {
    
    case baseUrl = "https://chatsapp-nw05.onrender.com/"
    
    //Auth Api
    case refreshToken = "api/v1/users/refresh-token"
    case logOut = "api/v1/users/logout"
    case register = "api/v1/users/register"
    case login = "api/v1/users/login"
    
    
    //Chat Api
    case getAllChats = "api/v1/chat-app/chats"
    case searchVariableUser = "api/v1/chat-app/chats/users"
    case getGroupChatDetail = "api/v1/chat-app/chats/group/:chatId"
    case leaveGroupChat = "api/v1/chat-app/leave/group/:chatId"
    case createGroupChat = "api/v1/chat-app/group"
    case createOneToOneChat = "api/v1/chat-app/c/:receiverId"
    
}
