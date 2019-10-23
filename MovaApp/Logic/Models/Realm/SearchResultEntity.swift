//
//  SearchResultEntity.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/23/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation
import RealmSwift

 @objcMembers class SearchResultEntity: Object {
    dynamic var text: String = ""
    dynamic var descriptions: String?
    dynamic var url: String = ""
    dynamic var likes: Int = 0

    convenience init(searchResult: SearchResult, text: String) {
        self.init()
        self.text = text
        self.descriptions = searchResult.description
        self.url = searchResult.urls.regular
        self.likes = searchResult.likes
    }
}
