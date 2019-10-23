//
//  Typealiases.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/22/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation

typealias Localized = L10n

typealias VoidCallback = () -> Void
typealias Callback<T> = (T) -> Void
typealias RequestResult<T, E> = (T, E) -> Void
typealias RequestResultProvider = (Swift.Result<Data, Error>) -> Void
