//
//  Temp1VC.swift
//  Realax
//
//  Created by Ashish Prajapati on 29/12/23.
//

import UIKit

class ChatListTableViewCell: UITableViewCell{
    
    @IBOutlet weak var chatCellView: ChatCellView!
    
    func setData(data: Participant){
        let chat = ChatCellViewData(
            profileImg: "",
            title: data.username ?? "N/A",
            subTitle: "",
            lastMsgTime: "",
            isOnline: false,
            isTyping: false
        )
        chatCellView.setData(cellData: chat)
    }
    
//    func setData(cellData: ChatCellViewData){
//        chatCellView.setData1(cellData: cellData)
//    }
    
}


class ChatListVC: UIViewController{
    
    @IBOutlet weak var tableViewChatList: UITableView!
    var arrChatCellData:[ChatCellViewData] = []
    var arrChatParticipant:[Participant] = []
    var arrChatData:[ChatData] = []
    var refreshController = UIRefreshControl()
    
    private var dashboardViewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewChatList.delegate = self
        tableViewChatList.dataSource = self
        
        refreshController.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableViewChatList.addSubview(refreshController)
        
//        apiGetAllChatedList()
//        addDumyData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        apiGetAllChatedList()
    }
    
    
    @objc func didPullToRefresh(){
        apiGetAllChatedList()
        refreshController.endRefreshing()
    }
    
    func addDumyData(){
        
        for _ in 0...20{
            arrChatCellData.append(ChatCellViewData(profileImg: "profile_img1", title: "Dainna Smlley", subTitle: "Introducing your schedule today.", lastMsgTime: "3m ago", isOnline: true, isTyping: true))
            
        }
        
  
        
    }

}




extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        arrChatCellData.count
        arrChatParticipant.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ID_ChatListTableViewCell", for: indexPath) as? ChatListTableViewCell else {
            AppHelper.printf(statement:"Unable to load cell")
            return UITableViewCell()
        }
        
        cell.setData(data: arrChatParticipant[indexPath.row])
//        cell.setData(cellData: arrChatCellData[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatData = arrChatData[indexPath.row]
        UserInfo.chatProfileData = ChatData(id: chatData.id, name: chatData.name, isGroupChat: chatData.isGroupChat, participants: chatData.participants, admin: chatData.admin, createdAt: chatData.createdAt, updatedAt: chatData.updatedAt, v: chatData.v)
        
        
        guard let chatUiVC = UIStoryboard(name: "ChatUI", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatUIVC") as? ChatUIVC else {
            AppHelper.printf(statement:"Unable to load SettingVC")
            return
        }
        navigationController?.pushViewController(chatUiVC, animated: true)
        chatUiVC.atIndex = indexPath.row
//        chatUiVC.chatDataInfo = arrChatData[indexPath.row]
        chatUiVC.reciverInfo = arrChatParticipant[indexPath.row]
        UserInfo.roomID = arrChatData[indexPath.row].id ?? ""
    }
    
}




//MARK: - Api Service
extension ChatListVC{
    
    func apiGetAllChatedList(){
        
        AppHelper.showProgressHUD(vc: self)
        
        dashboardViewModel.apiGetAllChated(reqUrl: .getAllChats, reqHttpMethod: .GET) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :
                DispatchQueue.main.async {
                    
                    self.arrChatParticipant.removeAll()
                    self.arrChatData.removeAll()
                    for item in resObj.data{
                        self.arrChatData.append(item)
                        
                        if let isGrp = item.isGroupChat, isGrp{
                            self.arrChatParticipant.append(
                                Participant(id: "", username: "\(item.name ?? "")", email: "", role: "", fullName: "", avatar: nil, createdAt: "", updatedAt: "", v: 0))
                        }else{
                            if let participants = item.participants{
                                for participant in participants {
                                    if participant.username != UserInfo.userName{
                                        self.arrChatParticipant.append(participant)
                                    }
                                }
                            }
                        }

                    }
                    
                    self.tableViewChatList.reloadData()
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
