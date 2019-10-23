//
//  ViewControllerAssembly.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/23/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

enum ViewControllerType {
    case search
}

struct ViewControllerAssembly {
    static func resolve(type: ViewControllerType) -> UIViewController {
        switch type {
        case .search:
            let service = SearchService(provider: RequestProvider())
            let viewModel = SearchViewModel(searchService: service)
            return SearchViewController(viewModel: viewModel)
        }
    }
}
