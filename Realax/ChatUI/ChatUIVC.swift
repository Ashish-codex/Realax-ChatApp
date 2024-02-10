//
//  ChatUIVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 07/01/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SocketIO

struct Sender:SenderType{
    var senderId: String
    var displayName: String
}


struct Message:MessageType{
    var sender:SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}


// MARK: - ChatUIVC
class ChatUIVC: MessagesViewController{
    

    let currentUser = Sender(senderId: "self", displayName: "Ashsih P")
    let otherUser = Sender(senderId: "other", displayName: "Deepak J")
    var messages = [MessageType]()
    var chatNavBarView:ChatNavBar = ChatNavBar()
    var atIndex:Int = 0
    var msgContentCell = MessageContentCell()
    var reciverInfo: Participant!
    var chatHeaderData:ChatCellViewData!
    
//    private var manager: SocketManager!
//    var socketClient: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupUI()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageInputBar.becomeFirstResponder()
        
        
        
        
        
//        guard let baseURL = URL(string: ApiRoute.baseUrl.rawValue) else{
//            AppHelper.printf(statement: "Unable to load BaseURL from SocketHelper")
//            return
//        }
//
//        manager = SocketManager(socketURL: baseURL, config: [
//            .log(true),
//            .compress,
//            .secure(true),
//            .connectParams([
//                "token": UserInfo.accessToken ?? ""
//            ])
//        ])
//
//        socketClient = manager.defaultSocket
//
//
//        socketClient.connect()
//
//
//        socketClient.on(clientEvent: .connect) { data, ack in
//            AppHelper.printf(statement: "Socket Connect...........................1 ")
//        }
//
//        socketClient.on(AppHelper.SocketEvents.connected.rawValue) { data, ack in
//            AppHelper.printf(statement: "Socket Connect........................... 2")
//        }
//
//
//
//        socketClient.on(AppHelper.SocketEvents.disconnect.rawValue) { data, ack in
//
//        }
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppHelper.removeStatusBarColor()
        chatNavBarView.removeFromSuperview()
//        socketClient.disconnect()
    }
    
    
    
    func setupUI(){
        setNavigationBarUI()
        setMessageKitUI()

        
//        SocketHelper.shared.socketOn(event: .typing) { data in
//            DispatchQueue.main.async {
//                self.chatHeaderData.isTyping = true
//                self.chatNavBarView.setData(cellData: self.chatHeaderData)
//            }
//        }
//
//        SocketHelper.shared.socketOn(event: .stopTyping) { data in
//            DispatchQueue.main.async {
//                self.chatHeaderData.isTyping = false
//                self.chatNavBarView.setData(cellData: self.chatHeaderData)
//            }
//        }
        
    }
    
    
    func addDummyMessages(){
        
        messages.append(Message(sender: currentUser,
                                messageId: "1",
                                sentDate: Date().addingTimeInterval(-86400),
                                kind: .text("Hey Deepak")))
        
        messages.append(Message(sender: otherUser,
                                messageId: "2",
                                sentDate: Date().addingTimeInterval(-76400),
                                kind: .text("Hello Ashish")))
        
        messages.append(Message(sender: currentUser,
                                messageId: "3",
                                sentDate: Date().addingTimeInterval(-66400),
                                kind: .text("Kya bolta hai bhai")))
        
        messages.append(Message(sender: currentUser,
                                messageId: "4",
                                sentDate: Date().addingTimeInterval(-60400),
                                kind: .text("Kya chal rha hai. Chat app ka UI hua kay tum log ka ")))
        
        messages.append(Message(sender: currentUser,
                                messageId: "4",
                                sentDate: Date().addingTimeInterval(-60400),
                                kind: .text("Kya chal rha hai. Chat app ka UI hua kay tum log ka ")))
        
        messages.append(Message(sender: currentUser,
                                messageId: "4",
                                sentDate: Date().addingTimeInterval(-60400),
                                kind: .text("Kya chal rha hai. Chat app ka UI hua kay tum log ka ")))
        
        messages.append(Message(sender: otherUser,
                                messageId: "5",
                                sentDate: Date().addingTimeInterval(-56400),
                                kind: .text("Haa chal rha hai UI developement")))
        
        messages.append(Message(sender: otherUser,
                                messageId: "6",
                                sentDate: Date().addingTimeInterval(-50400),
                                kind: .text("Yash ne dashboard ka ui finish kiya hai or abi me one to one ka bana rha hu.")))
        
        messages.append(Message(sender: currentUser,
                                messageId: "7",
                                sentDate: Date().addingTimeInterval(-46400),
                                kind: .text("Good. keep going")))
        
        messages.append(Message(sender: otherUser,
                                messageId: "8",
                                sentDate: Date().addingTimeInterval(-36400),
                                kind: .text("Yesss")))
        
        messages.append(Message(sender: otherUser,
                                messageId: "9",
                                sentDate: Date().addingTimeInterval(-26400),
                                kind: .text("Chal bye bro..")))
        
        messages.append(Message(sender: currentUser,
                                messageId: "10",
                                sentDate: Date().addingTimeInterval(-16400),
                                kind: .text("Nikal Laude ..")))
            
    }
    
    func setNavigationBarUI(){
        let navigationBound = navigationController!.navigationBar.bounds
        AppHelper.setStatusBarColor(color: .primaryThemeColor)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .primaryThemeColor
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        /// Chat Header with profile (Navigation bar)
        chatNavBarView = ChatNavBar(frame: CGRect(x: 42, y: 0, width: navigationBound.width - 42, height: navigationBound.height))
        
        chatHeaderData = setReciverInfo(data: reciverInfo)
        chatNavBarView.setData(cellData: chatHeaderData)
        
        navigationController?.navigationBar.addSubview(chatNavBarView)
        chatNavBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatNavBarView.trailingAnchor.constraint(equalTo: (navigationController?.navigationBar.trailingAnchor)!),
            chatNavBarView.centerYAnchor.constraint(equalTo: (navigationController?.navigationBar.centerYAnchor)!),
            chatNavBarView.widthAnchor.constraint(equalToConstant: navigationBound.width - 42),
            chatNavBarView.heightAnchor.constraint(equalToConstant: navigationBound.height)
        ])
    }
    
    func setMessageKitUI(){

    }
    
    func setReciverInfo(data: Participant) -> ChatCellViewData{
        var chat = ChatCellViewData(
            profileImg: "",
            title: data.fullName,
            subTitle: "",
            lastMsgTime: "",
            isOnline: false,
            isTyping: false
        )

        return chat
    }

}




