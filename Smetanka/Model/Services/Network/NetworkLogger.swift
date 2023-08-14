//
//  NetworkLogger.swift
//  Smetanka
//
//  Created by Димон on 11.08.23.
//

import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
    
    let queue = DispatchQueue(label: MultiThreading.networkLoggerQueue)
    
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request<Value>(_ request: DataRequest,
                        didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else { return }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(json)
        } catch {
            print("NetworkLoggerError: \(error)")
        }
    }
}
