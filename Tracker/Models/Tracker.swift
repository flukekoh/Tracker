//
//  TrackerModel.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
import UIKit

/* сущность для хранения информации про трекер (для «Привычки» или «Нерегулярного события»).
У него есть уникальный идентификатор (id), название, цвет, эмоджи и распиcание.
Структуру данных для хранения расписания выберите на своё усмотрение.
*/
struct Tracker {
    let id: UInt
    let name: String
    let color: UIColor
    let emoji: Int
    let schedule: String
}
