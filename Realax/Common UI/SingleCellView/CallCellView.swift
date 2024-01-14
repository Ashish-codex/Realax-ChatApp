//
//  CallCellView.swift
//  Realax
//
//  Created by Ashish Prajapati on 31/12/23.
//

import Foundation
import UIKit


struct CallCellViewData{
    var atIndex:Int
    var profileImg, title, subTitle: String
    var isOnline, isMissedCall: Bool
}




class CallCellView: UIView{
    
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewOnlineStatus: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgCallStatus: UIImageView!
    var atIndex:Int = 0
    var nibView: UIView? = nil
    
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }

    
    @IBAction func actBtnVideoCall(_ sender: Any) {
        print("Index \(atIndex) is video calling ...")
    }
    
    
    @IBAction func actBtnNormalCall(_ sender: Any) {
        print("Index \(atIndex) is calling ...")
    }
    
    
    

    func commonInit() {
        nibView = Bundle.main.loadNibNamed("CallCellView", owner: self)?.first as? UIView
        nibView?.frame = self.bounds
        
        if nibView != nil{
            addSubview(nibView!)
        }

        viewOnlineStatus.customRoundedView(radius: viewOnlineStatus.frame.height / 2)
        imgProfile.circularImage(radius: imgProfile.frame.width / 2)
    }
    
    
    
    func setData(cellData:CallCellViewData){
        
        atIndex = cellData.atIndex
        imgProfile.image = UIImage(named: cellData.profileImg)
        viewOnlineStatus.backgroundColor = cellData.isOnline ? .userOnline : .userOffline
        lblTitle.text = cellData.title
        lblSubTitle.text = cellData.subTitle
        imgCallStatus.image = cellData.isMissedCall ? UIImage(named: "icon_phone_missed") :UIImage(named: "icon_phone_forwarded")
    }
    
    
    
    
    
    
}
