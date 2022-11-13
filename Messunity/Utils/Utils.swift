//
//  Utils.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit
import Foundation

// MARK: - Constants

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

// MARK: - Types

typealias Parameters = [String: Any]
typealias string_bool_block = (_ string: String, _ result: Bool) -> Void

// MARK: - Utils Class

final class Utils {
    
    static func topViewController(base: UIViewController? = APP_DELEGATE.window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    // MARK: - Alert Controllers
    
    static func dismissAlert(title: String, message: String, completion: string_bool_block?) {
        guard let topVC = Utils.topViewController(), !topVC.isKind(of: UIAlertController.self) else { return }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            completion?("", true)
        })
        topVC.present(alertController, animated: true, completion: nil)
    }
    
    static func dismissAlertWithAction(title: String, message: String, completion: string_bool_block?) {
        guard let topVC = Utils.topViewController(), !topVC.isKind(of: UIAlertController.self) else { return }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            completion?("", true)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        topVC.present(alertController, animated: true, completion: nil)
    }
}

