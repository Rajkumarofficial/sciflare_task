//
//  APIManager.swift
//  Scifalre_Task
//
//  Created by mac on 27/05/24.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias StatusServiceResponse = (Bool, String, JSON) -> Void

var Service = APIManager()

class APIManager {
    
    func GetRequest(url: String, completionHandler: @escaping StatusServiceResponse) throws {
        try makeRequest(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, completion: completionHandler)
    }
    func PostRequest(url: String, parameter: [String: Any], completionHandler: @escaping StatusServiceResponse) throws {
        try makeRequest(url: url, method: .post, parameters: parameter, encoding: JSONEncoding.default, completion: completionHandler)
    }
    func PutRequest(url: String, parameter: Parameters, completionHandler: @escaping StatusServiceResponse) throws {
        try makeRequest(url: url, method: .put, parameters: parameter, encoding: URLEncoding.default, completion: completionHandler)
    }
    
    private func makeRequest(url: String,method: HTTPMethod,parameters: Parameters?, encoding: ParameterEncoding, completion: @escaping StatusServiceResponse) throws {
        print("Making request to URL: \(url) with method: \(method) and parameters: \(parameters ?? [:])")
        AF.request(url, method: method,parameters: parameters, encoding: encoding)
            .response { response in
                switch response.result {
                    case .success(let value):
                        
                        if let data = value {
                            let json = JSON(data)
                            print("JSON Response:", json)
                            let message = json["message"].stringValue
                            completion(true, message, json)
                        }
                    case .failure(let error):
                        print("Request failed with error:", error.localizedDescription)
                        self.handleAPIError(error, completion: completion)
                }
            }
    }
    private func handleAPIError(_ error: Error, completion: @escaping StatusServiceResponse) {
        if let afError = error as? AFError {
            let errorMessage: String
            switch afError {
                case .responseValidationFailed(let reason):
                    errorMessage = "Response validation failed: \(reason)"
                case .invalidURL(let url):
                    errorMessage = "Invalid URL: \(url)"
                case .responseSerializationFailed(let reason):
                    errorMessage = "Response serialization failed: \(reason)"
                default:
                    errorMessage = "Request failed: \(afError.localizedDescription)"
            }
            completion(false, errorMessage, JSON.null)
        } else {
            print("Non-AFError: \(error.localizedDescription)")
            completion(false, error.localizedDescription, JSON.null)
        }
    }
}

