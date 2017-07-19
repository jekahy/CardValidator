//
//  CreditCardInputVC.swift
//  CardValidator
//
//  Created by Eugene on 18.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import PureLayout

class CreditCardInputVC: UIViewController {
    
    private (set) var cardField:CreaditCardInputField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cardField = CreaditCardInputField()
        view.addSubview(cardField)
        
        cardField.autoPinEdge(toSuperviewEdge: .left)
        cardField.autoPinEdge(toSuperviewEdge: .right)
        cardField.autoPin(toTopLayoutGuideOf: self, withInset: 50)
        cardField.autoSetDimension(.height, toSize: 70)
        
        cardField.backgroundColor = UIColor.blue
        view.backgroundColor = UIColor.white
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        
//    }
}

