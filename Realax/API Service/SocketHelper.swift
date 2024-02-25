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
    
    let tempDemoSocketUrl = "http://192.168.0.103:3000"
    let realaxSocketUrl = "http://192.168.0.103:8000"
    
    private init(){
        
        guard let baseURL = URL(string: ApiRoute.baseUrl.rawValue) else{
            AppHelper.printf(statement: "Unable to load BaseURL from SocketHelper")
            return
        }
        
        manager = SocketManager(socketURL: baseURL, config: [
            .log(true),
            .compress,
            
        ])
        
        socketClient = manager.defaultSocket
        
    }
    
    
    func connectSocket(){
        if (socketClient.status != .connected){
            
            socketClient.on(AppHelper.SocketEvents.connected.rawValue) { data,
                ack in
                AppHelper.printf(statement: "Socket connected successfully with id : \(data.first ?? "N/A")")
            }
            
            socketClient.connect(withPayload: ["token": UserInfo.accessToken ])
            
            
            
        }
    }
    
    
    func disconnectSocket(){
        if (socketClient.status != .disconnected){
            socketClient.on(AppHelper.SocketEvents.disconnect.rawValue) { data,
                ack in
                AppHelper.printf(statement: "Socket disconnect with id \(data.first ?? "N/A")")
            }
            
            socketClient.disconnect()
        }
    }
    
    
    func socketOn(event: AppHelper.SocketEvents, complition: @escaping (_ data: [Any])-> Void){
        let uuid = socketClient.on(event.rawValue) { data, ack in
            complition(data)
        
        }
        AppHelper.printf(statement: "Socket UUID: \(uuid)")
    }
    
    
    func socketEmit(event: AppHelper.SocketEvents, with data: SocketData){
        socketClient.emit(event.rawValue, data)
        
    }
    


    
    
}
