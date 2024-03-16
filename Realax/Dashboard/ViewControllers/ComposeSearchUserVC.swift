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



protocol CreateGroupDelegate{
    func onClickDone(selectedUserID: String)
}



class ComposeSearchUserVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewGrpName: TextFieldWithIconView!
    @IBOutlet weak var viewCreateNewGrp: UIView!
    @IBOutlet weak var viewDone: UIView!
    @IBOutlet weak var imgNewGrp: UIImageView!
    
    var parentSelf: UINavigationController?
    var arrChatData:[ChatCellViewData] = []
    var arrNewChatParticipant:[NewChatData] = []
    var arrSearchingNewChatParticipant:[NewChatData] = []
    private var arrParticipants:[NewChatData] = []
    private var arrSelectedParticipant:[String] = []
    private var isSearching = false
    private var isCreatingGrp = false
    var isAddingGrpMember = false
    var delegate: CreateGroupDelegate?
    private var dashboardViewModel = DashboardViewModel()
    
    private let searchBarUser:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        searchBar.searchBarStyle = .prominent
        searchBar.searchTextField.returnKeyType = .done
        return searchBar
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarUser.delegate = self
        searchBarUser.searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        viewGrpName.delegate = self
        
        setupUI()
        apiGetAllNewChatedList()
    }
        
    
    
    
    @IBAction func actBtnNewGroup(_ sender: Any) {
        
        isGroupCreation(isCreating: true)
        
//        guard let creatGrpVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_CreateNewGroupVC") as? CreateNewGroupVC else {
//            AppHelper.printf(statement:"Unable to load SettingVC")
//            return
//        }
//
//        dismiss(animated: true) {
//            self.parentSelf?.pushViewController(creatGrpVC, animated: true)
//        }
        
    }
    
    
    @IBAction func actBtnDone(_ sender: Any) {
        
        if isAddingGrpMember{
            delegate?.onClickDone(selectedUserID: arrSelectedParticipant.first ?? "")
            onClickCancel()
        }else{
            
            if arrSelectedParticipant.isEmpty{
                AppHelper.getErrorAlert(msg: "Please add group members.", vc: self) { _ in}
            }else if viewGrpName.getText().isEmpty{
                AppHelper.getErrorAlert(msg: "Please enter group name.", vc: self) { _ in}
            }
            else{
                apiCreateGroupChat()
            }
        }
        
    }
    
    
    
    @objc func onClickCancel(){
        dismiss(animated: true)
    }

    
    func setupUI(){
        imgNewGrp.setImageColor(color: .primaryThemeColor)
        navigationController?.navigationBar.topItem?.titleView = searchBarUser
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onClickCancel))
        
        
        viewDone.customRoundedView(radius: viewDone.frame.width / 2)
        viewDone.dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: -6, height: 6), radius: 6, scale: true)
        
        viewGrpName.setKeyboardType(type: .default)
        viewGrpName.setPlaceHolder(placeholder: "Enter group name")
        viewGrpName.setImageFieldIcon(icon: UIImage(named: "icon_cancel")!)
        viewGrpName.isSecureTextField(isSecure: false)
        
        isGroupCreation(isCreating: false)
    }
    
    
    
    func isGroupCreation(isCreating:Bool){
        isCreatingGrp = isCreating
        if isCreating || isAddingGrpMember{
            UIView.animate(withDuration: 0.4, delay: 0.0,options: .allowAnimatedContent) { [self] in
                
                self.viewGrpName.isHidden = isAddingGrpMember ? true : false
                self.viewDone.isHidden = false
                self.viewCreateNewGrp.isHidden = true
            }
        }else{
            UIView.animate(withDuration: 0.4, delay: 0.0,options: .allowAnimatedContent) { [self] in
                
                self.viewGrpName.isHidden = true
                self.viewDone.isHidden = true
                self.viewCreateNewGrp.isHidden = false
            }
        }
    }
    
    
    func addDumyData(){
        
        for _ in 0...20{
            arrChatData.append(ChatCellViewData(profileImg: "profile_img1", title: "Dainna Smlley", subTitle: "Introducing your schedule today.", lastMsgTime: "3m ago", isOnline: true, isTyping: true))
            
        }
        
  
        
    }
    
}


