//
//  CreditCardView.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import PureLayout

class CreditCardView: UIView {
    
    let inputField = CreditCardInputField()
    let edgeMargin:CGFloat = 10

    init()
    {
        super.init(frame: CGRect.zero)
        addSubview(inputField)
        inputField.autoPinEdge(toSuperviewEdge: .top, withInset:edgeMargin)
        inputField.autoPinEdge(toSuperviewEdge: .leading, withInset:edgeMargin)
        inputField.autoPinEdge(toSuperviewEdge: .trailing, withInset:edgeMargin)
        inputField.autoMatch(.height, to: .height, of: self, withMultiplier: 0.5)
        backgroundColor = UIColor.purple
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
}
