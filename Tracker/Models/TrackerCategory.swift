//
//  TrackerCategoryModel.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
/* сущность для хранения трекеров по категориям. Она имеет заголовок и содержит массив трекеров, относящихся к этой категории. */

struct TrackerCategory: Equatable {
    let id: UUID
    let title: String
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
    
    var data: Data {
        Data(id: id, title: title)
    }
}

extension TrackerCategory {
    struct Data {
        let id: UUID
        var title: String
        
        init(id: UUID? = nil, title: String = "") {
            self.id = id ?? UUID()
            self.title = title
        }
    }
}
