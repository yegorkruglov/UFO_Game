//
//  Icons.swift
//  UFO_Game
//
//  Created by Egor Kruglov on 19.09.2023.
//

import Foundation

enum Icons {
    enum Player: String, CaseIterable, Codable {
        case player1
        case player2
        case player3
    }
    
    enum Enemy: String, CaseIterable, Codable {
        case enemy1
        case enemy2
        case enemy3
    }
    
    enum Bullet: String, CaseIterable, Codable {
        case bullet1
        case bullet2
        case bullet3
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
