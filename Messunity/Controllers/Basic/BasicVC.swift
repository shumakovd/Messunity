//
//  BasicVC.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit

class BasicVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        listenNotifications()
    }
    
    deinit {
        removeNotifications()
    }
    
    // MARK: - Methods
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BasicVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BasicVC {
    
    // MARK: - Methods
    
    
    // MARK: - Notification Methods
    
    func listenNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - NSNotifications
    
    @objc func keyboardWillHide(notification _: NSNotification) {
        // override in child class
    }

    @objc func keyboardWillShow(notification _: NSNotification) {
        // override in child class
    }
    
}

