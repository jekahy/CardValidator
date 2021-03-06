//
//  CardValidationService.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation

class CardValidationService {

    private static let bincodesApiKey = "5232a9bca11e25c0f8eb4313ff2644be"
    static let requestParameters = ["format": "json",
                                    "api_key": bincodesApiKey]

    static func validateWithResult(_ card: CreditCard, api: APIProtocol,
                                   completion:@escaping(Result<Bool>) -> Void) {

        let params = generateParams(for: card)
        api.getJSON( parameters: params) { result in

            DispatchQueue.main.async {

                switch result {

                case .success(let json):

                    guard let validationRes = ValidationResult(JSON: json),
                        let isValid = validationRes.valid else {

                        completion(.failure(APIError.JSONSerializationError))
                        break
                    }

                    completion(.success(isValid))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    static func validate(_ card: CreditCard, api: APIProtocol, completion:@escaping(Bool) -> Void) {
        validateWithResult(card, api: api) { result in

            switch result {

            case .success(let isValid): completion(isValid)
            case .failure:              completion(false)
            }
        }
    }

    static func generateParams(for card: CreditCard)->[String:String] {
        var parameters = CardValidationService.requestParameters
        parameters["cc"] = card.number
        return parameters
    }

}
