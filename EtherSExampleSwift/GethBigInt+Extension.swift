//
//  GethBigInt+Extension.swift
//  EtherSExampleSwift
//
//  Created by Sameer Khavanekar on 1/24/18.
//  Copyright © 2018 Radical App LLC. All rights reserved.
//

import Foundation
import Geth

extension GethBigInt {
    
    static func bigInt(_ valueInEther: Int) -> GethBigInt? {
        return bigInt(String(valueInEther))
    }
    
    static func bigInt(_ valueInEther: String) -> GethBigInt? {
        let amountInWei = "\(valueInEther)000000000000000000"
        
        let result = GethNewBigInt(0)
        result?.setString(amountInWei, base: 10)
        return result
    }
    
}
