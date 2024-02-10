//
//  ChatHomeVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 27/12/23.
//

import UIKit
import LZViewPager

class ChatHomeVC: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource, UISearchBarDelegate {
   

    
    
    @IBOutlet weak var viewPager: LZViewPager!
    
    @IBOutlet weak var viewEdit: UIView!
    
    
    private var arrUIViewController:[UIViewController] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        viewEdit.customRoundedView(radius: viewEdit.frame.height/2)
        viewEdit.dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: -6, height: 6), radius: 6, scale: true)
        
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
        guard let tempVC1 = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ChatListVC") as? ChatListVC else {
            AppHelper.printf(statement:"Unable to load ChatListVC")
            return
        }
        
        
        guard let tempVC2 = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_CallListVC") as? CallListVC else {
            AppHelper.printf(statement:"Unable to load CallListVC")
            return
        }
        
        tempVC1.title = "Chats"
        tempVC2.title = "Calls"
        arrUIViewController = [tempVC1, tempVC2]
        viewPager.reload()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SocketHelper.shared.connectSocket()
    }
    
    
    
    
   
    @IBAction func actBtnSearch(_ sender: Any) {
        
        // Create the search controller and specify that it should present its results in this same view
        var searchController = UISearchController(searchResultsController: nil)

        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        

        // Make this class the delegate and present the search
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func actBtnEditChat(_ sender: Any) {
        
        guard let composeSearchVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_ComposeSearchUserVC") as? ComposeSearchUserVC else {
            AppHelper.printf(statement: "Unable to load ID_ComposeSearchUserVC from ChatHomeVC")
            return
        }
        
        composeSearchVC.nv = self.navigationController
        
        let navController = UINavigationController(rootViewController: composeSearchVC)
        present(navController, animated: true)
    }
    
    
    @IBAction func actBtnSetting(_ sender: Any) {
        
        guard let settingVC = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "ID_SettingVC") as? SettingVC else {
            AppHelper.printf(statement:"Unable to load SettingVC")
            return
        }
        
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    
    
    
    
    
    
    func colorForIndicator(at index: Int) -> UIColor {
        return .white
    }
    
    func backgroundColorForHeader() -> UIColor {
        return .primaryThemeColor
    }
    
    func withRoundedHeader() -> Bool {
        return true
    }
    
    func widthForIndicator(at index: Int) -> CGFloat {
        return (view.frame.width / CGFloat(arrUIViewController.count)) - 35
    }
    
    func heightForIndicator() -> CGFloat {
        return 6
    }
    
    
    
    func numberOfItems() -> Int {
        return arrUIViewController.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return arrUIViewController[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        button.setTitleColor(UIColor.white, for: .selected)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        return button
    }
    
    

}
