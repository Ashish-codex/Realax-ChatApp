//
//  SocketHelper.swift
//  Realax
//
//  Created by Ashish Prajapati on 04/02/24.
//

import Foundation
import SocketIO

class SocketHelper{
    
    public static let shared = SocketHelper()
    private var manager: SocketManager!
    var socketClient: SocketIOClient!
    typealias SocketCallBackHandler = ( _ event: AppHelper.SocketEvents, _ data: [Any]) -> Void
    
    private init(){
        
        guard let baseURL = URL(string: ApiRoute.baseUrl.rawValue) else{
            AppHelper.printf(statement: "Unable to load BaseURL from SocketHelper")
            return
        }
        
        manager = SocketManager(socketURL: baseURL, config: [
            .log(true),
            .compress,
            .connectParams([
                "token": UserInfo.accessToken
            ])
        ])
        
        socketClient = manager.defaultSocket
        
    }
    
    
    func connectSocket(){
        if (socketClient.status != .connected){
            
            socketClient.on(AppHelper.SocketEvents.connected.rawValue) { data,
                ack in
                AppHelper.printf(statement: "Socket connected successfully...")
            }
            
            socketClient.connect(withPayload: ["token": UserInfo.accessToken ])
            
            
        }
    }
    
    
    func disconnectSocket(){
        socketClient.on(AppHelper.SocketEvents.disconnect.rawValue) { data,
            ack in
            AppHelper.printf(statement: "Socket disconnect...")
        }
        
        socketClient.disconnect()
    }
    
    
    func socketOn(event: AppHelper.SocketEvents, complition: @escaping (_ data: [Any])-> Void){
        let uuid = socketClient.on(event.rawValue) { data, ack in
            complition(data)
        
        }
        AppHelper.printf(statement: "Socket UUID: \(uuid)")
    }
    
    
    func socketEmit(event: AppHelper.SocketEvents, with data: [SocketData]){
        socketClient.emit(event.rawValue, with: data, completion: nil)
    }
    


    
    
}
