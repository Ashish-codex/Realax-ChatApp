//
//  iMessageInputBarAccessoryView.swift
//  Realax
//
//  Created by Ashish Prajapati on 21/02/24.
//

import Foundation
import InputBarAccessoryView

class iMessageInputBarAccessoryView: InputBarAccessoryView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        if #available(iOS 13, *) {
            inputTextView.layer.borderColor = UIColor.systemGray2.cgColor
        } else {
            inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        }
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 16.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        
        let buttonsItem = [
            makeButton(named: "icon_attach_file"),
            sendButton
                .configure {
                    $0.image = #imageLiteral(resourceName: "icon_send")
                    $0.title = nil
                    $0.setSize(CGSize(width: 10, height: 37), animated: false)
                    $0.customRoundedView(radius: 19)
                    $0.backgroundColor = .primaryThemeColor
                    $0.layer.opacity = 0.3
                }.onDisabled {
                    $0.layer.opacity = 0.3
                }.onEnabled {
                    $0.layer.opacity = 1.0
                }.onSelected {
                    // We use a transform becuase changing the size would cause the other views to relayout
                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }.onDeselected {
                    $0.transform = CGAffineTransform.identity
            }
        ]
        
        
        
        rightStackView.alignment = .center
        
        setRightStackViewWidthConstant(to: 76, animated: false)
        setStackViewItems(buttonsItem, forStack: .right, animated: false)
//        sendButton.imageView?.backgroundColor = tintColor
//        sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
//        sendButton.image = #imageLiteral(resourceName: "icon_arrow_left")
//        sendButton.title = nil
//        sendButton.imageView?.layer.cornerRadius = 16
//        sendButton.backgroundColor = .clear
//        middleContentViewPadding.right = -38
        separatorLine.isHidden = false
        isTranslucent = false
    }
    
    
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)
                $0.setSize(CGSize(width: 28, height: 38), animated: false)
//                $0.backgroundColor = .gray
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }
    
    
}
