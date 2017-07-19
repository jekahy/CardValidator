//
//  StringType.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

protocol StringType : Hashable {
    
    var value : String { get }
    
}

extension String : StringType {
    
    var value : String { return self }
    
}
