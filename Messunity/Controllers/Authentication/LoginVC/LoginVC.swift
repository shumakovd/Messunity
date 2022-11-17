//
//  LoginVC.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit

class LoginVC: BasicVC {
    
    // MARK: - IBOutlets
            
    @IBOutlet private weak var errorLabel: UILabel!
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
        
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        configureUI()
    }
    
    // MARK: - Methods
    
    private func configureUI() {
        errorLabel.isHidden = true
        //
        usernameTextField.delegate = self
        usernameTextField.setBottomLine(.normal)
        //
        loginButton.setRoundedLine()
    }
    
    // MARK: - IBActions
    
    @IBAction private func loginAction(_ sender: UIButton) {
        sender.bounce()
        
    }
    
    @IBAction private func signInAction(_ sender: UIButton) {
        sender.bounce()
        
    }
    
}

extension LoginVC: UITextFieldDelegate {
    
}
