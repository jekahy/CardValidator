//
//  CreditCardView.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import PureLayout

protocol CreditCardViewType: class, ViewProvidable {
    
    typealias ValidationClosure = (CreditCard, @escaping (Bool)->())->()
    typealias GenerationClosure = ()->(CreditCard)
    
    var generateTapClosure:GenerationClosure?{get set}
    var validateTapClosure:ValidationClosure?{get set}
    
}

class CreditCardView: UIView, CreditCardViewType {

    let inputField:CreditCardInputFieldType = CreditCardInputField()
    let validateButton = Button(type: .custom)
    let generateButton = Button(type: .custom)
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let validityIndicator = ValidityIndicator()
    let edgeMargin:CGFloat = 10
    let buttonHeight:CGFloat = 30
    
    var generateTapClosure:GenerationClosure?{
        
        didSet{
            
            generateButton.didTouchUpInsideClosure = {[weak self] in
                
                self?.endEditing(true)
                
                guard let creditCard = self?.generateTapClosure?() else {return}
            
                self?.inputField.currentCreditCard = creditCard
            }
        }
    }
    
    var validateTapClosure:ValidationClosure?{
        didSet{
            validateButton.didTouchUpInsideClosure = {[weak self] in
                
                self?.endEditing(true)
                self?.toggleBusyMode(true)
                
                guard let valClosure = self?.validateTapClosure, let currentCard = self?.inputField.currentCreditCard else {
                    return
                }
                valClosure(currentCard){[weak self] isValid in
                    self?.validityIndicator.isValid = isValid
                    self?.toggleBusyMode(false)
                }
            }
        }
    }

    init()
    {
        super.init(frame: CGRect.zero)
        
        addSubview(inputField.view)
        addSubview(validateButton)
        addSubview(generateButton)
        addSubview(activityIndicator)
        addSubview(validityIndicator)
        
        toggleBusyMode(false)
        
        validateButton.setTitle("Validate", for: .normal)
        validateButton.setTitleColor(UIColor.black, for: .normal)
        
        generateButton.setTitle("Generate", for: .normal)
        generateButton.setTitleColor(UIColor.black, for: .normal)
        
        setupConstraints()
    }
    
    func setupConstraints()
    {
        inputField.view.autoPinEdge(toSuperviewEdge: .top, withInset:edgeMargin)
        inputField.view.autoPinEdge(toSuperviewEdge: .leading, withInset:edgeMargin)
        inputField.view.autoPinEdge(toSuperviewEdge: .trailing, withInset:edgeMargin)
        inputField.view.autoMatch(.height, to: .height, of: self, withMultiplier: 0.5)
        
        validateButton.autoPinEdge(.top, to: .bottom, of: inputField.view, withOffset:edgeMargin)
        validateButton.autoSetDimension(.width, toSize: 60, relation: .greaterThanOrEqual)
        validateButton.autoSetDimension(.height, toSize: buttonHeight)
        validateButton.autoPinEdge(toSuperviewEdge: .trailing, withInset:edgeMargin)
        
        generateButton.autoPinEdge(.top, to: .bottom, of: inputField.view, withOffset:edgeMargin)
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
    
    
    func toggleBusyMode(_ busyOn:Bool)
    {
        isUserInteractionEnabled = !busyOn
        activityIndicator.isHidden = !busyOn
        validityIndicator.isHidden = busyOn
        if busyOn{
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
}
