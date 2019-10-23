//
//  SearchViewModel.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation
import RealmSwift

enum SearchViewModelType {
    case update, error
}

protocol SearchViewModelProtocol {
    var results: Results<SearchResultEntity>? { get set }
    var loadingModels: [LoadingModel] { get set }
    var completionHandler: Callback<SearchViewModelType>? { get set }
    var searchService: SearchServiceProtocol { get set }

    func requestSerachImage(text: String?)
}

final class SearchViewModel: SearchViewModelProtocol {
    var searchService: SearchServiceProtocol

    var loadingModels: [LoadingModel] = []
    var results: Results<SearchResultEntity>?
    var completionHandler: Callback<SearchViewModelType>?

    private let realmManager = RealmManager.shared

    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
        loadDataFromDatabase()
    }

    private func handleRequestSearchImage(searchResults: SearchResults?, searchText: String) {
        guard let searchResult = searchResults?.results.randomElement() else {
            completionHandler?(.error)
            return
        }
        realmManager.create(SearchResultEntity(searchResult: searchResult, text: searchText))
        loadDataFromDatabase()
        completionHandler?(.update)
    }

    private func loadDataFromDatabase() {
        results = realmManager.realm?.objects(SearchResultEntity.self)
        if let results = results {
            loadingModels = LoadingModel.getLoadingModels(count: results.count)
        }
    }
}

extension SearchViewModel {
    func requestSerachImage(text: String?) {
        guard let searchText = text else { return }
        searchService.fetchImages(searchText: searchText) { [weak self] searchResults, error in
            guard error == nil else {
                self?.completionHandler?(.error)
                return
            }
            self?.handleRequestSearchImage(searchResults: searchResults, searchText: searchText)
        }
    }
}
