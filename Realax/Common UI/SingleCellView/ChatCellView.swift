//
//  ChatCellView.swift
//  Realax
//
//  Created by Ashish Prajapati on 30/12/23.
//

import Foundation
import UIKit

struct ChatCellViewData{
    var profileImg, title, subTitle, lastMsgTime: String
    var isOnline, isTyping: Bool
}



class ChatCellView: UIView{
    
    
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var viewImgContainer: UIView!
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var viewOnlineStatus: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblSubTitle: UILabel!
    @IBOutlet private weak var lblLastMsgTime: UILabel!
    @IBOutlet private weak var lblTyping: UILabel!
    
    var nibView: UIView? = nil
    
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }

    

    func commonInit() {
        
        
        nibView = Bundle.main.loadNibNamed("ChatCellView", owner: self)?.first as? UIView
        nibView?.frame = self.bounds
        
        if nibView != nil{
            addSubview(nibView!)
        }

        viewOnlineStatus.customRoundedView(radius: viewOnlineStatus.frame.height / 2)
        imgView.circularImage(radius: imgView.frame.width / 2)
    }
    
    
    public func setData(cellData:ChatCellViewData){
        imgView.image = UIImage(named: cellData.profileImg)
        lblTitle.text = cellData.title
        lblSubTitle.text = cellData.subTitle
        lblLastMsgTime.text = "3m ago"
        lblTyping.text = cellData.isTyping ? "Typing" : ""
        viewOnlineStatus.backgroundColor = cellData.isOnline ? .userOnline : .userOffline
    }
       
    
}
