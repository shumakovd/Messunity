//
//  CodeVC.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 14.11.2022.
//

import UIKit

class CodeVC: BasicVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var resendButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    
    @IBOutlet private weak var codeTextField: UITextField!
    
    // MARK: - Properties
    
    var vereficationId: String?
    var phoneNumber: String?
    
    private var iteration = 60    
            
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        configureUI()
        // resendDescription()
    }
    
    // MARK: - Methods
    
    private func configureUI() {
        
        codeTextField.delegate = self
        codeTextField.textContentType = .oneTimeCode
        
        codeTextField.setBottomLine(.normal)
        confirmButton.setRoundedLine()
    }
    
    private func resendDescription() {
        iteration = iteration == UInt.min ? 0 : (iteration - 1)
        if iteration > 1 {
            self.resendButton.isEnabled = false
            self.resendButton.setTitleColor(.lightGray, for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                let title = "Resend verification code in 0:\(self.iteration) seconds"
                self.resendButton.setTitle(title, for: .normal)
                self.resendDescription()
            })
        } else {
            self.resendButton.isEnabled = true
            self.resendButton.setTitleColor(.cyan, for: .normal)
            let title = "Resend verification code"
            self.resendButton.setTitle(title, for: .normal)
        }
    }
    
    private func vereficationCompleted() {
        // vc
    }
    
    private func resendCode() {
        print("resend lol")
    }
    
    // MARK: - Networking Methods
    
    private func confirm() {
        let id = vereficationId ?? ""
        let code = codeTextField.text ?? ""
        let number = phoneNumber ?? ""
        
        FirebaseManager.shared.signInWithPhoneAuthProvider(currentVerificationId: id, verificationCode: code, number: number) { _ in
            self.goToMainVC()
        }
    }
                
    // MARK: - Navigation Methods
    
    private func goToMainVC() {        
        AppSettings.mainVC()
    }
    
    // MARK: - IBActions
    
    @IBAction private func codeAction(_ sender: UIButton) {
        sender.bounce()
        confirm()
    }
    
    @IBAction private func resendAction(_ sender: UIButton) {
        sender.bounce()
        resendCode()
    }
    

}

extension CodeVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case codeTextField:
            let count = textField.text?.count ?? 0
            if count == 5 {
                if count > 5 {
                    textField.deleteBackward()
                }
                
                confirm()
                confirmButton.isEnabled = true
            } else {
                confirmButton.isEnabled = false
            }
            
            return true
            
        default:
            return false
        }
    }
}
