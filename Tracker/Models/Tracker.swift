//
//  TrackerModel.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import UIKit

/* сущность для хранения информации про трекер (для «Привычки» или «Нерегулярного события»).
 У него есть уникальный идентификатор (id), название, цвет, эмоджи и распиcание.
 Структуру данных для хранения расписания выберите на своё усмотрение.
 */

struct Tracker: Identifiable {
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let completedDaysCount: Int
    let isPinned: Bool
    let category: TrackerCategory
    let schedule: [Weekday]?
    
    init(id: UUID = UUID(), name: String, emoji: String, color: UIColor, completedDaysCount: Int, isPinned:Bool, schedule: [Weekday]?, category: TrackerCategory) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
        self.completedDaysCount = completedDaysCount
        self.isPinned = isPinned
        self.schedule = schedule
        self.category = category
    }
    
    init(tracker: Tracker) {
        self.id = tracker.id
        self.name = tracker.name
        self.emoji = tracker.emoji
        self.color = tracker.color
        self.completedDaysCount = tracker.completedDaysCount
        self.isPinned = tracker.isPinned
        self.schedule = tracker.schedule
        self.category = tracker.category
    }
    
    init(data: Data) {
        guard let emoji = data.emoji, let color = data.color, let category = data.category else { fatalError() }
        
        self.id = UUID()
        self.name = data.name
        self.emoji = emoji
        self.color = color
        self.completedDaysCount = data.completedDaysCount
        self.isPinned = data.isPinned
        self.schedule = data.schedule
        self.category = category
    }
    
    var data: Data {
        Data(name: name, emoji: emoji, color: color, completedDaysCount: completedDaysCount, schedule: schedule)
    }
}

extension Tracker {
    struct Data {
        var name: String = ""
        var emoji: String? = nil
        var color: UIColor? = nil
        var completedDaysCount: Int = 0
        var isPinned: Bool = false
        var schedule: [Weekday]? = nil
        var category: TrackerCategory? = nil
    }
}

enum Weekday: String, CaseIterable, Comparable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var shortForm: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
    
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        guard
            let first = Self.allCases.firstIndex(of: lhs),
            let second = Self.allCases.firstIndex(of: rhs)
        else { return false }
        
        return first < second
    }
}

extension Weekday {
    static func code(_ weekdays: [Weekday]?) -> String? {
        guard let weekdays else { return nil }
        let indexes = weekdays.map { Self.allCases.firstIndex(of: $0) }
        var result = ""
        for i in 0..<7 {
            if indexes.contains(i) {
                result += "1"
            } else {
                result += "0"
            }
        }
        return result
    }
    
    static func decode(from string: String?) -> [Weekday]? {
        guard let string else { return nil }
        var weekdays = [Weekday]()
        for (index, value) in string.enumerated() {
            guard value == "1" else { continue }
            let weekday = Self.allCases[index]
            weekdays.append(weekday)
        }
        return weekdays
    }
}
