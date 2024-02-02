//
//  CallListVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 31/12/23.
//

import UIKit

class CallListTableViewCell: UITableViewCell{
    
    @IBOutlet weak var callCellView: CallCellView!
    
    func setData(cellData: CallCellViewData){
        callCellView.setData(cellData: cellData)
    }
    
}


class CallListVC: UIViewController{

    @IBOutlet weak var tableViewCallList: UITableView!
    var arrCallListData: [CallCellViewData] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewCallList.delegate = self
        tableViewCallList.dataSource = self
        
        addDumyData()
    }

    
    
    func addDumyData(){
        
        for i in 0...20{
            arrCallListData.append(CallCellViewData(atIndex: i, profileImg: "profile_img1", title: "Dainna Smlley", subTitle: "You missed 3 miss calls", isOnline: true, isMissedCall: true))
        }
    }

}






extension CallListVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrCallListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ID_CallListTableViewCell", for: indexPath) as? CallListTableViewCell else {
            AppHelper.printf(statement:"Unable to load CallListTableViewCell")
            return UITableViewCell()
        }
        
        cell.setData(cellData: arrCallListData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
}