//MARK: - TextFieldWithIconViewDelegate
extension ComposeSearchUserVC: TextFieldWithIconViewDelegate{
    func onClickTextFieldIcon() {
    
        if !isAddingGrpMember{
            isGroupCreation(isCreating: false)
            arrSelectedParticipant.removeAll()
            tableView.reloadData()
        }
        
    }
}



//MARK: - UISearchBar Delegate
extension ComposeSearchUserVC: UISearchBarDelegate, UITextFieldDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
           isSearching = false
           arrParticipants = arrNewChatParticipant
        }else{
            isSearching = true
            arrParticipants = arrNewChatParticipant.filter({ chatData in
                let isFound = searchText.lowercased() == chatData.username?.prefix(searchText.count) ?? ""
                return isFound
            })
            
//            arrParticipants = arrSearchingNewChatParticipant
        }
        
        
        
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



//MARK: - Tableview Delegates
extension ComposeSearchUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isSearching{
//            return arrSearchingNewChatParticipant.count
//        }else{
//            return arrNewChatParticipant.count
//        }
        return arrParticipants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ID_ComposeSearchTableViewCell", for: indexPath) as? ComposeSearchTableViewCell else {
            AppHelper.printf(statement:"Unable to load cell")
            return UITableViewCell()
        }
        
        let cellData = arrParticipants[indexPath.row]
        
//        isSearching ? arrSearchingNewChatParticipant[indexPath.row] : arrNewChatParticipant[indexPath.row]
        
        
        cell.setData(data: cellData)
        cell.selectionStyle = .none
        cell.accessoryType = arrSelectedParticipant.contains(where: {$0 == arrParticipants[indexPath.row].id!}) ? .checkmark : .none
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// Selecting Users
        if isCreatingGrp || isAddingGrpMember{
            
            
            /// For removing element from array
            if arrSelectedParticipant.contains(where: { $0 == arrParticipants[indexPath.row].id!} ){
                let indx = arrSelectedParticipant.firstIndex(of: arrParticipants[indexPath.row].id!) ?? 0
                arrSelectedParticipant.remove(at: indx)

            }else{ /// For adding element to array
                
                if isAddingGrpMember {
                    if arrSelectedParticipant.count < 1{
                        arrSelectedParticipant.append(arrParticipants[indexPath.row].id!)
                    }
                    
                }else{
                    arrSelectedParticipant.append(arrParticipants[indexPath.row].id!)
                }
                
                
            }
            
            self.tableView.reloadData()
            
            
        }else{  /// Go to User Chat
            
         
            
            guard let chatUiVC = UIStoryboard(name: "ChatUI", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatUIVC") as? ChatUIVC else {
                AppHelper.printf(statement:"Unable to load SettingVC")
                return
            }
            
            let cellData = arrParticipants[indexPath.row]
            
//            isSearching ? arrSearchingNewChatParticipant[indexPath.row] : arrNewChatParticipant[indexPath.row]
            
            
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
                    self.arrParticipants = self.arrNewChatParticipant
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
    
    
    
    
    func apiCreateGroupChat(){
        
        AppHelper.showProgressHUD(vc: self)
        
        let grpData = ModelCreateGroupREQ(name: viewGrpName.getText(), participants: arrSelectedParticipant)
        
        dashboardViewModel.apiCreateGroupChat(reqUrl: .chatsGroupURL, reqBody: grpData, reqHttpMethod: .POST) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :

                AppHelper.getErrorAlert(msg: "\(resObj.message)", vc: self) { actionTitle in
                    self.onClickCancel()
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
