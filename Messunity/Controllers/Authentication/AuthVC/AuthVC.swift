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
    
    @IBOutlet private weak var signInWithEmailButton: UIButton!
    @IBOutlet private weak var signInWithNumberButton: UIButton!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var numberTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatPasswordTextField: UITextField!
        
    // MARK: - Properties
    
    private var phoneNumber: String?
    private var vereficationId: String?
    
    // Authentication State
    private var authState: AuthState = .withNumber {
        willSet {
            let buttons = [signInWithEmailButton, signInWithNumberButton]
            let textFields = [emailTextField, numberTextField, passwordTextField, repeatPasswordTextField]
            if newValue == .withEmail {
                for each in textFields {
                    if each == numberTextField {
                        each?.isHidden = true
                    } else {
                        each?.isHidden = false
                    }
                }
                for each in buttons {
                    if each == signInWithEmailButton {
                        each?.isHidden = true
                    } else {
                        each?.isHidden = false
                    }
                }
            }
            
            if newValue == .withNumber {
                for each in textFields {
                    if each == numberTextField {
                        each?.isHidden = false
                    } else {
                        each?.isHidden = true
                    }
                }
                for each in buttons {
                    if each == signInWithNumberButton {
                        each?.isHidden = true
                    } else {
                        each?.isHidden = false
                    }
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        configureUI()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Methods
    
    private func configureUI() {
        //
        emailTextField.delegate = self
        emailTextField.setBottomLine(.normal)
        
        numberTextField.delegate = self
        numberTextField.setBottomLine(.normal)
        
        passwordTextField.delegate = self
        passwordTextField.setBottomLine(.normal)
        
        repeatPasswordTextField.delegate = self
        repeatPasswordTextField.setBottomLine(.normal)
                        
        //
        signInButton.setRoundedLine()
    }
    
    private func handleRequiredData() {
        
        var auth = true
        errorLabel.text = ""
        
        if authState == .withNumber {
            if numberTextField.text?.count ?? 0 < 9 {
                auth = false
                numberTextField.textFieldError()
            } else {
                numberTextField.setBottomLine(.normal)
            }
        }
                
        if authState == .withEmail {
            let email = emailTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            let repeatPassword = repeatPasswordTextField.text ?? ""
            
            // Email
            if !AppSettings.shared.isValidEmail(email) {
                auth = false
                emailTextField.setBottomLine(.error)
                errorLabel.text = errorLabel.text != "" ? errorLabel.text : "Invalid email address"
            } else {
                emailTextField.setBottomLine(.normal)
            }
            
            // Password
            let errors = AppSettings.shared.getPasswordValidation(password)
            if !errors.isEmpty {
                auth = false
                passwordTextField.setBottomLine(.error)
                errorLabel.text = errorLabel.text != "" ? errorLabel.text : errors.first
            }
            
            // Repeat Password
            if password != repeatPassword {
                auth = false
                errorLabel.text = errorLabel.text != "" ? errorLabel.text : "The passwords don't match"
            }
        }
        
        if auth {
            signIn()
        }
    }
    
    // MARK: - Navigation Methods
    
    private func goToCodeVC() {
        let vc = kAuthStoryboard.instantiateViewController(withIdentifier: ViewControllerIDs.AuthStoryboard.kCodeVC) as! CodeVC
        vc.vereficationId = vereficationId
        self.show(vc, sender: nil)
    }
    
    private func goToCreateUserVC() {
        let vc = kAuthStoryboard.instantiateViewController(withIdentifier: ViewControllerIDs.AuthStoryboard.kCreateUserVC) as! CreateUserVC
        self.show(vc, sender: nil)
    }
        
    
    // MARK: - Network Methods
    
    private func signIn() {
        // start some indicator
        if authState == .withEmail {
            signInWithEmail()
        }
        
        if authState == .withNumber {
            signInWithNumber()
        }
    }
    
    private func checkIfUserExist() {
        
        let email = emailTextField.text ?? ""
        let number = phoneNumber ?? ""
        
        if authState == .withEmail {
            FirebaseManager.shared.isUserWithEmailAlreadyExist(email: email) { result in
                print("• Result: ", result)
            }
        }
        
        if authState == .withNumber {
            FirebaseManager.shared.isUserWithNumberAlreadyExist(number: email) { result in
                print("• Result: ", result)
            }
        }
    }
    
    private func signInWithNumber() {
                
        // FIXME: - need to change number with regex
        let number = "+38\(numberTextField.text ?? "")"
        print("• Number: ", number)
        FirebaseManager.shared.phoneAuthProvider(code: .ua, number: number) { vereficationId in
            print("Completion id: ", vereficationId)
                                    
            self.vereficationId = vereficationId
            self.goToCodeVC()
        }
    }
    
    private func signInWithEmail() {
                       
        // FIXME: - Check if correct email address
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        print("• Email: ", email)
        print("• Password: ", password)
        
        var parameters: [UserChildValues: Any] = [:]
        parameters[.u_email] = email
        
        FirebaseManager.shared.signInWithEmailAddress(parameters: parameters, password: password, completion: { status in
            print(" • Status signInWithEmailAddress: ", status)
            
            self.goToCreateUserVC()
        })
        
    }
    
    
    
    //
    
   
    
    // UITextField View When the Keyboard Appears
    @objc override func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 10  //keyboardSize.height
            }
        }
    }
          
    @objc override func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BasicVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - IBActions
    
    @IBAction private func loginAction(_ sender: UIButton) {
        view.endEditing(true)
        sender.bounce()
    }
    
    @IBAction private func signInWithEmailAction(_ sender: UIButton) {
        view.endEditing(true)
        sender.bounce()
        
        authState = .withEmail
    }
    
    @IBAction private func signInWithNumberAction(_ sender: UIButton) {
        view.endEditing(true)
        sender.bounce()
        
        authState = .withNumber
    }
    
    @IBAction private func signInAction(_ sender: UIButton) {
        view.endEditing(true)
        sender.bounce()
        handleRequiredData()
    }
    
}

extension AuthVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case numberTextField:
            handleRequiredData()
            return true
        case emailTextField:
            passwordTextField.becomeFirstResponder()
            return true
        case passwordTextField:
            repeatPasswordTextField.becomeFirstResponder()
            return true
        case repeatPasswordTextField:
            handleRequiredData()
            return true
        default:
            return false
        }
    }
}

