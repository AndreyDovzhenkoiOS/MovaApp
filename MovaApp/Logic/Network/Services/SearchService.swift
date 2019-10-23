//
//  SearchService.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/23/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

protocol SearchServiceProtocol {
    func getImage(_ url: URL, completion: @escaping Callback<UIImage>)
    func fetchImages(searchText: String, completion: @escaping RequestResult<SearchResults?, Error?>)
}

final class SearchService: SearchServiceProtocol {

    private let provider: RequestProviderProtocol
    private let cache = NSCache <NSString, UIImage>()

    init(provider: RequestProviderProtocol) {
        self.provider = provider
    }

    func fetchImages(searchText: String, completion: @escaping RequestResult<SearchResults?, Error?>) {
        provider.request(target:
            .searchPhotos(text: searchText),
                         type: SearchResults.self,
                         completion: completion)
    }

    func getImage(_ url: URL, completion: @escaping Callback<UIImage>) {
        if let image = cache.object(forKey: (url.absoluteString) as NSString) {
            completion(image)
        } else {
            downloadImage(url, completion: completion)
        }
    }

    private func downloadImage(_ url: URL, completion: @escaping Callback<UIImage>) {
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let downloadImage = UIImage(data: data) else {
                return
            }
            self?.cache.setObject(downloadImage, forKey: (url.absoluteString) as NSString )
            DispatchQueue.main.async {
                completion(downloadImage)
            }
        }
        dataTask.resume()
    }
}
