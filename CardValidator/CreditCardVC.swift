//
//  CreditCardVC.swift
//  CardValidator
//
//  Created by Eugene on 18.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import PureLayout

class CreditCardVC: UIViewController {
    
    let cardView:CreditCardViewType = CreditCardView()
    
    let api:APIProtocol = APIService()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(cardView.view)
        view.backgroundColor = UIColor.white

        cardView.view.autoPinEdge(toSuperviewEdge: .left)
        cardView.view.autoPinEdge(toSuperviewEdge: .right)
        cardView.view.autoPin(toTopLayoutGuideOf: self, withInset: 50)
        cardView.view.autoSetDimension(.height, toSize: 120)
        
        cardView.validateTapClosure = {[unowned self] creditCard, completion in
    
            CardValidationService.validate(creditCard, api: self.api, completion:completion)
        }
        
        cardView.generateTapClosure = { creditCard in
            
            return CardGenerationService.generateCard(kind: .visa)
        }
        
    }
}

