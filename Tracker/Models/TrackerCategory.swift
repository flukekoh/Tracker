//
//  TrackerCategoryModel.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
/* сущность для хранения трекеров по категориям. Она имеет заголовок и содержит массив трекеров, относящихся к этой категории. */
struct TrackerCategory {
    let title: String
    var trackers: [Tracker]
}
