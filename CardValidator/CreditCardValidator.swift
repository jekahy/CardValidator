//
//  CreditCardValidator.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation

protocol CreditCardValidatable {
    
    static func validate(_ card:CreditCard, api:APIProtocol, completion:@escaping(Result<Bool>)->())

}

class CreditCardValidationService:CreditCardValidatable{
    
    private static let bincodesApiKey = "5232a9bca11e25c0f8eb4313ff2644be"
    static let requestParameters = ["format":"json",
                                    "api_key":bincodesApiKey]
                                    
    
    static func validate(_ card:CreditCard, api:APIProtocol, completion:@escaping(Result<Bool>)->())
    {
        
        let params = generateParams(for: card)
        api.getJSON( parameters: params) { result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let json):
                    guard let validationRes = ValidationResult(JSON: json) else {
                        completion(.failure(APIError.JSONSerializationError))
                        break
                    }
                    completion(.success(validationRes.valid))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func generateParams(for card:CreditCard)->[String:String]
    {
        var parameters = CreditCardValidationService.requestParameters
        parameters["cc"] = card.number
        return parameters
    }
    
}
