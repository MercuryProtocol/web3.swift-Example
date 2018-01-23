//
//  TransferViewController.swift
//  EtherSExampleSwift
//
//  Created by Sameer Khavanekar on 1/22/18.
//  Copyright © 2018 Radical App LLC. All rights reserved.
//

import UIKit
import Geth
import EtherS
import Alamofire

class TransferViewController: UIViewController {
    @IBOutlet weak var contractAddressTextField: UITextField!
    @IBOutlet weak var toAccountTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var transferButton: UIButton!
    
    
    struct Constants {
        static let contractAddress = "0xc4a278103162f47d8aa0212644044564062b09f1"
        static let toAccountAddress = "0x39db95b4f60bd75846c46df165d9e854b3cf1b56"
        static let transferFunctionName = "transfer"
        static let transferAmount = 1
        static let gasPrice = GethNewBigInt(20000000000)!
        static let gasLimit = GethNewBigInt(4300000)!
        
        static let serverURL = "https://yourserverhere/"
        static let trasferURL = "contract/send"
        static let nonceURL = "account/getTransactionCount"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contractAddressTextField.text = Constants.contractAddress
        toAccountTextField.text = Constants.toAccountAddress
        amountTextField.text = String(Constants.transferAmount)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func transferAction(_ sender: UIButton) {
        guard let contractAddress = contractAddressTextField.text, let toAccountAddress = toAccountTextField.text, let amount = amountTextField.text else {
            print("Invalid Entry")
            return
        }
        if contractAddress.isHexAddress() && toAccountAddress.isHexAddress() {
            
            
            
        } else {
            print("Addresss Invalid")
        }
    }
    
    @IBAction func dismissTextField(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    private func _transfer(contractAddress: GethAddress, toAccountAddress: GethAddress, amount: GethBigInt) {
        let transferFunction = EthFunction(name: Constants.transferFunctionName, inputParameters: [toAccountAddress, amount])
        let encodedTransferFunction = EtherS.encode(transferFunction)
        
        var _toAddressError: NSError? = nil
        var nonce: Int64 = 1
        
        // Grab is from ethereum client or through web service call to your server
        let keystore: GethKeyStore! = GethNewKeyStore("", 0, 0)!
        
        do {
            let account: GethAccount! = try keystore.getAccounts().get(0)
            let ethClient: GethEthereumClient! = GethNewEthereumClient("", &_toAddressError)!
            let context = GethNewContext()
            try ethClient.getPendingNonce(at: context, account: account.getAddress(), nonce: &nonce)
            let signedTransaction = EtherS.sign(address: contractAddress, encodedFunctionData: encodedTransferFunction, nonce: nonce, gasLimit: Constants.gasLimit, gasPrice: Constants.gasPrice, keystore: keystore, account: account, passphrase: "qwerty")
            
            if let signedTransactionData = try signedTransaction?.encodeRLP() {
                let encodedSignedTransaction = signedTransactionData.base64EncodedString()
                
                
            } else {
                print("Failed to sign/encode")
            }
        } catch {
            print("Failed in encoding transaction ")
        }
    }
    
}


// MARK:- Web API calls

extension TransferViewController {
    
    func getNonce(_ accountAddress: String, completion: @escaping (Int64?, Error?) -> Void) {
        let urlString = Constants.serverURL + Constants.nonceURL
        
        let parameters: Parameters = [
            "address" : accountAddress,
            ]
        
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in
            if let data = response.result.value, let nonce = Int64(String(describing: data)) {
                completion(nonce, nil)
            } else {
                // Pass appropriate error here
                completion(nil, nil)
            }
        }
    }
    
    func executeContract(_ signedTransaction: String, completion: @escaping (String?, Error?) -> Void) {
        let urlString = Constants.serverURL + Constants.trasferURL
        
        let parameters: Parameters = [
            "signedTx" : signedTransaction,
        ]
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in
            if let data = response.result.value {
                let transactionHash = String(describing: data)
                completion(transactionHash, nil)
            } else {
                // Pass appropriate error here
                completion(nil, nil)
            }
        }
        
    }
    
}
