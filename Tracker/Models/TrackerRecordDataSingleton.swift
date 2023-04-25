//
//  TrackerRecordDataSingleton.swift
//  Tracker
//
//  Created by Артем Кохан on 19.04.2023.
//

import Foundation

final class TrackerCategoryData {
    static let shared = TrackerCategoryData()
    
    private init() { }
    
    var array: [TrackerCategory] = [
        TrackerCategory(title: "Домашний уют", trackers: TrackerData.shared.array),
        TrackerCategory(title: "Недомашний уют", trackers: TrackerData.shared.array),
        TrackerCategory(title: "Очень недомашний уют", trackers: TrackerData.shared.array)
    ]
}
