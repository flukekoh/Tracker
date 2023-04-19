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
    let id: UInt
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]?
}

enum Weekday: String {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thurshday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
}
