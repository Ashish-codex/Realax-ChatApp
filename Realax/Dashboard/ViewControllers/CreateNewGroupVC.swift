//
//  CreateNewGroupVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 27/02/24.
//

import UIKit

class CreateNewGroupTableViewCell: UITableViewCell{
    
    
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

class CreateNewGroupVC: UIViewController {

    
    
    @IBOutlet weak var viewGrpName: TextFieldPlainView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewDone: UIView!
    var arrChatData:[ChatCellViewData] = []
    var arrNewChatParticipant:[NewChatData] = []
    var arrSelectedParticipant:[String] = []
    
    
    private var dashboardViewModel = DashboardViewModel()
    
    private let searchBarUser:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        searchBar.searchBarStyle = .prominent
        return searchBar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppHelper.setStatusBarColor(color: .primaryThemeColor)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .primaryThemeColor
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBarUser.delegate = self
        
        navigationController?.navigationBar.topItem?.titleView = searchBarUser
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onClickCancel))
    
        
        viewDone.customRoundedView(radius: viewDone.frame.width / 2)
        viewDone.dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: -6, height: 6), radius: 6, scale: true)
        
    
        viewGrpName.setKeyboardType(type: .default)
        viewGrpName.setPlaceHolder(placeholder: "Enter group name")
        apiGetAllNewChatedList()

    }
    

    
    
    @IBAction func actBtnDone(_ sender: Any) {
        
        if arrSelectedParticipant.isEmpty{
            AppHelper.getErrorAlert(msg: "Please add group members.", vc: self) { _ in}
        }else if viewGrpName.getText().isEmpty{
            AppHelper.getErrorAlert(msg: "Please enter group name.", vc: self) { _ in}
        }
        else{
            apiCreateGroupChat()
        }
    }
    
    
    
    
    @objc func onClickCancel(){
        dismiss(animated: true)
    }
    
    

}



extension CreateNewGroupVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        if searchText.isEmpty{
//           isSearching = false
//        }else{
//            isSearching = true
//            arrSearchingNewChatParticipant = arrNewChatParticipant.filter({ chatData in
//                let isFound = searchText.lowercased() == chatData.username?.prefix(searchText.count) ?? ""
//                return isFound
//            })
//        }
        
        
        
//        tableView.reloadData()
    }
}



//MARK: - Tableview Delegates
extension CreateNewGroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrNewChatParticipant.count
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ID_CreateNewGroupTableViewCell", for: indexPath) as? CreateNewGroupTableViewCell else {
            AppHelper.printf(statement:"Unable to load cell")
            return UITableViewCell()
        }
        
        let cellData = arrNewChatParticipant[indexPath.row]
        cell.setData(data: cellData)
        cell.selectionStyle = .none
        cell.accessoryType = arrSelectedParticipant.contains(where: {$0 == arrNewChatParticipant[indexPath.row].id!}) ? .checkmark : .none
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        
        if arrSelectedParticipant.contains(where: { $0 == arrNewChatParticipant[indexPath.row].id!} ){

            let indx = arrSelectedParticipant.firstIndex(of: arrNewChatParticipant[indexPath.row].id!) ?? 0
            arrSelectedParticipant.remove(at: indx)

        }else{
            arrSelectedParticipant.append(arrNewChatParticipant[indexPath.row].id!)
        }
        
        self.tableView.reloadData()
    
    }
    
}




//MARK: - Api Service
extension CreateNewGroupVC{
    
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
    
    
    func apiCreateGroupChat(){
        
        AppHelper.showProgressHUD(vc: self)
        
        let grpData = ModelCreateGroupREQ(name: viewGrpName.getText(), participants: arrSelectedParticipant)
        
        dashboardViewModel.apiCreateGroupChat(reqUrl: .chatsGroupURL, reqBody: grpData, reqHttpMethod: .POST) { response in
            
            AppHelper.hideProgessHUD(vc: self)
            switch response{
            case .success(let resObj) :

                AppHelper.getErrorAlert(msg: "\(resObj.message)", vc: self) { actionTitle in
                    self.navigationController?.popViewController(animated: true)
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
