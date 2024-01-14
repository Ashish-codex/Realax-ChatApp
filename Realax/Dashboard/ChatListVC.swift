//
//  Temp1VC.swift
//  Realax
//
//  Created by Ashish Prajapati on 29/12/23.
//

import UIKit

class ChatListTableViewCell: UITableViewCell{
    
    @IBOutlet weak var chatCellView: ChatCellView!
    
    func setData(data: ChatCellViewData){
        chatCellView.setData(cellData: data)
    }
    
}


class ChatListVC: UIViewController{
    
    @IBOutlet weak var tableViewChatList: UITableView!
    var arrChatData:[ChatCellViewData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewChatList.delegate = self
        tableViewChatList.dataSource = self
        
        addDumyData()
    }
    
    
    func addDumyData(){
        
        for _ in 0...20{
            arrChatData.append(ChatCellViewData(profileImg: "profile_img1", title: "Dainna Smlley", subTitle: "Introducing your schedule today.", lastMsgTime: "3m ago", isOnline: true, isTyping: true))
            
        }
        
  
        
    }

}




extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrChatData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ID_ChatListTableViewCell", for: indexPath) as? ChatListTableViewCell else {
            print("Unable to load cell")
            return UITableViewCell()
        }
        
        cell.setData(data: arrChatData[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Slect at : \(indexPath.row)")
        print("\(navigationController?.navigationBar.frame)")
        
        guard let chatUiVC = UIStoryboard(name: "ChatUI", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatUIVC") as? ChatUIVC else {
            print("Unable to load SettingVC")
            return
        }
        navigationController?.pushViewController(chatUiVC, animated: true)
        chatUiVC.atIndex = indexPath.row
    }
    
}
