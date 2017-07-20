//
//  CreditCard.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//


struct CreditCard {
    
    let number:String?
    let expiration:Expiration?
    let cvv:String?
    
    var numberWithSpaces:String? {
        
        guard let number = number else {
            return nil
        }
        return String(
            number.characters.enumerated().map() {
                ($0.offset + 1) % 4 == 0 ? [$0.element, " "] : [$0.element]
                }.joined()
        )
    }
}

