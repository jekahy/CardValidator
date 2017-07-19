//
//  CollectionExtensions.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation

extension Dictionary where Key: StringType, Value: StringType {
    
    func urlWithQueryParameters(url:URL)->URL?
    {
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = self.map{URLQueryItem(name: $0.key as! String, value: $0.value as? String)}
        return urlComponents.url
    }
}
