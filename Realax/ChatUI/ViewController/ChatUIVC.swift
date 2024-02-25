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
    

    let currentUser = Sender(senderId: "self", displayName: "\(UserInfo.userName)")
    let otherUser = Sender(senderId: "other", displayName: "Deepak J")
    var messages = [MessageType]()
    var chatNavBarView:ChatNavBar = ChatNavBar()
    var atIndex:Int = 0
    var msgContentCell = MessageContentCell()
    var reciverInfo: Participant!
    var chatHeaderData:ChatCellViewData!
    private var chatViewModel = ChatViewModel()
    private var inputBar: InputBarAccessoryView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        apiChatReciveMessages(roomID: UserInfo.roomID)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppHelper.removeStatusBarColor()
        chatNavBarView.removeFromSuperview()
    }
    
    
    
    
    
    
// MARK: - Functions
    func setupUI(){
        setNavigationBarUI()
        setMessageKitUI()
//        addDummyMessages()
        joinChat()
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
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
//        messageInputBar.delegate = self
//        messageInputBar.becomeFirstResponder()
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        showMessageTimestampOnSwipeLeft = true
        
        
        inputBar = iMessageInputBarAccessoryView()
        inputBar.delegate = self
        inputBar.becomeFirstResponder()
        messageInputBar = inputBar
        
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
    
 
    func joinChat(){
        
        SocketHelper.shared.socketEmit(event: .joinChat, with: UserInfo.roomID)
        
        SocketHelper.shared.socketOn(event: .typing) { data in
            DispatchQueue.main.async {
                self.chatNavBarView.isTyping(typing: true)
            }
        }
        
        SocketHelper.shared.socketOn(event: .stopTyping) { data in
            self.chatNavBarView.isTyping(typing: false)
        }
        
        
        SocketHelper.shared.socketOn(event: .messageReceived) { data in
            if let msgStr = data.first as? String{
                AppHelper.printf(statement: "Event : messageReceived\n\(msgStr)")
//                if let msgData = msgStr.data(using: .utf8){
//
//                    do {
//                        let getAllMessages = try JSONDecoder().decode(ModelGetAllMessages.self, from: msgData)
//
//
////                        if item.sender?.username == UserInfo.userName{
////                            if let msgContent = item.content, msgContent != "" {
////                                self.messages.append(Message(
////                                    sender: self.currentUser,
////                                    messageId: item.id ?? UUID().uuidString,
////                                    sentDate: Date(),
////                                    kind: .text("\(msgContent)")))
////                            }else{
////                                self.messages.append(Message(
////                                    sender: self.currentUser,
////                                    messageId: item.id ?? UUID().uuidString,
////                                    sentDate: Date(),
////                                    kind: .text("ATTACHMENT..")))
////                            }
////
////                        }else{
////
////                            if let msgContent = item.content, msgContent != "" {
////                                self.messages.append(Message(
////                                    sender: self.otherUser,
////                                    messageId: item.id ?? UUID().uuidString,
////                                    sentDate: Date(),
////                                    kind: .text("\(msgContent)")))
////                            }else{
////                                self.messages.append(Message(
////                                    sender: Sender(senderId: "other", displayName: "\(item.sender?.username ?? "N/A")"),
////                                    messageId: item.id ?? UUID().uuidString,
////                                    sentDate: Date(),
////                                    kind: .text("ATTACHMENT..")))
////                            }
////
////
////                        }
////
//
//
//                    } catch let err {
//                        AppHelper.getErrorAlert(msg: "Erro: \(err.localizedDescription)", vc: self) { _ in}
//                    }
//                }
            }
        }
        
    }
    
    func setReciverInfo(data: Participant) -> ChatCellViewData{
        var chat = ChatCellViewData(
            profileImg: "",
            title: data.fullName ?? "N/A",
            subTitle: "",
            lastMsgTime: "",
            isOnline: false,
            isTyping: false
        )

        return chat
    }
    
    
    
    func setMessageData(msgData: DataGellAllMessages){
        
        let senderType = (msgData.sender?.username == UserInfo.userName)
        ? Sender(senderId: "self", displayName: "\(msgData.sender?.username ?? "")")
        : Sender(senderId: "other", displayName: "\(msgData.sender?.username ?? "")")
        

        // Content msg for text
        if let msgContent = msgData.content, msgContent != "" {
            self.messages.append(Message(
                sender: senderType,
                messageId: msgData.id ?? UUID().uuidString,
                sentDate: Date(),
                kind: .text("\(msgContent)")))
            
        }else{   // Attachment msg for text
            
//            self.messages.append(Message(
//                sender: senderType,
//                messageId: msgData.id ?? UUID().uuidString,
//                sentDate: Date(),
//                kind: .text("ATTACHMENT..")))
            
            if let arrAttachments = msgData.attachments, !arrAttachments.isEmpty{
                for itemAttachted in arrAttachments{
                    self.messages.append(Message(
                        sender: senderType,
                        messageId: msgData.id ?? UUID().uuidString,
                        sentDate: Date(),
                        kind: .photo(ImageMediaItem(imageURL: URL(string:"\(itemAttachted.url ?? "" )")! ) ) ))
                }
            }
        }
                
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
    
//
//    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        return NSAttributedString(
//            string: "19-Feb-24",
//            attributes: [
//              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
//              NSAttributedString.Key.foregroundColor: UIColor.darkGray,
//            ])
//    }
    
    
//    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        return NSAttributedString(
//            string: "@\(reciverInfo.username)",
//            attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
//    }
//
   
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
        
        return 10
        
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
    
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        switch message.kind{
        case .photo(let img):
            imageView.loadImageUrl(url: img.url!)
            break
            
        default:
            break
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
        
        apiChatSendMessages(roomID: UserInfo.roomID, contentData: text)
    }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {

        if text.isEmpty{
            SocketHelper.shared.socketEmit(event: .stopTyping, with: UserInfo.roomID)
        }else{
            SocketHelper.shared.socketEmit(event: .typing, with: UserInfo.roomID)
        }
        
    }
    
}



//MARK: - Api Service
extension ChatUIVC{
    
    func apiChatSendMessages(roomID:String, contentData: String? = nil, attachments:String? = nil ){
        let reqData = ModelSendMessageREQ(content: contentData, attachments: attachments)
        
        chatViewModel.chatSendMessages(reqUrl: .sendMessage, reqBody: reqData, roomID: roomID, reqHttpMethod: .POST) { response in
            
            switch response{
            case .success(let resObj) :
                
                DispatchQueue.main.async {
                    self.setMessageData(msgData: resObj.data)
                    self.messageInputBar.inputTextView.text = ""
                    self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                    self.messagesCollectionView.reloadData()
                    
                }

                break
                
                
            case.failure(.message(let msg)) :
                AppHelper.getErrorAlert(msg: msg, vc: self) { actionTitle in}
                break
                
                
            case.failure(.error(let err)) :
                AppHelper.getErrorAlert(msg: err.localizedDescription, vc: self) { actionTitle in}
                break
                
            }
        }
    }
    
    
    func apiChatReciveMessages(roomID:String){
        
        AppHelper.showProgressHUD(vc: self)
        
        chatViewModel.chatReciveMessages(reqUrl: .sendMessage, roomID: roomID, reqHttpMethod: .GET) { response in
         
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :

                DispatchQueue.main.async {
                
//                    let arrMsg = resObj.data
//                    arrMsg.reversed()
                    
                    for item in resObj.data.reversed(){
                        
                        self.setMessageData(msgData: item)
                        
//                        if item.sender?.username == UserInfo.userName{
//                            if let msgContent = item.content, msgContent != "" {
//                                self.messages.append(Message(
//                                    sender: self.currentUser,
//                                    messageId: item.id ?? UUID().uuidString,
//                                    sentDate: Date(),
//                                    kind: .text("\(msgContent)")))
//                            }else{
//                                self.messages.append(Message(
//                                    sender: self.currentUser,
//                                    messageId: item.id ?? UUID().uuidString,
//                                    sentDate: Date(),
//                                    kind: .text("ATTACHMENT..")))
//                            }
//
//                        }else{
//
//                            if let msgContent = item.content, msgContent != "" {
//                                self.messages.append(Message(
//                                    sender: self.otherUser,
//                                    messageId: item.id ?? UUID().uuidString,
//                                    sentDate: Date(),
//                                    kind: .text("\(msgContent)")))
//                            }else{
//                                self.messages.append(Message(
//                                    sender: Sender(senderId: "other", displayName: "\(item.sender?.username ?? "N/A")"),
//                                    messageId: item.id ?? UUID().uuidString,
//                                    sentDate: Date(),
//                                    kind: .text("ATTACHMENT..")))
//                            }
//
//
//                        }
                    }
                    
//                    self.addDummyMessages()
//                    self.messageInputBar.inputTextView.becomeFirstResponder()
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                }
                
                break
                
                
            case.failure(.message(let msg)) :
                AppHelper.getErrorAlert(msg: msg, vc: self) { actionTitle in}
                break
                
                
            case.failure(.error(let err)) :
                AppHelper.getErrorAlert(msg: err.localizedDescription, vc: self) { actionTitle in
                    self.navigationController?.popViewController(animated: true)
                }
                break
                
            }
        }
    }
}
