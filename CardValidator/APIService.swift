//
//  APIService.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import ObjectMapper

typealias JSON = [String:Any]

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum APIError:String, Error{
    
    case noData = "No data was received."
    case JSONSerializationError = "Failed to serialize data."
    case failedToConstructURL = "Failed to construct URL."
}

protocol APIProtocol:class {
    
    var baseURL:URL{get}
    func getJSON(path:String, parameters:[String:String], completion:@escaping (Result<JSON>)->())
    func getJSON(parameters:[String:String], completion:@escaping (Result<JSON>)->())

}


class APIService:APIProtocol{
    
    struct HTTPMethod{
        static let GET = "GET"
        static let POST = "POST"
        static let DELETE = "DELETE"
    }
    
    let baseURL:URL
    
    init(baseURL:URL = APIService.defaultBaseURL) {
        
        self.baseURL = baseURL
    }
    
    func getJSON(parameters:[String:String], completion:@escaping (Result<JSON>)->())
    {
        getJSON(path: "", parameters: parameters, completion: completion)
    }

    func getJSON(path:String, parameters:[String:String], completion:@escaping (Result<JSON>)->())
    {
        let url = baseURL.appendingPathComponent(path)
        guard let fullURL = parameters.urlWithQueryParameters(url:url) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = HTTPMethod.DELETE
        
        session.dataTask(with: request) { data, response, error in
            
            
            guard  error==nil else {
                completion(.failure(error!))
                return
            }
            guard let data = data else{
                completion(.failure(APIError.noData))
                return
            }
            
            guard let serialiizedObj = try? JSONSerialization.jsonObject(with: data, options: []),let json = serialiizedObj  as? JSON else {
                completion(.failure(APIError.JSONSerializationError))
                return
            }
            
            completion(.success(json))
            
            
        }.resume()

    }
}

extension APIService {

    static let defaultBaseURL = URL(string: "https://api.bincodes.com/cc/")!

}
