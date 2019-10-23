//
//  RequestTarget.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

enum RequestTarget {
    case searchPhotos(text: String)
}

extension RequestTarget {
    enum HTTPMethod: String {
        case get, post, put, delete
    }

    var path: String {
        switch self {
        case .searchPhotos:
            return "/search/photos"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchPhotos:
            return .get
        }
    }

    var parameters: [String: String] {
        switch self {
        case let .searchPhotos(text):
            return [
                "query": text,
                "page": String(1),
                "per_page": String(30)
            ]
        }
    }
}
