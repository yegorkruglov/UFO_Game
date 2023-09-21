//
//  Icons.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 19.09.2023.
//

import Foundation

enum Icons {
    enum Player: String, CaseIterable {
        case player1 = "player1"
        case player2 = "player2"
        case player3 = "player3"
    }
    
    enum Enemy: String, CaseIterable {
        case enemy1 = "enemy1"
        case enemy2 = "enemy2"
        case enemy3 = "enemy3"
    }
    
    enum Bullet: String, CaseIterable {
        case bullet1 = "bullet1"
        case bullet2 = "bullet2"
        case bullet3 = "bullet3"
    }
    
    static var allPlayers: [String] {
        var players: [String] = []
        for item in Icons.Player.allCases {
            players.append(item.rawValue)
        }
        
        return players
    }
    
    static var allEnemies: [String] {
        var enemies: [String] = []
        for item in Icons.Enemy.allCases {
            enemies.append(item.rawValue)
        }
        
        return enemies
    }
    
    static var allBullets: [String] {
        var bullets: [String] = []
        for item in Icons.Bullet.allCases {
            bullets.append(item.rawValue)
        }
        
        return bullets
    }
    
    static var allIconTypes = [allPlayers, allEnemies, allBullets]
}
