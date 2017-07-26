//
//  Button.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit

class Button: UIButton {

    typealias DidTapButton = () -> Void

    var didTouchUpInsideClosure: DidTapButton? {
        didSet {
            if didTouchUpInsideClosure != nil {
                addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
            } else {
                removeTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
            }
        }
    }

    func didTouchUpInside() {
        if let handler = didTouchUpInsideClosure {
            handler()
        }
    }

}
