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
    
    let cardView = CreditCardView()
    
    let api:APIProtocol = APIService()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(cardView)
        view.backgroundColor = UIColor.white

        cardView.autoPinEdge(toSuperviewEdge: .left)
        cardView.autoPinEdge(toSuperviewEdge: .right)
        cardView.autoPin(toTopLayoutGuideOf: self, withInset: 50)
        cardView.autoSetDimension(.height, toSize: 120)
        
        cardView.validateTapClosure = {[unowned self] creditCard, completion in
    
            CardValidationService.validate(creditCard, api: self.api, completion:completion)
        }
    }
}

