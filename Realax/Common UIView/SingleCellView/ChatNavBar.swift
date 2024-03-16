//
//  ChatNavBar.swift
//  Realax
//
//  Created by Ashish Prajapati on 07/01/24.
//

import Foundation
import UIKit


protocol ChatNavBarDelegate{
    func onClickProfile()
    func onClickVideoCall()
    func onClickVoiceCall()
}


class ChatNavBar: UIView{
    

    @IBOutlet weak var viewProfileImage: UIView!
    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblIsOnline: UILabel!
    @IBOutlet weak var iconVideoCall: UIImageView!
    @IBOutlet weak var iconCall: UIImageView!
    
    var delegate: ChatNavBarDelegate?
    
    
    
    var nibView: UIView? = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    func commonInit(){
        nibView = Bundle.main.loadNibNamed("ChatNavBar", owner: self)?.first as? UIView
        nibView?.frame = self.bounds
        
        if nibView != nil{
            addSubview(nibView!)
        }
        
        iconCall.setImageColor(color: .white)
        iconVideoCall.setImageColor(color: .white)
        imgProfileImage.circularImage(radius: imgProfileImage.frame.width / 2)
    }
    
    
    
    @IBAction func actBtnVideoCall(_ sender: Any) {
        delegate?.onClickVideoCall()
    }
    
    
    
    @IBAction func actBtnNormalCall(_ sender: Any) {
        delegate?.onClickVoiceCall()
    }
    
    
    
    @IBAction func actBtnProfile(_ sender: Any) {
        delegate?.onClickProfile()
    }
    
    
    
    
    
//    public func setData1(cellData:ChatCellViewData){
//        imgProfileImage.image = UIImage(named: cellData.profileImg)
//        lblTitle.text = cellData.title
//        lblIsOnline.text = (cellData.isTyping ? "Typing" :
//                                (cellData.isOnline ? "Online" : ""))
//        
//    }
    
    public func isTyping(typing: Bool){
        lblIsOnline.text = typing ? "Typing.." : "Online"
    }
    
    
    public func setData(cellData:ChatCellViewData){
        imgProfileImage.image = cellData.profileImg == "" ? UIImage(named: "icon_profile_placeholder") : UIImage(named: cellData.profileImg)
        lblTitle.text = cellData.title
        lblIsOnline.text = (cellData.isTyping ? "Typing" :
                                (cellData.isOnline ? "Online" : ""))
        
    }
    
}
