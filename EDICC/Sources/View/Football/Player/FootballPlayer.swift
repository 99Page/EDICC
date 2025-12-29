//
//  FootballPlayer.swift
//  EDICC
//
//  Created by 노우영 on 12/26/25.
//

import Foundation

struct FootballPlayer: Identifiable {
    let id = UUID()
    let name: String
    let country: Country
    let position: FootballPosition?
    let imageURL: String?
    let stats: Stats
    
    init(
        name: String,
        country: Country,
        position: FootballPosition,
        imageURL: String?,
        stats: Stats
    ) {
        self.name = name
        self.country = country
        self.position = position
        self.imageURL = imageURL
        self.stats = stats
    }
    
    init(dto: FootballStatisticsResponse.Response) {
        self.name = dto.player.name
        self.country = .init(from: dto.player.nationality)
        
        let eplID = FootballLeague.epl.id
        let eplStats = dto.statistics.first { $0.league.id == eplID }
        
        if let eplGames = eplStats?.games, let eplStats {
            self.position = .init(from: eplGames)
            let general = Stats.General(eplGames)
            let attack = Stats.Attack(eplStats)
            let defense = Stats.Defense(eplStats)
            let stats = Stats(general: general, attack: attack, defense: defense)
            self.stats = stats
        } else {
            self.position = nil
            self.stats = Stats()
        }
        
        self.imageURL = dto.player.photo
    }
    

    struct Stats {
        let general: General
        let attack: Attack
        let defense: Defense
        
        init(
            general: General = General(),
            attack: Attack = Attack(),
            defense: Defense = Defense()
        ) {
            self.general = general
            self.attack = attack
            self.defense = defense
        }
        
        struct General {
            let minutes: Int
            let rating: Double
            
            init(minutes: Int = 0, rating: Double = 0) {
                self.minutes = minutes
                self.rating = rating
            }
            
            init(_ dto: FootballStatisticsResponse.Games) {
                self.minutes = dto.minutes ?? 0
                self.rating = Double(dto.rating ?? "0") ?? 0
            }
        }
        
        struct Attack {
            let goals: Int
            let assists: Int
            
            init(goals: Int = 0, assists: Int = 0) {
                self.goals = goals
                self.assists = assists
            }
            
            init(_ dto: FootballStatisticsResponse.Statistic) {
                self.goals = dto.goals.total ?? 0
                self.assists = dto.goals.assists ?? 0
            }
        }
        
        struct Defense {
            let duelsWon: Int
            let interceptions: Int
            let blocks: Int
            
            init(duelsWon: Int = 0, interceptions: Int = 0, blocks: Int = 0) {
                self.duelsWon = duelsWon
                self.interceptions = interceptions
                self.blocks = blocks
            }
            
            init(_ dto: FootballStatisticsResponse.Statistic) {
                self.duelsWon = dto.duels.won ?? 0
                self.interceptions = dto.tackles.interceptions ?? 0
                self.blocks = dto.tackles.blocks ?? 0
            }
        }
    }
}
