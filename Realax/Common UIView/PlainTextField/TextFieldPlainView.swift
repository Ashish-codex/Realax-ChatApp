//
//  TextFieldPlainVC.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import UIKit

class TextFieldPlainView: UIView {

    
    @IBOutlet weak private var containerVeiw: UIView!
    @IBOutlet weak private var txtField: UITextField!
    
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
        
        txtField.delegate = self
        containerVeiw.customRoundedView(radius: 10)
    }
       
    
    
    public func setPlaceHolder(placeholder: String){
        txtField.placeholder = placeholder
    }
    
    public func setKeyboardType(type: UIKeyboardType){
        txtField.returnKeyType = .done
        txtField.keyboardType = type
    }
    
    public func getText() -> String{
        return txtField.text ?? ""
    }

    public func setText(text:String){
        txtField.text = text
    }
}



extension TextFieldPlainView : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
