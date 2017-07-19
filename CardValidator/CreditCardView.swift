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
    
    typealias VoidClosure = ()->()
    
    let inputField = CreditCardInputField()
    let validateButton = Button(type: .custom)
    let generateButton = Button(type: .custom)
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let validityIndicator = ValidityIndicator()
    let edgeMargin:CGFloat = 10
    let buttonHeight:CGFloat = 30
    
    var generateTapClosure:VoidClosure?{
        set{
            generateButton.didTouchUpInsideClosure = newValue
        }
        get{
            return generateButton.didTouchUpInsideClosure
        }
    }
    
    var validateTapClosure:VoidClosure?{
        set{
            validateButton.didTouchUpInsideClosure = newValue
        }
        get{
            return validateButton.didTouchUpInsideClosure
        }
    }
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        addSubview(inputField)
        addSubview(validateButton)
        addSubview(generateButton)
        addSubview(activityIndicator)
        addSubview(validityIndicator)
        
        activityIndicator.isHidden = true
        
        validityIndicator.isHidden = false

        
        backgroundColor = UIColor.purple
        
        validateButton.backgroundColor = UIColor.cyan
        validateButton.setTitle("Validate", for: .normal)
        
        generateButton.backgroundColor = UIColor.cyan
        generateButton.setTitle("Generate", for: .normal)
        
        
        setupConstraints()
    }
    
    private func setupConstraints()
    {
        inputField.autoPinEdge(toSuperviewEdge: .top, withInset:edgeMargin)
        inputField.autoPinEdge(toSuperviewEdge: .leading, withInset:edgeMargin)
        inputField.autoPinEdge(toSuperviewEdge: .trailing, withInset:edgeMargin)
        inputField.autoMatch(.height, to: .height, of: self, withMultiplier: 0.5)
        
        validateButton.autoPinEdge(.top, to: .bottom, of: inputField, withOffset:edgeMargin)
        validateButton.autoSetDimension(.width, toSize: 60, relation: .greaterThanOrEqual)
        validateButton.autoSetDimension(.height, toSize: buttonHeight)
        validateButton.autoPinEdge(toSuperviewEdge: .trailing, withInset:edgeMargin)
        
        
        generateButton.autoPinEdge(.top, to: .bottom, of: inputField, withOffset:edgeMargin)
        generateButton.autoSetDimension(.width, toSize: 60, relation: .greaterThanOrEqual)
        generateButton.autoSetDimension(.height, toSize: buttonHeight)
        generateButton.autoPinEdge(toSuperviewEdge: .leading, withInset:edgeMargin)
        
        generateButton.autoMatch(.width, to: .width, of: validateButton)
        
        activityIndicator.autoAlignAxis(.horizontal, toSameAxisOf: generateButton)
        activityIndicator.autoAlignAxis(.vertical, toSameAxisOf: self)
        activityIndicator.autoSetDimensions(to: CGSize(width: buttonHeight, height: buttonHeight))
        activityIndicator.autoPinEdge(.left, to: .right, of: generateButton, withOffset: edgeMargin, relation:NSLayoutRelation.greaterThanOrEqual)
        activityIndicator.autoPinEdge(.right, to: .left, of: validateButton, withOffset: -edgeMargin, relation:NSLayoutRelation.greaterThanOrEqual)
        
        validityIndicator.autoMatchAll(to:activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
}
