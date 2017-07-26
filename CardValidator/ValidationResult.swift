//
//  ValidationResult.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import ObjectMapper

struct ValidationResult: Mappable {

    var bank: String?
    var card: String?
    var valid: Bool? = false

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        valid<-(map["valid"], BoolTransform())
        bank<-map["bank"]
        card<-map["card"]
    }
}
