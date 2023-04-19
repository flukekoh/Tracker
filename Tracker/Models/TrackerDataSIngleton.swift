//
//  TrackerDataSIngleton.swift
//  Tracker
//
//  Created by Артем Кохан on 18.04.2023.
//

import Foundation

final class TrackerData {
    static let shared = TrackerData()
    
    private init() { }
    
    var array: [Tracker] = [
        Tracker(id: 1, name: "Do smth", color: .systemYellow, emoji: "A", schedule: nil),
        Tracker(id: 2, name: "Next", color: .systemBlue, emoji: "B", schedule: nil),
        Tracker(id: 3, name: "Another", color: .systemGreen, emoji: "C", schedule: nil)
    ]
}
