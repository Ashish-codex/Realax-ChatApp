//
//  TextFieldPlainVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import UIKit

class TextFieldPlainView: UIView {

    
    @IBOutlet weak var containerVeiw: UIView!
    @IBOutlet weak var txtField: UITextField!
    
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
        
        nibView = Bundle.main.loadNibNamed("TextFieldPlainView", owner: self)?.first as? UIView
        nibView?.frame = self.bounds
        
        if nibView != nil{
            addSubview(nibView!)
        }
        
        
        containerVeiw.customRoundedView(radius: 10)
    }
       
    
    
    public func setPlaceHolder(placeholder: String){
        txtField.placeholder = placeholder
    }

}
