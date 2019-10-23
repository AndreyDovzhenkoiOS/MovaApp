//
//  RealmManager.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/23/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

final class RealmManager {
    static let shared = RealmManager()

    var realm = try? Realm()

    private init() { }

    func create<T: Object>(_ object: T) {
        do {
            try realm?.write {
                realm?.add(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
