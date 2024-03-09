//
//  ComposeUserVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 02/02/24.
//

import UIKit


class ComposeSearchTableViewCell: UITableViewCell{
    
    @IBOutlet weak var chatCellView: ChatCellView!
    
    func setData(data: NewChatData){
        let chat = ChatCellViewData(
            profileImg: "",
            title: data.username ?? "",
            subTitle: "",
            lastMsgTime: "",
            isOnline: false,
            isTyping: false
        )
        chatCellView.setData(cellData: chat)
    }
}


class ComposeSearchUserVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var parentSelf: UINavigationController?
    var arrChatData:[ChatCellViewData] = []
    var arrNewChatParticipant:[NewChatData] = []
    var arrSearchingNewChatParticipant:[NewChatData] = []
    var isSearching = false
    private var dashboardViewModel = DashboardViewModel()
    
    @IBOutlet weak var imgNewGrp: UIImageView!
    
    private let searchBarUser:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        searchBar.searchBarStyle = .prominent
        return searchBar
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarUser.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imgNewGrp.setImageColor(color: .primaryThemeColor)
        navigationController?.navigationBar.topItem?.titleView = searchBarUser
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onClickCancel))
    
        apiGetAllNewChatedList()
    }
    

    override func viewDidAppear(_ animated: Bool) {
//        AppHelper.showProgressHUD(vc: self)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            AppHelper.hideProgessHUD(vc: self)
//            self.addDumyData()
//            self.searchBarUser.becomeFirstResponder()
//            self.tableView.reloadData()
//        }
    }
    
    
    
    
    @IBAction func actBtnNewGroup(_ sender: Any) {
        
        guard let creatGrpVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_CreateNewGroupVC") as? CreateNewGroupVC else {
            AppHelper.printf(statement:"Unable to load SettingVC")
            return
        }
        
        dismiss(animated: true) {
            self.parentSelf?.pushViewController(creatGrpVC, animated: true)
        }
        
    }
    
    
    
    
    @objc func onClickCancel(){
        dismiss(animated: true)
    }

    
    func addDumyData(){
        
        for _ in 0...20{
            arrChatData.append(ChatCellViewData(profileImg: "profile_img1", title: "Dainna Smlley", subTitle: "Introducing your schedule today.", lastMsgTime: "3m ago", isOnline: true, isTyping: true))
            
        }
        
  
        
    }
    
}




extension ComposeSearchUserVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
           isSearching = false
        }else{
            isSearching = true
            arrSearchingNewChatParticipant = arrNewChatParticipant.filter({ chatData in
                let isFound = searchText.lowercased() == chatData.username?.prefix(searchText.count) ?? ""
                return isFound
            })
        }
        
        
        
        tableView.reloadData()
    }
}



//MARK: - Tableview Delegates
extension ComposeSearchUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return arrSearchingNewChatParticipant.count
        }else{
            return arrNewChatParticipant.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ID_ComposeSearchTableViewCell", for: indexPath) as? ComposeSearchTableViewCell else {
            AppHelper.printf(statement:"Unable to load cell")
            return UITableViewCell()
        }
        
        let cellData = isSearching ? arrSearchingNewChatParticipant[indexPath.row] : arrNewChatParticipant[indexPath.row]
        cell.setData(data: cellData)
        cell.selectionStyle = .none
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let chatUiVC = UIStoryboard(name: "ChatUI", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatUIVC") as? ChatUIVC else {
            AppHelper.printf(statement:"Unable to load SettingVC")
            return
        }
        
        let cellData = isSearching ? arrSearchingNewChatParticipant[indexPath.row] : arrNewChatParticipant[indexPath.row]
        
        
        apiCreateOneToOneChat(reciverId: cellData.id ?? "")
        
        dismiss(animated: true) {
            
//            AppHelper.printf(statement:"Slect at : \(indexPath.row)")
            self.parentSelf?.pushViewController(chatUiVC, animated: true)
            chatUiVC.atIndex = indexPath.row
            chatUiVC.reciverInfo = Participant(
                id: "",
                username: cellData.username ?? "",
                email: cellData.email ?? "",
                role: "",
                fullName: cellData.username ?? "",
                avatar: nil,
                createdAt: "",
                updatedAt: "",
                v: 0)
            
        }
    
    }
    
}



//MARK: - Api Service
extension ComposeSearchUserVC{
    
    func apiGetAllNewChatedList(){
        
        AppHelper.showProgressHUD(vc: self)
        
        dashboardViewModel.apiGetAllNewChats(reqUrl: .searchVariableUser, reqHttpMethod: .GET) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :
                DispatchQueue.main.async {
                    
                    self.arrNewChatParticipant.removeAll()
                    for chatData in resObj.data{
                        self.arrNewChatParticipant.append(chatData)
                    }
                    
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
    
    
    func apiCreateOneToOneChat(reciverId: String){
        
//        AppHelper.showProgressHUD(vc: self)
        
        
        dashboardViewModel.apiCreateOneToOneChat(reqUrl: .createOneToOneChat, reqHttpMethod: .POST, reciverID: reciverId) { response in
            
//            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :
                UserInfo.roomID = resObj.data.id ?? ""
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
