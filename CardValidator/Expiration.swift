//
//  Expiration.swift
//  CardValidator
//
//  Created by Eugene on 20.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

struct Expiration:Equatable {
    
    let month:String
    let year:String
    
    var singleString:String {
        return month + "/" + year
    }
    
    init?(string:String)
    {
        let components = string.components(separatedBy: "/")
        guard components.count == 2 else {return nil}
        
        let month = components[0]
        let year = components[1]
        guard month.characters.count == 2 && year.characters.count == 2 else {return nil}
        
        self.month = month
        self.year = year
    }
    
    static func ==(lhs: Expiration, rhs: Expiration) -> Bool
    {
        return lhs.singleString == rhs.singleString
    }
}
