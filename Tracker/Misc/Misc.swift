//
//  Misc.swift
//  Tracker
//
//  Created by Артем Кохан on 26.09.2023.
//

import Foundation

extension Array {
subscript(safe index: Int) -> Element? {
    guard index < endIndex, index >= startIndex else { return nil}
        return self[index]
    }
}
