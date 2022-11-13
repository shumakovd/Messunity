//
//  UIButtonExt.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit
import Foundation

extension UIButton {
            
    func setRoundedLine() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.borderColorView = .white
        } else {
            self.borderColorView = .black
        }
        
        self.borderWidthView = 1
        self.layer.cornerRadius = 8
    }
}