// MARK: - MessagesDataSource
extension ChatUIVC: MessagesDataSource{
    
    func currentSender() -> MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
   
}



// MARK: - MessagesLayoutDelegate
extension ChatUIVC: MessagesLayoutDelegate{
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if message.messageId == "1"{
            return 15
        }
        
//        if messages[]{
//
//        }
        
        return 2
        
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    

    
}




// MARK: - MessagesDisplayDelegate
extension ChatUIVC: MessagesDisplayDelegate{
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if message.sender.senderId == "self"{
            return .bubbleTail(.bottomRight, .pointedEdge)
        }else{
            return .bubbleTail(.bottomLeft, .pointedEdge)
        }
        
    }
    
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        if message.sender.senderId == "self"{
            return UIColor.currentSenderColor
        }
        else{
            return UIColor.otherSenderColor
        }
    }
    
    
}




// MARK: - InputBarAccessoryViewDelegate
extension ChatUIVC: InputBarAccessoryViewDelegate{

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            AppHelper.printf(statement: "replacingOccurrences")
            return
        }
        
        
        messages.append(Message(sender: currentUser,
                                messageId: UUID().uuidString,
                                sentDate: Date().addingTimeInterval(-16400),
                                kind: .text(text)))
        
        messageInputBar.inputTextView.text = ""
        messagesCollectionView.scrollToLastItem(animated: true)
//        messagesCollectionView.reloadDataAndKeepOffset()
        messagesCollectionView.reloadData()
        AppHelper.printf(statement: text)
    }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {

        if text.isEmpty{
//            SocketHelper.shared.socketEmit(event: .stopTyping, with: [])
        }else{
//            SocketHelper.shared.socketEmit(event: .typing, with: [])
        }
        
    }
    
}
