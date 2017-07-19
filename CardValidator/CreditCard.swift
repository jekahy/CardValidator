//
//  CreditCard.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation

struct Expiration {
    
    let month:String
    let year:String
}

struct CreditCard {
    
    let number:String
    let expiration:Expiration
    let cvv:String
}
