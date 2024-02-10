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
            title: data.username,
            subTitle: "",
            lastMsgTime: "",
            isOnline: false,
            isTyping: false
        )
        chatCellView.setData(cellData: chat)
    }
    
}


class ChatListVC: UIViewController{
    
    @IBOutlet weak var tableViewChatList: UITableView!
    var arrChatData:[ChatCellViewData] = []
    var arrChatParticipant:[Participant] = []
    var refreshController = UIRefreshControl()
    
    private var dashboardViewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewChatList.delegate = self
        tableViewChatList.dataSource = self
        
        refreshController.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableViewChatList.addSubview(refreshController)
        
        apiGetAllChatedList()
//        addDumyData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        apiGetAllChatedList()
    }
    
    
    @objc func didPullToRefresh(){
        apiGetAllChatedList()
        refreshController.endRefreshing()
    }
    
    func addDumyData(){
        
        for _ in 0...20{
            arrChatData.append(ChatCellViewData(profileImg: "profile_img1", title: "Dainna Smlley", subTitle: "Introducing your schedule today.", lastMsgTime: "3m ago", isOnline: true, isTyping: true))
            
        }
        
  
        
    }

}




extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.selectionStyle = .none
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let chatUiVC = UIStoryboard(name: "ChatUI", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatUIVC") as? ChatUIVC else {
            AppHelper.printf(statement:"Unable to load SettingVC")
            return
        }
        navigationController?.pushViewController(chatUiVC, animated: true)
        chatUiVC.atIndex = indexPath.row
        chatUiVC.reciverInfo = arrChatParticipant[indexPath.row]
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
                    for chatData in resObj.data[0].participants{
                        self.arrChatParticipant.append(chatData)
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
