//
//  SearchResults.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    let width: Int
    let height: Int
    let description: String?
    let likes: Int
    let urls: URLKing
    let user: User
}
struct User: Decodable {
    let id: String
    let username: String
    let name: String
}

struct URLKing: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
