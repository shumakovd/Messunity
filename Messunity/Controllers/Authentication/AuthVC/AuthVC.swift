//
//  AuthVC.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit

class AuthVC: BasicVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var errorLabel: UILabel!
            
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    
    @IBOutlet private weak var usernameTextField: UITextField!
        
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Methods
    
    // MARK: - IBActions
    
    @IBAction private func loginAction(_ sender: UIButton) {
        sender.bounce()
    }
    
    @IBAction private func signInAction(_ sender: UIButton) {        
        sender.bounce()
        
    }
    
}

extension AuthVC: UITextFieldDelegate {
    
}
