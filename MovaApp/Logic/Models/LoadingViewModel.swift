//
//  LoadingViewModel.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

final class LoadingModel {
    var isLoading: Bool

    init(isLoading: Bool = false) {
        self.isLoading = isLoading
    }

    func setLoading(_ value: Bool) {
        isLoading = value
    }

    static func getLoadingModels(count: Int) -> [LoadingModel] {
        var loadingModels: [LoadingModel] = []
        for _ in 0 ..< count {
            loadingModels.append(LoadingModel())
        }
        return loadingModels
    }
}
