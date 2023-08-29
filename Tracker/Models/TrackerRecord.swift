//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Артем Кохан on 05.04.2023.
//

import Foundation
/*
 сущность для хранения записи о том, что некий трекер был выполнен на некоторую дату;
 хранит id трекера, который был выполнен и дату.
 То есть, когда пользователь нажимает на + в ячейке трекера, мы создаём новую запись TrackerRecord — туда и запоминаем, какой трекер был выполнен в выбранную дату.
 В качестве типа данных для id рекомендуем использовать тип, который однозначно определяет уникальный идентификатор — например, UInt или UUID.
 Не используйте такие типы, как Float или Date!
 */

struct TrackerRecord: Hashable {
    let id: UUID
    let trackerId: UUID
    let completionDate: Date
    
    init(id: UUID = UUID(), trackerId: UUID, completionDate: Date) {
        self.id = id
        self.trackerId = trackerId
        self.completionDate = completionDate
    }
}
