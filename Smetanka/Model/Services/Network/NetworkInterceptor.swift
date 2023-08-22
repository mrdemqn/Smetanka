//
//  NetworkInterceptor.swift
//  Smetanka
//
//  Created by Димон on 11.08.23.
//

import Foundation
import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    
    private let retryLimit: Int = 5
    private let retryDelay: TimeInterval = 10
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue(ApiConstants.apiKeyValue, forHTTPHeaderField: ApiConstants.apiKeyHeaderField)
        urlRequest.setValue(ApiConstants.apiHostValue, forHTTPHeaderField: ApiConstants.apiHostHeaderField)
        urlRequest.setValue("EB81AD9F-3184-CFE4-5033-D3FCE339B411", forHTTPHeaderField: "MMT-ApiKey")
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        
        guard let statusCode = response?.statusCode, (500...599).contains(statusCode) else {
            return completion(.doNotRetry)
        }
        
        completion(.retryWithDelay(retryDelay))
    }
}
