//
//  CreateUserVC.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 15.11.2022.
//

import UIKit

class CreateUserVC: BasicVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    //
    @IBOutlet private weak var userImageView: UIImageView!
    //
    @IBOutlet private weak var usernameTextField: UITextField!
    
    // MARK: - Properties
    
    private var image: UIImage?
    private var imageURL: String?
        
    private var imagePicker: ImagePicker?

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        configureUI()
    }
    
    // MARK: - Methods
    
    private func configureUI() {
        confirmButton.setRoundedLine()
        //
        usernameTextField.delegate = self
        usernameTextField.setBottomLine(.normal)
        //
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
            
    private func createUser() {
                        
        var dictionary: [UserChildValues: Any] = [:]
        
        // Name
        dictionary[.u_name] = usernameTextField.text ?? ""
        
        // Image Url
        if let imageURL = imageURL {
            dictionary[.u_imageUrl] = imageURL
        }
        
        // Create
        FirebaseManager.shared.updateUserData(parameters: dictionary) { status in
            print("• Status: ", status)
            if status {
                CacheManager().saveUserModel(dictionary: dictionary)
                AppSettings.mainVC()
            } else {
                // show error
            }
        }
    }
    
    // MARK: - Network Methods
    
    private func uploadImage() {
        let group = DispatchGroup()
        
        group.enter()
        FirebaseManager.shared.uploadImageToStorage(image: image) { imageURL in
            print("• Image Url: ", imageURL)
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.createUser()
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction private func imageAction(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    @IBAction private func confirmAction(_ sender: UIButton) {
        sender.bounce()
        uploadImage()
    }
        
}

extension CreateUserVC: UITextFieldDelegate {
    
}

extension CreateUserVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.image = image
        userImageView.image = image
    }
}
