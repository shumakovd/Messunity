//
//  UITextFieldExt.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit

enum BorderType {
    case error, normal
}

extension UITextField {
    
    // MARK: - Properties
    static var allowedNumberCharacters = CharacterSet(charactersIn: "+0123456789").inverted
    
    // MARK: - Methods
   
    func setBottomLine(_ type: BorderType) {
        
        var borderColor = UIColor()
        let borderHeight: CGFloat = 1
        
        switch type {
        case .normal:
            if self.traitCollection.userInterfaceStyle == .dark {
                borderColor = .white
            } else {
                borderColor = .black
            }
        case .error:
            borderColor = .red
        }
   
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let line = UIView()
            line.frame = CGRect(x: 0, y: self.frame.size.height - borderHeight,
                                width: self.frame.width, height: borderHeight)
            line.backgroundColor = borderColor
   
        self.addSubview(line)
    }
    
    func textFieldError() {
        self.shake()
        self.setBottomLine(.error)
    }
}


class NMTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

