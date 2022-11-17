//
//  SettingsVC.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit

class SettingsVC: BasicVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var outlet: UILabel!
                
        
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Methods
    
    // MARK: - IBActions
    
    @IBAction private func action(_ sender: UIButton) {
        sender.bounce()
    }
    
}
