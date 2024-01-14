//
//  ChatUIVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 07/01/24.
//

import UIKit
import MessageKit


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



class ChatUIVC: MessagesViewController{

    let currentUser = Sender(senderId: "self", displayName: "Ashsih P")
    let otherUser = Sender(senderId: "other", displayName: "Deepak J")
    var messages = [MessageType]()
    var chatNavBarView:ChatNavBar = ChatNavBar()
    var atIndex:Int = 0
    var msgContentCell = MessageContentCell()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        
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
    
    
    override func viewDidDisappear(_ animated: Bool) {
        AppHelper.removeStatusBarColor()
        chatNavBarView.removeFromSuperview()
    }
    
    
    
    func setupUI(){
        setNavigationBarUI()
        setMessageKitUI()
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
        chatNavBarView.setData(cellData: ChatCellViewData(profileImg: "profile_img1", title: "Rosalee Molina \(atIndex)", subTitle: "", lastMsgTime: "", isOnline: true, isTyping: false))
        
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

}





extension ChatUIVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    // MARK: - MessagesLayoutDelegate
    
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
    

    
    
    // MARK: - MessagesDisplayDelegate
    
    
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
