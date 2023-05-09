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
        TrackerCategory(
            title: "Домашний уют",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Убраться дома",
                    color: .blue,
                    emoji: "😀",
                    schedule: [.friday, .saturday, .tuesday]),
                Tracker(
                    id: UUID(),
                    name: "Помыть дома",
                    color: .brown,
                    emoji: "😃",
                    schedule: [.monday, .thursday, .friday]),
                Tracker(
                    id: UUID(),
                    name: "Пропылесосить дома",
                    color: .cyan,
                    emoji: "😄",
                    schedule: [.monday, .sunday])
            ]
        ),
        TrackerCategory(
            title: "Недомашний уют",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Навести уют",
                    color: .green,
                    emoji: "😁",
                    schedule: [.friday, .saturday, .tuesday]),
                Tracker(
                    id: UUID(),
                    name: "Проследить за уютом",
                    color: .magenta,
                    emoji: "😆",
                    schedule: [.monday, .thursday, .friday]),
                Tracker(
                    id: UUID(),
                    name: "Создать новый уют",
                    color: .orange,
                    emoji: "🥹",
                    schedule: [.monday, .sunday])
            ]
        ),
        TrackerCategory(
            title: "Очень недомашний уют",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Забить на все",
                    color: .purple,
                    emoji: "😅",
                    schedule: [.friday, .saturday, .tuesday]),
                Tracker(
                    id: UUID(),
                    name: "Неуспеть все",
                    color: .red,
                    emoji: "😂",
                    schedule: [.monday, .thursday, .friday]),
                Tracker(
                    id: UUID(),
                    name: "Забыть про все",
                    color: .systemPink,
                    emoji: "🤣",
                    schedule: [.monday, .sunday])
            ]
        )
    ]
}
