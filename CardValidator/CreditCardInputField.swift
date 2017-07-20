//
//  CreditCardInputField.swift
//  CardValidator
//
//  Created by Eugene on 18.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import UIKit

class CreditCardInputField: UIStackView {
    
    enum FieldKind:Int {
        case number = 0
        case expirationDate
        case cvv
    }
    
    let cardNumberTF = UITextField(frame: CGRect.zero)
    let expirationDateTF = UITextField(frame: CGRect.zero)
    let cvvTF = UITextField(frame: CGRect.zero)
    
    let elementSpacing:CGFloat = 10
    let minimumElementHeigh:CGFloat = 50
    
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
    
    fileprivate lazy var textFields:[UITextField] = [self.cardNumberTF, self.expirationDateTF, self.cvvTF]
    
    init() {
        
        super.init(frame: CGRect.zero)
        
        self.distribution = .fillProportionally
        
        self.spacing = elementSpacing
        backgroundColor = UIColor.orange
        _ = textFields.reduce(0) {
            $0.1.tag = $0.0
            return $0.0+1
        }
        _ = textFields.map{addArrangedSubview($0)}
        _ = textFields.map{
            
            $0.delegate = self
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


extension CreditCardInputField:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        guard validateString(string: string) else {
            return false
        }
        
        guard let tfKind = FieldKind(rawValue: textField.tag)  else {
            return true
        }
        
        switch tfKind {
        
        case .number:
            
            switch (range.location, range.length){
                
                case (4,0),(9,0),(14,0): textField.text = textField.text! + " " // Add space
                
                case (5,1),(10,1),(15,1): // Skip space
                    
                    guard let text = textField.text else {break}
                    let index = text.index(before:text.endIndex)
                    textField.text = text.substring(to: index)

                case (19,0): switchToNeighbourTF(of: textField, direction: 1)
                default: break
            }

        case .expirationDate:
            
            switch (range.location, range.length) {
                
                case (0, 1):

                    switchToNeighbourTF(of: textField, direction: -1)
                    textField.text = ""
                    return false
                
                case (2, 0): // Add slash

                    textField.text = textField.text! + "/"
            
                case (3, 1): // Skip slash
                    guard let text = textField.text else {break}
                    let index = text.index(before:text.endIndex)
                    textField.text = text.substring(to: index)
                
                case (5, 0):

                    switchToNeighbourTF(of: textField, direction: 1)
                
                default:break
            }

        case .cvv:
            
            guard range.location < 3 else {
                return false
            }
            
            guard range.location == 0, range.length == 1  else {break}
            
            switchToNeighbourTF(of: textField, direction: -1)
            
            textField.text = ""

            return false
        }
        return true
    }
    
    
    private func switchToNeighbourTF(of tf:UITextField, direction:Int)
    {
        guard let neighbourTF = textFields.first(where: {$0.tag == tf.tag + direction}) else {return}
        neighbourTF.becomeFirstResponder()
    }
    
    private func validateString(string:String)->Bool
    {
        let aSet = NSCharacterSet.decimalDigits.inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
