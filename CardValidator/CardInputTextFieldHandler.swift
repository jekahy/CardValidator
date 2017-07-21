//
//  CardInputTextFieldHandler.swift
//  CardValidator
//
//  Created by Eugene on 21.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit

class CardInputTextFieldHandler:NSObject,UITextFieldDelegate{
    
    let textFields:[UITextField]
    
    init(_ textFields:[UITextField])
    {
        self.textFields = textFields
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard validateString(string: string) else {return false}
        guard let tfKind = CardInputTFKind(rawValue: textField.tag)  else {return true}
        guard let text = textField.text else {return true}
        
        var nextTFText:String?
        
        if let nextTF = textFields.first(where: {$0.tag == textField.tag + 1})  {
            
            nextTFText = nextTF.text
        }
        
        let isDeleting = range.length == 1
        let location = range.location
        
        switch tfKind {
            
        case .number:
            
            // Prevent entering more than 16 numbers
            if text.length == 19 && !isDeleting, let nextText = nextTFText, nextText.length == 5 {
                return false
            }
            
            switch (location, isDeleting){
                
            case (4, false), (9, false), (14, false):
                
                textField.text = text + " " // Add space
                
            case (5, true), (10, true), (15, true): // Skip space
                
                let index = text.index(before:text.endIndex)
                textField.text = text.substring(to: index)
                
            case (19,false):
                
                switchToNeighbourTF(of: textField, direction: 1)
                
            default:
                if !isDeleting { return text.length < 19 }
                
            }
            
        case .expirationDate:
            
            // Prevent entering more than 16 numbers
            if text.length == 5 && !isDeleting, let nextText = nextTFText, nextText.length == 3 {
                return false
            }
            
            switch (location, isDeleting) {
                
            case (0, true):
                
                switchToNeighbourTF(of: textField, direction: -1)
                textField.text = ""
                return false
                
            case (2, false): // Add slash
                
                textField.text = text + "/"
                
            case (3, true): // Skip slash
                
                let index = text.index(before:text.endIndex)
                textField.text = text.substring(to: index)
                
            case (5, false):
                
                switchToNeighbourTF(of: textField, direction: 1)
                
            default:
                if !isDeleting {
                    return text.length < 5
                }
            }
            
        case .cvv:
            
            if text.length == 3 && !isDeleting  {return false}
            
            guard location == 0, isDeleting  else {break}
            
            switchToNeighbourTF(of: textField, direction: -1)
            
            textField.text = ""
            
            return false
        }
        return true
    }
    
    fileprivate func switchToNeighbourTF(of tf:UITextField, direction:Int)
    {
        guard let neighbourTF = textFields.first(where: {$0.tag == tf.tag + direction}) else {return}
        neighbourTF.becomeFirstResponder()
    }
    
    fileprivate func validateString(string:String)->Bool
    {
        let aSet = NSCharacterSet.decimalDigits.inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
}
