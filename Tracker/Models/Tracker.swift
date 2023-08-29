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
    let schedule: [Weekday]?
    
    init(id: UUID = UUID(), name: String, emoji: String, color: UIColor, completedDaysCount: Int, schedule: [Weekday]?) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
        self.completedDaysCount = completedDaysCount
        self.schedule = schedule
    }
    
    init(tracker: Tracker) {
        self.id = tracker.id
        self.name = tracker.name
        self.emoji = tracker.emoji
        self.color = tracker.color
        self.completedDaysCount = tracker.completedDaysCount
        self.schedule = tracker.schedule
    }
    
    init(data: Data) {
        guard let emoji = data.emoji, let color = data.color else { fatalError() }
        
        self.id = UUID()
        self.name = data.name
        self.emoji = emoji
        self.color = color
        self.completedDaysCount = data.completedDaysCount
        self.schedule = data.schedule
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
        var schedule: [Weekday]? = nil
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
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресение"
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
