//
//  UIViewExtensions.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import PureLayout

extension UIView:ViewProvidable {

    func autoMatchAll(to view: UIView) {
        self.autoMatch(.width, to: .width, of: view)
        self.autoMatch(.height, to: .height, of: view)
        self.autoAlignAxis(.horizontal, toSameAxisOf: view)
        self.autoAlignAxis(.vertical, toSameAxisOf: view)
    }

    var view: UIView {
        return self
    }

}
