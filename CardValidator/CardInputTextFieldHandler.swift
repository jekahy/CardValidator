//
//  CardInputTextFieldHandler.swift
//  CardValidator
//
//  Created by Eugene on 21.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit

struct TextFieldChange {
    
    var text: String
    var nextTFText: String?
    var location: Int
    var isDeleting: Bool
    var replacementString: String
}

class CardInputTextFieldHandler: NSObject, UITextFieldDelegate {

    enum TextFieldMoveDirection: Int {
        case next = 1
        case previous = -1
    }

    enum TextFieldChangeCommand: Equatable {
        case denyEdit
        case edit
        case editAndUpdateText(String)
        case editAndMoveToNeighbour(TextFieldMoveDirection)
        case moveToNeighbourAndClear(TextFieldMoveDirection)

        static func == (lhs: TextFieldChangeCommand, rhs: TextFieldChangeCommand) -> Bool {
            switch (lhs, rhs) {
            case (.edit, .edit), (.denyEdit, .denyEdit): return true
            case (.editAndUpdateText(let lText), .editAndUpdateText(let rText)):return lText == rText
            case (.editAndMoveToNeighbour(let lNeigh), .editAndMoveToNeighbour(let rNeigh)): return lNeigh == rNeigh
            case (.moveToNeighbourAndClear(let lNeigh), .moveToNeighbourAndClear(let rNeigh)):
                return lNeigh == rNeigh
            default: return false
            }
        }
    }

    let textFields: [UITextField]

    init(_ textFields: [UITextField]) {
        self.textFields = textFields
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let tfKind = CardInputTFKind(rawValue: textField.tag)  else {return true}
        guard let text = textField.text else {return true}

        var nextTFText: String?

        if let nextTF = textFields.first(where: {$0.tag == textField.tag + 1}) {

            nextTFText = nextTF.text
        }
        
        let change = TextFieldChange(text: text, nextTFText: nextTFText, location: range.location, isDeleting: range.length > 0, replacementString: string)

        let command = handleTextFieldChange(change, for: tfKind)

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

    func handleTextFieldChange(_ change: TextFieldChange, for tfKind: CardInputTFKind) -> TextFieldChangeCommand {

        guard validateString(string: change.replacementString) else {return .denyEdit}

        switch tfKind {

            case .number:           return handleNumberChange(change)
            case .expirationDate:   return handleExpirationDateChange(change)
            case .cvv:              return handleCVVChange(change)
        }
    }
    
    func handleNumberChange(_ change: TextFieldChange) -> TextFieldChangeCommand {
        
        let text = change.text
        let isDeleting = change.isDeleting
        // Limit the card number to 16 numbers
        if text.length == 19 && !isDeleting, let nextText = change.nextTFText, nextText.length == 5 { return .denyEdit }
        
        switch (change.location, change.isDeleting) {
            
            case (4, false), (9, false), (14, false): return .editAndUpdateText(text + " ") // Add space
                
            case (5, true), (10, true), (15, true): // Skip space
                
                let index = text.index(before: text.endIndex)
                return .editAndUpdateText(text.substring(to: index))
                
            case (19, false): return .editAndMoveToNeighbour(.next)
                
            default: if !isDeleting { return text.length < 19 ? .edit : .denyEdit }
        }
        return .edit
    }
    
    func handleExpirationDateChange(_ change: TextFieldChange) -> TextFieldChangeCommand {
        
        let text = change.text
        let isDeleting = change.isDeleting
        
        // Prevent entering more than 5 numbers
        if text.length == 5 && !isDeleting, let nextText = change.nextTFText, nextText.length == 3 {return .denyEdit}
        
        switch (change.location, isDeleting) {
            
            case (0, true): return .moveToNeighbourAndClear(.previous)
                
            case (2, false): return .editAndUpdateText(text + "/")  // Add slash
                
            case (3, true): // Skip slash
                
                let index = text.index(before:text.endIndex)
                return .editAndUpdateText(text.substring(to: index))
                
            case (5, false): return .editAndMoveToNeighbour(.next)
                
            default: if !isDeleting { return text.length < 5 ? .edit : .denyEdit }
        }
        return .edit
    }
    
    func handleCVVChange(_ change: TextFieldChange) -> TextFieldChangeCommand {
        
        if change.text.length == 3 && !change.isDeleting {return .denyEdit}
        
        guard change.location == 0, change.isDeleting  else {return .edit}
        
        return .moveToNeighbourAndClear(.previous)
    }

    fileprivate func switchToNeighbourTF(of tf: UITextField, direction: TextFieldMoveDirection) {
        guard let neighbourTF = textFields.first(where: {$0.tag == tf.tag + direction.rawValue}) else {return}
        neighbourTF.becomeFirstResponder()
    }

    fileprivate func validateString(string: String) -> Bool {
        let aSet = NSCharacterSet.decimalDigits.inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }

}
