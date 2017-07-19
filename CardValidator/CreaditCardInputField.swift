//
//  CreaditCardInputField.swift
//  CardValidator
//
//  Created by Eugene on 18.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import UIKit
import PureLayout



class CreaditCardInputField: UIControl {
    
    enum FieldKind:Int {
        case number = 0
        case expirationDate
        case cvv
    }
    
    
    let cardNumberTF = UITextField(frame: CGRect.zero)
    let expirationDateTF = UITextField(frame: CGRect.zero)
    let cvvTF = UITextField(frame: CGRect.zero)
    
    let edgeMargin:CGFloat = 10
    let elementsSpacing:CGFloat = 10
    let minimumElementHeigh:CGFloat = 50
    
    fileprivate lazy var textFields:[UITextField] = [self.cardNumberTF, self.expirationDateTF, self.cvvTF]
    
    init() {
        
        super.init(frame: CGRect.zero)
        
        _ = textFields.reduce(0) {
            $0.1.tag = $0.0
            return $0.0+1
        }
        _ = textFields.map{addSubview($0)}
        _ = textFields.map{ tf -> (UITextField) in
            tf.backgroundColor = UIColor.green
            tf.delegate = self
            return tf
        }
        
        _ = textFields.map{
            $0.autoAlignAxis(toSuperviewAxis: .horizontal)
            $0.autoSetDimension(.height, toSize: minimumElementHeigh, relation: .greaterThanOrEqual)
        }
        
        cardNumberTF.autoPinEdge(toSuperviewEdge: .left, withInset:edgeMargin)
        cardNumberTF.autoPinEdge(.right, to: .left, of: expirationDateTF, withOffset: -elementsSpacing)
        cardNumberTF.autoSetDimension(.width, toSize: 70, relation: .greaterThanOrEqual)

        expirationDateTF.autoPinEdge(.right, to: .left, of: cvvTF, withOffset: -elementsSpacing)
        expirationDateTF.autoSetDimension(.width, toSize: 50, relation: .greaterThanOrEqual)

        cvvTF.autoPinEdge(toSuperviewEdge: .right, withInset:edgeMargin)
        cvvTF.autoSetDimension(.width, toSize: 50, relation: .greaterThanOrEqual)

    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    
    }
}


extension CreaditCardInputField:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let tfKind = FieldKind(rawValue: textField.tag)  else {
            return true
        }
        
        switch tfKind {
        
        case .number:
            guard range.length == 0 else { // deleting
                break
            }
            if range.location == 16 {
                switchToNeighbourTF(of: textField, direction: 1)
            }
        case .expirationDate:
            print(range.location)
            switch (range.location, range.length) {
                
                case (0, 1):

                    switchToNeighbourTF(of: textField, direction: -1)
                    textField.text = ""
                    return false
                
                case (2, 0):

                    textField.text = textField.text! + "/"
                    
                case (5, 0):

                    switchToNeighbourTF(of: textField, direction: 1)
                
                default:
                    break
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
}
