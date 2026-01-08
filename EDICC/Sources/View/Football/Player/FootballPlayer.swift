//
//  FootballPlayer.swift
//  EDICC
//
//  Created by 노우영 on 12/26/25.
//

import Foundation

struct FootballPlayer: Identifiable {
    let id: Int
    let name: String
    let season: Int?
    let country: Country
    let position: FootballPosition?
    let imageURL: String?
    let stats: Stats
    var isLastItem = false
    var isPlaceholder = false
    
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
    
    static func placeholders(_ k: Int) -> [FootballPlayer] {
        var result: [FootballPlayer] = []
        
        (0..<k).forEach { _ in
            let randomId = Int.random(in: 0...Int.max)
            result.append(FootballPlayer(id: randomId, dto: .brunoFernandes23))
        }
        
        return result
    }
}

// MARK: Intializer
extension FootballPlayer {
    init(
        id: Int,
        name: String,
        country: Country,
        position: FootballPosition,
        imageURL: String?,
        season: Int,
        stats: Stats
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.position = position
        self.imageURL = imageURL
        self.stats = stats
        self.season = season
    }
    
    /// - Parameters:
    ///   - id: 플레이어의 고유 식별자(ID)를 수동으로 설정할 때 사용합니다.
    ///         이 값이 `nil`이 아니면 `dto` 내부의 ID 대신 사용됩니다. (주로 Mock 데이터 생성 시 유용)
    ///   - isPlaceholder: `true`로 설정 시, 실제 데이터가 아닌 로딩용 임시 객체로 취급됩니다. (기본값: `false`)
    ///   - dto: 서버 응답에서 파싱된 원시 플레이어 정보 및 통계 데이터(`Response`)입니다.
    init(id: Int? = nil, isPlaceholder: Bool = false, dto: FootballStatisticsResponse.Response) {
        
        if let id {
            self.id = id
        } else {
            self.id = dto.player.id
        }
        
        self.isPlaceholder = isPlaceholder
        self.name = dto.player.name
        self.country = .init(from: dto.player.nationality)
        self.imageURL = dto.player.photo
            
        let eplID = FootballLeague.epl.id
        let eplStats = dto.statistics.first { $0.league.id == eplID }
        
        if let eplGames = eplStats?.games, let eplStats {
            self.position = .init(from: eplGames)
            self.season = eplStats.league.season
            let general = Stats.General(eplGames)
            let attack = Stats.Attack(eplStats)
            let defense = Stats.Defense(eplStats)
            let stats = Stats(general: general, attack: attack, defense: defense)
            self.stats = stats
        } else {
            self.position = nil
            self.season = nil
            self.stats = Stats()
        }
    }
}

// MARK: AxisDifinable
extension FootballPlayer: AxisDefinable {
    var label: String {
        guard let season else { return name }
        
        let startYear = season % 100     // 2023 -> 23
        let endYear = (season + 1) % 100 // 2024 -> 24
        
        let seasonString = String(format: "%02d/%02d", startYear, endYear)
        
        return "\(name) (\(seasonString))"
    }
    
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
    
}

// MARK: Types
extension FootballPlayer {
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
