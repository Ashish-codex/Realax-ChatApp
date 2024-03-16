//
//  TextFieldWithIconView.swift
//  Realax
//
//  Created by Ashish Prajapati on 25/12/23.
//

import Foundation
import UIKit


protocol TextFieldWithIconViewDelegate{
    func onClickTextFieldIcon()
}

class TextFieldWithIconView: UIView {
    
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var txtField: UITextField!
    @IBOutlet private weak var imgFieldIcon: UIImageView!
    
    var delegate:TextFieldWithIconViewDelegate?
    
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
        
        txtField.delegate = self
        containerView.customRoundedView(radius: 10)
    }
       
    
    
    @IBAction func actBtnFieldIcon(_ sender: Any) {
        delegate?.onClickTextFieldIcon()
    }
    
    
    
    public func isSecureTextField(isSecure: Bool){
        txtField.isSecureTextEntry = isSecure
    }
    
    public func setPlaceHolder(placeholder: String){
        txtField.placeholder = placeholder
    }
    
    public func setImageFieldIcon(icon: UIImage){
        imgFieldIcon.image = icon
    }
    
    public func getImageFieldIcon()-> UIImage {
        return imgFieldIcon.image ?? UIImage()
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



extension TextFieldWithIconView : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
