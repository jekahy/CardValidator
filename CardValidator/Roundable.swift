//
//  Roundable.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit

protocol Roundable {}

extension Roundable where Self:UIView {

    func roundCorners(_ radius: CGFloat=10) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
