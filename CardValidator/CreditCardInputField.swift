//
//  CreditCardInputField.swift
//  CardValidator
//
//  Created by Eugene on 18.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import UIKit

enum CardInputTFKind:Int {
    case number = 0
    case expirationDate
    case cvv
}

class CreditCardInputField: UIStackView {
    
    
    let cardNumberTF = TextField()
    let expirationDateTF = TextField()
    let cvvTF = TextField()
    
    let elementSpacing:CGFloat = 10
    let minimumElementHeigh:CGFloat = 50
    
    private (set) lazy var textFields:[UITextField] = [self.cardNumberTF, self.expirationDateTF, self.cvvTF]
    private (set) lazy var tfHandler:CardInputTextFieldHandler = CardInputTextFieldHandler(self.textFields)

    var currentCreditCard:CreditCard{
        
        get{
            let expiration = Expiration(string:expirationDateTF.text ?? "")
            let number = cardNumberTF.text?.replacingOccurrences(of: " ", with: "")
            return CreditCard(number: number, expiration: expiration, cvv: cvvTF.text)
        }
        set{
            cardNumberTF.text = newValue.numberWithSpaces
            expirationDateTF.text = newValue.expiration?.singleString
            cvvTF.text = newValue.cvv
        }
    }
    
    
    init() {
        
        super.init(frame: CGRect.zero)
        
        self.distribution = .fillProportionally
        self.spacing = elementSpacing

        _ = textFields.reduce(0) {
            $0.1.tag = $0.0
            return $0.0+1
        }
        _ = textFields.map{addArrangedSubview($0)}
        _ = textFields.map{ [unowned self] in
            
            $0.delegate = self.tfHandler
            $0.keyboardType = .numberPad
            $0.font = $0.font?.withSize(16)
            $0.clipsToBounds = true
        }
        
        cardNumberTF.placeholder = "1234 1234 1234 1245"
        expirationDateTF.placeholder = "MM/YY"
        cvvTF.placeholder = "123"
    }
    
    required init(coder: NSCoder)
    {
        super.init(coder: coder)
    }
}
