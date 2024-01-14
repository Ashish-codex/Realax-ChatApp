//
//  TextFieldWithIconView.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import Foundation
import UIKit


class TextFieldWithIconView: UIView {
    
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var txtField: UITextField!
    @IBOutlet private weak var imgFieldIcon: UIImageView!
    
    
    var nibView: UIView? = nil
    
    
    
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }

    

    func commonInit() {
        
        nibView = Bundle.main.loadNibNamed("TextFieldWithIconView", owner: self)?.first as? UIView
        nibView?.frame = self.bounds
        
        if nibView != nil{
            addSubview(nibView!)
        }
        
        
        containerView.customRoundedView(radius: 10)
    }
       
    
    
    @IBAction func actBtnFieldIcon(_ sender: Any) {
    }
    
    
    
    
    public func setPlaceHolder(placeholder: String){
        txtField.placeholder = placeholder
    }
    
    public func setImageFieldIcon(icon: UIImage){
        imgFieldIcon.image = icon
    }
    
}
