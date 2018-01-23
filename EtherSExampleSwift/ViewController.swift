//
//  ViewController.swift
//  EtherSExampleSwift
//
//  Created by Sameer Khavanekar on 1/22/18.
//  Copyright © 2018 Radical App LLC. All rights reserved.
//

import UIKit
import Geth
import EtherS

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let value = GethNewBigInt(5)
        
        let function = EthFunction(name: "Sam", inputParameters: [value!])
        let encodedData = EtherS.encode(function)
        
        print("Encoded Data is \(encodedData.toHexString())")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

