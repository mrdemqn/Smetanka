//
//  NetworkService.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    
    func get<T: Codable>(_ type: T.Type,
                         link: String,
                         headers: HTTPHeaders?) async throws -> T
    
    func translate(text translationText: String) async -> String
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        let responseCacher = ResponseCacher(behavior: .modify { task, cacheResponse in
            let userInfo = ["data": Date()]
            return CachedURLResponse(
                response: cacheResponse.response,
                data: cacheResponse.data,
                userInfo: userInfo,
                storagePolicy: .allowed)
        })
        
        let interceptor = NetworkInterceptor()
        let eventMonitor = NetworkLogger()
        
        return Session(configuration: configuration,
                       interceptor: interceptor,
                       cachedResponseHandler: responseCacher,
                       eventMonitors: [eventMonitor])
    }()
    
    
    func get<T: Codable>(_ type: T.Type,
                         link: String,
                         headers: HTTPHeaders? = nil) async throws -> T {
        
        let response = await session
            .request(link, headers: headers)
            .serializingDecodable(type, emptyRequestMethods: [.get])
            .response
        
        guard response.error == nil else { throw CustomError.somethingWrong }
        
        guard let foods = response.value else { throw CustomError.somethingWrong }

        return foods
    }
    
    func translate(text translationText: String) async -> String {
        
        let response = await session
            .request("https://api.modernmt.com/translate",
                     parameters: ["source": "en",
                                  "target": "ru",
                                  "q": translationText])
            .serializingDecodable(Translation.self)
            .response
        
        guard let translatedText = response.value?.data.translation else { return "" }
        
        return translatedText
    }
}
