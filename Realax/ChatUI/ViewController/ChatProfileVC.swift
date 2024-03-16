//
//  ChatProfileVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 10/03/24.
//

import UIKit



class ChatProfileTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var chatCellView: ChatCellView!
    
    func setData(data: Participant, adminID:String){
        
        let userName = data.username ?? "N/A"
        let userID = data.id ?? "N/A"
        let chat = ChatCellViewData(
            profileImg: "",
            title: userName.elementsEqual(UserInfo.userName) ? "You" : userName,
            subTitle: adminID.elementsEqual(userID) ? "Group Admin" : "",
            lastMsgTime: "",
            isOnline: false,
            isTyping: false
        )
        chatCellView.setData(cellData: chat)
    }
}




class ChatProfileVC:UIViewController {
    
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewContainer1: UIView!
    @IBOutlet weak var viewContainer2: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDelete: UILabel!
    
    @IBOutlet weak var constraintStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblGrpMembers: UILabel!
    
    @IBOutlet weak var viewAddMember: UIView!
    @IBOutlet weak var viewExitGroup: UIView!
    @IBOutlet weak var viewDeleteGroup: UIView!
    
    private var chatViewModel = ChatViewModel()

    var chatDataInfo: ChatData!
    var reciverInfo: Participant!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatDataInfo = UserInfo.chatProfileData
        
        AppHelper.setStatusBarColor(color: .primaryThemeColor)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .primaryThemeColor
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false

        tableView.delegate = self
        tableView.dataSource = self
        
        imgProfile.customRoundedView(radius: imgProfile.frame.height / 2 )
        
        viewProfile.customRoundedView(radius: 10)
        viewContainer1.customRoundedView(radius: 10)
        viewContainer2.customRoundedView(radius: 10)
        
        
        if let isGrp = chatDataInfo.isGroupChat, isGrp{

            lblTitle.text = reciverInfo.username ?? "N/A"
            lblSubTitle.text = "Total Members: \(chatDataInfo.participants?.count ?? 0)"

            viewContainer1.isHidden = false
            viewContainer2.isHidden = false

            _ = isCurrentUserGroupAdmin()


        }else{
            lblTitle.text = reciverInfo.fullName ?? "N/A"
            lblSubTitle.text = "@\(reciverInfo.username ?? "" )"

            viewContainer1.isHidden = false
            viewContainer2.isHidden = true
            viewAddMember.isHidden = true
            viewExitGroup.isHidden = true
            viewDeleteGroup.isHidden = false
            lblGrpMembers.isHidden = true
            lblDelete.text = "Delete Chat"
        }
        
    }
    
    
    
    @IBAction func actBtnAddMember(_ sender: Any) {
        guard let composeSearchVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ComposeSearchUserVC") as? ComposeSearchUserVC else {
            AppHelper.printf(statement: "Unable to load ID_ComposeSearchUserVC from ChatHomeVC")
            return
        }
        
        composeSearchVC.parentSelf = self.navigationController
        composeSearchVC.delegate = self
        composeSearchVC.isAddingGrpMember = true
        
        let navController = UINavigationController(rootViewController: composeSearchVC)
        present(navController, animated: true)
    }
    
    
    @IBAction func actBtnExitGroup(_ sender: Any) {
        let msg = "Exit from \(chatDataInfo.name ?? "") group?"
        AppHelper.getAlert(msg: msg, vc: self) { actionTitle in
            self.apiExitGroup(roomID: UserInfo.roomID)
        }
    }
    
    
    @IBAction func actBtnDeleteGroup(_ sender: Any) {
        let msg = "Are you sure, you want to delete \(chatDataInfo.name ?? "") group?"
        AppHelper.getAlert(msg: msg, vc: self) { actionTitle in
            self.apiDeleteGroup(roomID: UserInfo.roomID)
        }
        
    }
    
    
    
    func isCurrentUserGroupAdmin() -> Bool{
        var isGrpAdmin = false
        
        if let isGrp = chatDataInfo.isGroupChat, isGrp{
            if chatDataInfo.admin!.elementsEqual(UserInfo.userID) {
                viewAddMember.isHidden = false
                viewExitGroup.isHidden = false
                viewDeleteGroup.isHidden = false
                lblDelete.text = "Delete Group"
                
                isGrpAdmin = true
            }else{
                viewAddMember.isHidden = true
                viewExitGroup.isHidden = false
                viewDeleteGroup.isHidden = true
                
                isGrpAdmin = false
            }
        }
        
        
        return isGrpAdmin
    }
    
}



