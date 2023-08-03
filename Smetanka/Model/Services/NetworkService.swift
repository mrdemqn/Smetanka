//
//  NetworkService.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import Foundation

protocol NetworkServiceProtocol {
    
    func get<T: Codable>(_ type: T.Type,
                         link: String,
                         _ completion: @escaping (Result<T>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func get<T: Codable>(_: T.Type,
                         link: String,
                         _ completion: @escaping (Result<T>) -> Void) {
        guard let url = URL(string: link) else { return completion(.failure(.somethingWrong)) }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else { return completion(.failure(.somethingWrong, error)) }
            
            guard let data = data else { return completion(.failure(.somethingWrong)) }
            
            do {
                let decodedValue = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(decodedValue))
            } catch {
                
                completion(.failure(.somethingWrong, error))
            }
            
        }.resume()
    }
}
