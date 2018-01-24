//
//  CreateAccountViewController.swift
//  EtherSExampleSwift
//
//  Created by Sameer Khavanekar on 1/23/18.
//  Copyright © 2018 Radical App LLC. All rights reserved.
//

import UIKit
import EtherS

class CreateAccountViewController: UIViewController {
    private let _toTransferSegueIdentifier = "createAccountToTransferSegue"
    
    @IBAction func createAccountAction(_ sender: Any) {
        let (_, account) = EthAccountCoordinator.default.setup(EthAccountConfiguration.default)
        
        if account != nil {
            self.performSegue(withIdentifier: _toTransferSegueIdentifier, sender: nil)
        } else {
            print("Error creating account.")
        }
    }
    
}
