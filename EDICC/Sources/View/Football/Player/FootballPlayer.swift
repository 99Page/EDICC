//
//  FootballPlayer.swift
//  EDICC
//
//  Created by 노우영 on 12/26/25.
//

import Foundation

struct FootballPlayer: Identifiable, AxisDefinable {
    static var defaultRange: [String : ClosedRange<Double>] = Dictionary(
        uniqueKeysWithValues: [
            pair(\FootballPlayer.Stats.General.rating, 0...10),
            pair(\FootballPlayer.Stats.General.minutes, 0...3600),
            pair(\FootballPlayer.Stats.Attack.goals, 0...35),
            pair(\FootballPlayer.Stats.Attack.assists, 0...20),
            pair(\FootballPlayer.Stats.Defense.blocks, 0...50),
            pair(\FootballPlayer.Stats.Defense.interceptions, 0...70),
        ]
    )
    
    static var customRange: [String : ClosedRange<Double>] = {
        return defaultRange
    }()
    
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
    
    var label: String { name }
    
    func hexagonPoints<T: AxisDefinable>(standard: T.Type) -> [HexagonDataPoint] {
        [
            HexagonDataPoint(
                label: (\FootballPlayer.Stats.General.rating).label,
                rawValue: stats.general.rating,
                value: T.self
            ),
            HexagonDataPoint(
                label: (\FootballPlayer.Stats.General.minutes).label,
                rawValue: Double(stats.general.minutes),
                value: T.self
            ),
            HexagonDataPoint(
                label: (\FootballPlayer.Stats.Attack.goals).label,
                rawValue: Double(stats.attack.goals),
                value: T.self
            ),
            HexagonDataPoint(
                label: (\FootballPlayer.Stats.Attack.assists).label,
                rawValue: Double(stats.attack.assists),
                value: T.self
            ),
            HexagonDataPoint(
                label: (\FootballPlayer.Stats.Defense.blocks).label,
                rawValue: Double(stats.defense.blocks),
                value: T.self
            ),
            HexagonDataPoint(
                label: (\FootballPlayer.Stats.Defense.interceptions).label,
                rawValue: Double(stats.defense.interceptions),
                value: T.self
            ),
        ]
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