//MARK: - CreateGroupDelegate
extension ChatProfileVC: CreateGroupDelegate{
    func onClickDone(selectedUserID: String) {
        apiAddGroupMember(roomID: UserInfo.roomID, userID: selectedUserID)
    }
    
}



//MARK: - UITableViewDelegate
extension ChatProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return chatDataInfo.participants?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let adminID = chatDataInfo.admin ?? ""
        let participantID = chatDataInfo.participants![indexPath.row].id ?? ""
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ID_ChatProfileTableViewCell", for: indexPath) as? ChatProfileTableViewCell else {
            AppHelper.printf(statement:"Unable to load cell")
            return UITableViewCell()
        }
        
        cell.setData(data: chatDataInfo.participants![indexPath.row], adminID: adminID)
        cell.selectionStyle = .none
        
        if isCurrentUserGroupAdmin() && (chatDataInfo.participants![indexPath.row].username != UserInfo.userName) {
            cell.accessoryView = UIImageView(image: UIImage(named: "icon_cancel"))
        }else{
            cell.accessoryView = nil
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if isCurrentUserGroupAdmin() && (chatDataInfo.participants![indexPath.row].username != UserInfo.userName) {
        
            let msg = "Remove @\(chatDataInfo.participants![indexPath.row].username ?? "") from \(chatDataInfo.name ?? "") group?"
            
            AppHelper.getAlert(msg: msg, vc: self) { actionTitle in
                self.apiRemoveGroupMember(roomID: UserInfo.roomID, userID: self.chatDataInfo.participants![indexPath.row].id ?? "")
            }
        }
    }
    
    
}




//MARK: - Api Service
extension ChatProfileVC{
    
    
    func apiAddGroupMember(roomID:String, userID: String){
        
        AppHelper.showProgressHUD(vc: self)
        
        chatViewModel.apiAddGroupMember(reqUrl: .chatsGroupURL, roomID: roomID,  userID: userID, reqHttpMethod: .POST) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :
                
                DispatchQueue.main.async {
                    UserInfo.chatProfileData = ChatData(
                        id: resObj.data.id,
                        name: resObj.data.name,
                        isGroupChat: resObj.data.isGroupChat,
                        participants: resObj.data.participants,
                        admin: resObj.data.admin,
                        createdAt: resObj.data.createdAt,
                        updatedAt: resObj.data.updatedAt,
                        v: resObj.data.v)
                    
                    self.chatDataInfo = UserInfo.chatProfileData
                    
                    _ = self.chatDataInfo.participants?.filter({ participant in
                        if participant.id! == userID{
                            AppHelper.getAlert(msg: "@\(participant.username ?? "") has been added to \(self.chatDataInfo.name ?? "") group", vc: self) { actionTitle in
                                self.tableView.reloadData()
                            }
                        }
                        return true
                    })
                    
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
    
    func apiRemoveGroupMember(roomID:String, userID: String){
        
        AppHelper.showProgressHUD(vc: self)
        
        chatViewModel.apiAddGroupMember(reqUrl: .chatsGroupURL, roomID: roomID,  userID: userID, reqHttpMethod: .DELETE) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :
                
                DispatchQueue.main.async {
                    UserInfo.chatProfileData = ChatData(
                        id: resObj.data.id,
                        name: resObj.data.name,
                        isGroupChat: resObj.data.isGroupChat,
                        participants: resObj.data.participants,
                        admin: resObj.data.admin,
                        createdAt: resObj.data.createdAt,
                        updatedAt: resObj.data.updatedAt,
                        v: resObj.data.v)
                    
                    self.chatDataInfo = UserInfo.chatProfileData
                    
                    self.tableView.reloadData()
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
    
    func apiExitGroup(roomID:String){
        
        AppHelper.showProgressHUD(vc: self)
        
        chatViewModel.apiExitGroup(reqUrl: .leaveGroup, roomID: roomID, reqHttpMethod: .DELETE) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :
                
                DispatchQueue.main.async {
                    guard let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatHomeVC") as? ChatHomeVC else {
                        AppHelper.printf(statement:"Unable to load DashboardVC")
                        return
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
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
    
    func apiDeleteGroup(roomID:String){
        
        AppHelper.showProgressHUD(vc: self)
        
        let deleteURLType:ApiRoute = lblDelete.text!.elementsEqual("Delete Chat") ? .deleteOneToOneChat : .chatsGroupURL
        
        chatViewModel.apiDeleteGroup(reqUrl: deleteURLType, roomID: roomID, reqHttpMethod: .DELETE) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :
                DispatchQueue.main.async {
                    guard let vc = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatHomeVC") as? ChatHomeVC else {
                        AppHelper.printf(statement:"Unable to load DashboardVC")
                        return
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
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
}
