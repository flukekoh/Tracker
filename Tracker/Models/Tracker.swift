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
struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
}

enum Weekday: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var description: String {
        switch self {
        case .sunday:
            return "Воскресенье"
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
        }
    }
}
