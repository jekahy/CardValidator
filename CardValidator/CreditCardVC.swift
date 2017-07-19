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
    
    private (set) var cardView:CreditCardView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cardView = CreditCardView()
        view.addSubview(cardView)
        
        cardView.autoPinEdge(toSuperviewEdge: .left)
        cardView.autoPinEdge(toSuperviewEdge: .right)
        cardView.autoPin(toTopLayoutGuideOf: self, withInset: 50)
        cardView.autoSetDimension(.height, toSize: 120)
        
        
        view.backgroundColor = UIColor.white
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        
//    }
}

