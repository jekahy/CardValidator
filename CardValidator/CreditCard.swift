//
//  CreditCard.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

struct CreditCard: Equatable {

    let number: String?
    let expiration: Expiration?
    let cvv: String?

    var numberWithSpaces: String? {

        guard let number = number else {
            return nil
        }
        return String(
            number.characters.enumerated().map {
                (($0.offset + 1) % 4 == 0) &&
                    ($0.offset != number.characters.count-1) ? [$0.element, " "] : [$0.element]
                }.joined()
        )
    }

    static func == (lhs: CreditCard, rhs: CreditCard) -> Bool {
        return (lhs.number == rhs.number && lhs.expiration == rhs.expiration && lhs.cvv == rhs.cvv)
    }
}
