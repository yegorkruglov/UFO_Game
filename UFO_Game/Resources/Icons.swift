//
//  Icons.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 19.09.2023.
//

import Foundation

enum Icons: CaseIterable {
    enum Player: String {
        case player1 = "player1"
        case player2 = "player2"
        case player3 = "player3"
    }
    
    enum Enemy: String {
        case enemy1 = "enemy1"
        case enemy2 = "enemy2"
        case enemy3 = "enemy3"
    }
    
    enum Bullet: String {
        case bullet1 = "bullet1"
        case bullet2 = "bullet2"
        case bullet3 = "bullet3"
    }
}
