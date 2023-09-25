//
//  Difficulty.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 19.09.2023.
//

import Foundation

enum Difficulty: Double, CaseIterable, Codable {
    case easy = 0.5
    case normal = 1
    case extreme = 2
    
    var name: String {
        switch self {
        case .easy:
            return "EASY"
        case .normal:
            return "NORMAL"
        case .extreme:
            return "EXTREME"
        }
    }
}
