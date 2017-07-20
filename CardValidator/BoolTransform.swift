//
//  BoolTransform.swift
//  CardValidator
//
//  Created by Eugene on 20.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import ObjectMapper

struct BoolTransform : TransformType{
    
    typealias JSON = String
    typealias Object = Bool
    
    func transformFromJSON(_ value: Any?) -> Bool?
    {
        guard let string = value as? String else {
            return nil
        }
        return Bool(string)
    }
    
    
    func transformToJSON(_ value: Bool?) -> String?
    {
        if let value = value {
            return String(value)
        }
        return nil
    }
}
