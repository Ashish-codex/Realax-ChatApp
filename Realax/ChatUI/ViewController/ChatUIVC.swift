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
import UniformTypeIdentifiers

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
    private var iMessageInputBar: iMessageInputBarAccessoryView!
    
    
    
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
        messagesCollectionView.messageCellDelegate = self
//        messageInputBar.delegate = self
//        messageInputBar.becomeFirstResponder()
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        showMessageTimestampOnSwipeLeft = true
        
        
        iMessageInputBar = iMessageInputBarAccessoryView()
        iMessageInputBar.delegate = self
        iMessageInputBar.iMessageDelegate = self
        iMessageInputBar.becomeFirstResponder()
        messageInputBar = iMessageInputBar
        

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
            DispatchQueue.main.async {
                self.chatNavBarView.isTyping(typing: false)
            }
        }
        
        
        SocketHelper.shared.socketOn(event: .messageReceived) { data in
            if let msg = data.first as? [String:Any] {

                do {
                    let msgData = try JSONSerialization.data(withJSONObject: msg, options: [.withoutEscapingSlashes, .prettyPrinted])
                
                    let getMessage = try JSONDecoder().decode(DataGellAllMessages.self, from: msgData )
                    
                    self.setMessageData(msgData: getMessage)
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                    
                } catch let err {
                    AppHelper.printf(statement: "messageReceived Event Error: \(err.localizedDescription)")
                }
                
            }
        }
        
    }
    
    func setReciverInfo(data: Participant) -> ChatCellViewData{
        let chat = ChatCellViewData(
            profileImg: "",
            title: data.username ?? "N/A",
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
            
        }
        
        // Attachment msg for text
        if let arrAttachments = msgData.attachments, !arrAttachments.isEmpty{
            for itemAttachted in arrAttachments{
                
                if itemAttachted.url!.contains(".pdf"){
                    
                    self.messages.append(Message(
                        sender: senderType,
                        messageId: msgData.id ?? UUID().uuidString,
                        sentDate: Date(),
                        kind: .linkPreview(
                            MediaLinkItem(
                                text: "",
                                attributedText: nil,
                                url: URL(string: itemAttachted.url!)!,
                                title: itemAttachted.id ?? "N/A",
                                teaser: "",
                                thumbnailImage: UIImage(named: "icon_file_placeholder")!
                            )
                        )
                    ))
                    
                }else if ( itemAttachted.url!.contains(".jpg") || itemAttachted.url!.contains(".png") ){
                    
                    self.messages.append(Message(
                        sender: senderType,
                        messageId: msgData.id ?? UUID().uuidString,
                        sentDate: Date(),
                        kind: .photo(MediaImageItem(imageURL: URL(string:"\(itemAttachted.url ?? "" )")! ) ) ))
                }
                
            }
        }
                
    }
    
    

}



// MARK: - MessageCellDelegate
extension ChatUIVC: MessageCellDelegate{
    
    func didSelectURL(_ url: URL) {
        UIApplication.shared.open(url)
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
    
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: (message.sender.displayName == UserInfo.userName) ? "@You" : "@\(message.sender.displayName)",
            attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20.0
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
        
        return 10
        
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    

    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: messagesCollectionView.bounds.width, height: 4)
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



// MARK: - iMessageButtonActionDelegate
extension ChatUIVC: iMessageButtonActionDelegate, UIDocumentPickerDelegate{
    func onClickAttachment() {
        
        let documentTypes = [UTType.image, UTType.pdf, UTType.text]
        let documentPickerVC = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
        documentPickerVC.modalPresentationStyle = .formSheet
        documentPickerVC.delegate = self
        present(documentPickerVC, animated: true)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if let fileUri = urls.first, fileUri.startAccessingSecurityScopedResource(){
            do {
                if #available(iOS 16.0, *) {
                    let fileData = try Data(contentsOf: fileUri)
                    AppHelper.printf(statement: "\(fileUri.absoluteString)")
                    AppHelper.showProgressHUD(vc: self)
                    apiChatSendMessages(roomID: UserInfo.roomID, attachments: fileData)
                } else {
                    // Fallback on earlier versions
                }
            } catch let err {
                AppHelper.printf(statement: "Docment selecting data error: \(err.localizedDescription)")
                AppHelper.getErrorAlert(msg: err.localizedDescription, vc: self) { _ in}
            }
        }
        
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    
}


//MARK: - Api Service
extension ChatUIVC{
    
    func apiChatSendMessages(roomID:String, contentData: String? = nil, attachments:Data? = nil ){
        let reqData = ModelSendMessageREQ(content: contentData, attachments: attachments)
        
        chatViewModel.chatSendMessages(reqUrl: .sendMessage, reqBody: reqData, roomID: roomID, reqHttpMethod: .POST) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :
                
                DispatchQueue.main.async {
                    self.setMessageData(msgData: resObj.data)
                    self.messageInputBar.inputTextView.text = ""
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                    
                    
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
                
                    for item in resObj.data.reversed(){
                        self.setMessageData(msgData: item)
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
