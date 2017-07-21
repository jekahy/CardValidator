//
//  CardInputTextFieldHandler.swift
//  CardValidator
//
//  Created by Eugene on 21.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit

class CardInputTextFieldHandler:NSObject,UITextFieldDelegate{
    

    enum TextFieldMoveDirection:Int{
        case next = 1
        case previous = -1
    }

    enum TextFieldChangeCommand{
        case denyEdit
        case edit
        case editAndUpdateText(String)
        case editAndMoveToNeighbour(TextFieldMoveDirection)
        case moveToNeighbourAndClear(TextFieldMoveDirection)
    }
    
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
        
        let command = handleTextFieldChange(textFieldKind: tfKind, text: text, nextTextFieldText: nextTFText, shouldChangeCharactersIn: range, replacementString: string)
        
        switch command {
            
            case .edit:     return true
            
            case .denyEdit: return false
            
            case .editAndMoveToNeighbour(direction: let direction):
                switchToNeighbourTF(of: textField, direction: direction)
                return true
            
            case .editAndUpdateText(let newText):
                textField.text = newText
                return true
            
            case .moveToNeighbourAndClear(directin: let direction):
                textField.text = ""
                switchToNeighbourTF(of: textField, direction: direction)
                return false
        }
    }

    
    func handleTextFieldChange(textFieldKind tfKind:CardInputTFKind,
                               text: String,
                               nextTextFieldText nextTFText:String?,
                               shouldChangeCharactersIn range: NSRange,
                               replacementString string: String) -> TextFieldChangeCommand
    {
        
        guard validateString(string: string) else {return .denyEdit}
        
        let isDeleting = range.length == 1
        let location = range.location
        
        switch tfKind {
            
        case .number:
            
            // Limit the card number to 16 numbers
            if text.length == 19 && !isDeleting, let nextText = nextTFText, nextText.length == 5 { return .denyEdit }
            
            switch (location, isDeleting){
                
            case (4, false), (9, false), (14, false): return .editAndUpdateText(text + " ") // Add space
                
            case (5, true), (10, true), (15, true): // Skip space
                
                let index = text.index(before:text.endIndex)
                return .editAndUpdateText(text.substring(to: index))
                
            case (19, false): return .editAndMoveToNeighbour(.next)
                
            default: if !isDeleting { return text.length < 19 ? .edit : .denyEdit }
                
            }
            
        case .expirationDate:
            
            // Prevent entering more than 5 numbers
            if text.length == 5 && !isDeleting, let nextText = nextTFText, nextText.length == 3 {
                return .denyEdit
            }
            
            switch (location, isDeleting) {
                
            case (0, true): return .moveToNeighbourAndClear(.previous)
                
            case (2, false): return .editAndUpdateText(text + "/")  // Add slash
                
            case (3, true): // Skip slash
                
                let index = text.index(before:text.endIndex)
                return .editAndUpdateText(text.substring(to: index))
                
            case (5, false): return .editAndMoveToNeighbour(.next)
                
            default: if !isDeleting { return text.length < 5 ? .edit : .denyEdit }
            }
            
        case .cvv:
            
            if text.length == 3 && !isDeleting  {return .denyEdit}
            
            guard location == 0, isDeleting  else {break}
            
            return .moveToNeighbourAndClear(.previous)
        }
        
        return .edit
    }

    
    fileprivate func switchToNeighbourTF(of tf:UITextField, direction:TextFieldMoveDirection)
    {
        guard let neighbourTF = textFields.first(where: {$0.tag == tf.tag + direction.rawValue}) else {return}
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
