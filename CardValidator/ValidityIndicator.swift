//
//  ValidityIndicator.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit

class ValidityIndicator: UIView, Roundable {

    var invalidColor = UIColor.red
    var validColor = UIColor.green

    var isValid: Bool = false {
        didSet {
            backgroundColor = isValid ? validColor : invalidColor
        }
    }

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.lightGray
        self.roundCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
