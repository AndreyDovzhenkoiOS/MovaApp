//
//  RequestProvider.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case badRequest
}

protocol RequestProviderProtocol {
   func request<T: Decodable>(target: RequestTarget, type: T.Type, completion: @escaping RequestResult<T?, Error?>)
}

final class RequestProvider: RequestProviderProtocol {

    func request<T: Decodable>(target: RequestTarget, type: T.Type, completion: @escaping RequestResult<T?, Error?>) {
        requestProvider(target: target) { [weak self] in
            switch $0 {
            case let .success(data):
                completion(self?.decode(type: type, from: data), nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    private func decode<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil }

        do {
            return try decoder.decode(type.self, from: data)
        } catch let error {
            print("Failed to decode JSON", error)
            return nil
        }
    }

    private func requestProvider(target: RequestTarget, completion: @escaping RequestResultProvider) {
        guard let url = baseUrl(target: target) else {
            return
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader
        request.httpMethod = target.method.rawValue

        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }

    private var prepareHeader: [String: String] {
        return ["Authorization": "Client-ID d827dbaf03c66be39d00de5b642859cb518415d24e83bcc991c1e0147503f5e1"]
    }

    private func baseUrl(target: RequestTarget) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = target.path
        components.queryItems = target.parameters.map { URLQueryItem(name: $0, value: $1) }
        print(components.url)
        return components.url
    }

    private func createDataTask(from request: URLRequest,
                                completion: @escaping RequestResultProvider) -> URLSessionDataTask {
         return URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }

                guard let data = data else {
                    completion(.failure(RequestError.badRequest))
                    return
                }

                completion(.success(data))
            }
         }
     }
}
