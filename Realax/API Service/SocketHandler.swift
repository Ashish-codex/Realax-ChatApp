//
//  SocketHandler.swift
//  Realax
//
//  Created by Ashish Prajapati on 18/02/24.
//

import Foundation
import SocketIO

class SocketHandler: NSObject {
    static let sharedInstance = SocketHandler()
    let socket = SocketManager(socketURL: URL(string: "localhost://192.168.0.103:3000")!, config: [.log(true), .compress])
    var mSocket: SocketIOClient!

    override init() {
        super.init()
        mSocket = socket.defaultSocket
    }

    func getSocket() -> SocketIOClient {
        return mSocket
    }

    func establishConnection() {
//        mSocket.connect(withPayload: ["token": UserInfo.accessToken])
        mSocket.connect()
    }

    func closeConnection() {
        mSocket.disconnect()
    }
}
