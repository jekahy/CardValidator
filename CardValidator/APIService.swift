//
//  APIService.swift
//  CardValidator
//
//  Created by Eugene on 19.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation

typealias JSON = [String:Any]

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum APIError: Error, CustomStringConvertible {

    case noData
    case JSONSerializationError
    case failedToConstructURL
    case responseError(String)

    var description: String {
        switch self {
        case .noData:                   return "No data was received."
        case .JSONSerializationError:   return "Failed to serialize data."
        case .failedToConstructURL:     return "Failed to construct URL."
        case .responseError(let error): return "Received server error: \(error)"
        }
    }
}

protocol APIProtocol:class {

    var baseURL: URL {get}
    func getJSON(path: String, parameters: [String:String], completion:@escaping (Result<JSON>) -> Void)
    func getJSON(parameters: [String:String], completion:@escaping (Result<JSON>) -> Void)

}

class APIService: APIProtocol {

    struct HTTPMethod {
        static let GET = "GET"
        static let POST = "POST"
        static let DELETE = "DELETE"
    }

    let baseURL: URL

    init(baseURL: URL = APIService.defaultBaseURL) {

        self.baseURL = baseURL
    }

    func getJSON(parameters: [String:String], completion:@escaping (Result<JSON>) -> Void) {
        getJSON(path: "", parameters: parameters, completion: completion)
    }

    func getJSON(path: String, parameters: [String:String], completion:@escaping (Result<JSON>) -> Void) {
        let url = baseURL.appendingPathComponent(path)
        guard let fullURL = parameters.urlWithQueryParameters(url:url) else {
            completion(.failure(APIError.failedToConstructURL))
            return
        }

        let session = URLSession.shared

        var request = URLRequest(url: fullURL)
        request.httpMethod = HTTPMethod.DELETE

        session.dataTask(with: request) { data, _, error in

            guard  error==nil else {
                completion(.failure(error!))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            guard let serialiizedObj = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = serialiizedObj  as? JSON else {
        
                completion(.failure(APIError.JSONSerializationError))
                return
            }
            if let error = self.checkJSONForError(json) {
                completion(.failure(error))
            } else {
                completion(.success(json))
            }
        }.resume()

    }

    private func checkJSONForError(_ json: JSON) -> APIError? {
        if json["error"] != nil, let errorMessage = json["message"] as? String {

            return APIError.responseError(errorMessage)
        }
        return nil
    }
}

extension APIService {

    static let defaultBaseURL = URL(string: "https://api.bincodes.com/cc/")!

}
