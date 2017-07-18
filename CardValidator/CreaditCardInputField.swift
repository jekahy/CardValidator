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
    
    let cardNumberTF = UITextField(frame: CGRect.zero)
    let expirationDateTF = UITextField(frame: CGRect.zero)
    let cvcTF = UITextField(frame: CGRect.zero)
    
    let edgeMargin:CGFloat = 10
    let elementsSpacing:CGFloat = 10
    
    init() {
        
        super.init(frame: CGRect.zero)
        
        self.addSubview(cardNumberTF)
        self.addSubview(expirationDateTF)
        self.addSubview(cvcTF)
        
        cardNumberTF.backgroundColor = UIColor.green
        expirationDateTF.backgroundColor = UIColor.yellow
        cvcTF.backgroundColor = UIColor.yellow
        
        cardNumberTF.autoPinEdge(toSuperviewEdge: .left, withInset:edgeMargin)
        cardNumberTF.autoAlignAxis(toSuperviewAxis: .horizontal)
        cardNumberTF.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
        cardNumberTF.autoPinEdge(.right, to: .left, of: expirationDateTF, withOffset: -elementsSpacing)
        cardNumberTF.autoSetDimension(.width, toSize: 70, relation: .greaterThanOrEqual)
        
        
        expirationDateTF.autoAlignAxis(toSuperviewAxis: .horizontal)
        expirationDateTF.autoMatch(.height, to: .height, of: cardNumberTF)
        expirationDateTF.autoPinEdge(.right, to: .left, of: cvcTF, withOffset: -elementsSpacing)
        expirationDateTF.autoSetDimension(.width, toSize: 50, relation: .greaterThanOrEqual)
        
        cvcTF.autoAlignAxis(toSuperviewAxis: .horizontal)
        cvcTF.autoMatch(.height, to: .height, of: cardNumberTF)
        cvcTF.autoPinEdge(toSuperviewEdge: .right, withInset:edgeMargin)
        cvcTF.autoSetDimension(.width, toSize: 50, relation: .greaterThanOrEqual)

    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    
    }
    override func layoutSubviews()
    {
        
        super.layoutSubviews()
        
    }
}
