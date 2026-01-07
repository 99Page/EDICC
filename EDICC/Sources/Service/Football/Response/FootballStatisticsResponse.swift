//
//  FootballSquadResponse.swift
//  EDICC
//
//  Created by 노우영 on 12/24/25.
//

import Foundation

struct FootballStatisticsResponse: Decodable {
    let get: String
    let errors: RapidAPIError
    let results: Int
    let paging: RapidPagingDTO
    let response: [Response]
    
    static func manchesterUnitedRand() -> FootballStatisticsResponse {
        FootballStatisticsResponse(
            get: "players/squads",
            errors: .empty,
            results: 1,
            paging: .stub(),
            response: [.jaidonSanchoRand, .brunoFernandes23]
        )
    }
    
    static var manchersterUnited23: FootballStatisticsResponse {
        FootballStatisticsResponse(
            get: "players/squads",
            errors: .empty,
            results: 1,
            paging: .stub(),
            response: [.brunoFernandes23, .diogoDalot23]
        )
    }
    
    struct Response: Decodable {
        let player: FootballPlayerDTO
        let statistics: [Statistic]
        
        static var diogoDalot23: Response {
            Response(player: .diogoDalot, statistics: [.diogoDalot23])
        }
        
        static var brunoFernandes23: Response {
            Response(player: .brunoFernandes, statistics: [.brunoFernandes23])
        }
        
        static var jaidonSanchoRand: Response {
            Response(player: .jaidonSancho, statistics: [.manchesterUnited()])
        }
    }
    
    struct Statistic: Decodable {
        let team: Team
        let league: League
        let games: Games
        let shots: Shots
        let goals: Goals
        let passes: Passes
        let duels: Duels
        let dribbles: Dribbles
        let fouls: Fouls
        let cards: Cards
        let tackles: Tackles
        
        static var diogoDalot23: Statistic {
            Statistic(
                team: .manchesterUnited(),
                league: .premierLeague(),
                games: .diogoDalot23,
                shots: .diogoDalot23,
                goals: .diogoDalot23,
                passes: .diogoDalot23,
                duels: .diogoDalot23,
                dribbles: .diogoDalot23,
                fouls: .diogoDalot23,
                cards: .diogoDalot23,
                tackles: .diogoDalot23
            )
        }
        
        static var brunoFernandes23: Statistic {
            Statistic(
                team: .manchesterUnited(),
                league: .premierLeague(),
                games: .brunoFernandes23,
                shots: .brunoFernandes23,
                goals: .brunoFernandes23,
                passes: .brunoFernandes23,
                duels: .brunoFernandes23,
                dribbles: .brunoFernandes23,
                fouls: .brunoFernandes23,
                cards: .brunoFernandes23,
                tackles: .brunoFernandes23
            )
        }
        
        static func manchesterUnited() -> Statistic {
            Statistic(
                team: .manchesterUnited(),
                league: .premierLeague(),
                games: .stub,
                shots: .stub,
                goals: .stub,
                passes: .stub,
                duels: .stub,
                dribbles: .stub,
                fouls: .stub,
                cards: .stub,
                tackles: .stub
            )
        }
    }
    
    // MARK: - Tackles
    struct Tackles: Decodable {
        let total, blocks, interceptions: Int?
        
        static var brunoFernandes23: Tackles {
            Tackles(total: 68, blocks: 6, interceptions: 27)
        }
        
        static var diogoDalot23: Tackles {
            Tackles(total: 81, blocks: 16, interceptions: 37)
        }
        
        static var stub: Tackles {
            let isDefensive = Bool.random()
            return Tackles(
                total: isDefensive ? Int.random(in: 40...130) : Int.random(in: 5...35),
                blocks: isDefensive ? Int.random(in: 15...50) : Int.random(in: 0...10),
                interceptions: isDefensive ? Int.random(in: 30...80) : Int.random(in: 2...25)
            )
        }
    }
    
    // MARK: - Cards
    struct Cards: Codable {
        let yellow, yellowred, red: Int?
        
        static var brunoFernandes23: Cards {
            Cards(yellow: 9, yellowred: nil, red: 0)
        }
        
        static var diogoDalot23: Cards {
            Cards(yellow: 5, yellowred: 1, red: 0)
        }
        
        static var stub: Cards {
            Cards(
                yellow: Int.random(in: 0...10),
                yellowred: 0,
                red: Int.random(in: 0...1)
            )
        }
    }
    
    // MARK: - Dribbles
    struct Dribbles: Codable {
        let attempts, success: Int?
        
        static var brunoFernandes23: Dribbles {
            Dribbles(attempts: 40, success: 49)
        }
        
        static var diogoDalot23: Dribbles {
            Dribbles(attempts: 49, success: 31)
        }
        
        static var stub: Dribbles {
            let attempt = Int.random(in: 10...60)
            return Dribbles(
                attempts: attempt,
                success: Int.random(in: 0...attempt)
            )
        }
    }
    
    // MARK: - Duels
    struct Duels: Codable {
        let total, won: Int?
        
        static var brunoFernandes23: Duels {
            Duels(total: 316, won: 136)
        }
        
        static var diogoDalot23: Duels {
            Duels(total: 278, won: 158)
        }
        
        static var stub: Duels {
            let total = Int.random(in: 50...400)
            return Duels(
                total: total,
                won: Int.random(in: 0...total)
            )
        }
    }
    
    // MARK: - Fouls
    struct Fouls: Codable {
        let drawn, committed: Int?
        
        static var brunoFernandes23: Fouls {
            Fouls(drawn: 28, committed: 41)
        }
        
        static var diogoDalot23: Fouls {
            Fouls(drawn: 14, committed: 45)
        }
        
        static var stub: Fouls {
            Fouls(
                drawn: Int.random(in: 5...50),
                committed: Int.random(in: 5...50)
            )
        }
    }
    
    // MARK: - Games
    struct Games: Codable {
        let appearences, lineups, minutes: Int?
        let position: String
        let rating: String?
        let captain: Bool
        
        // UI에서 사용할 Double 타입 변환 속성
        var ratingValue: Double {
            return Double(rating ?? "0") ?? 0.0
        }
        
        static var brunoFernandes23: Games {
            Games(
                appearences: 35,
                lineups: 31,
                minutes: 3119,
                position: "Midfielder",
                rating: "7.780000",
                captain: false
            )
        }
        
        static var diogoDalot23: Games {
            Games(
                appearences: 36,
                lineups: 35,
                minutes: 3174,
                position: "Defender",
                rating: "7.108333",
                captain: false
            )
        }
        
        static var stub: Games {
            let appearances = Int.random(in: 15...38)
            let lineups = Int.random(in: 15...appearances)
            
            let subAppearances = appearances - lineups
            let calculatedMinutes = (lineups * Int.random(in: 70...90)) + (subAppearances * Int.random(in: 10...30))
            
            let positions = ["Goalkeeper", "Defender", "Midfielder", "Attacker"]
            let position = positions.randomElement() ?? "Midfielder"
            
            let ratingVal = Double.random(in: 6.0...9.5)
            let ratingString = String(format: "%.6f", ratingVal)
            
            return Games(
                appearences: appearances,
                lineups: lineups,
                minutes: calculatedMinutes,
                position: position,
                rating: ratingString,
                captain: Bool.random()
            )
        }
    }
    
    // MARK: - Goals
    struct Goals: Codable {
        let total, conceded, assists: Int?
        
        static var brunoFernandes23: Goals {
            Goals(total: 10, conceded: 0, assists: 8)
        }
        
        static var diogoDalot23: Goals {
            Goals(total: 2, conceded: 0, assists: 3)
        }
        
        static var stub: Goals {
            let isGoalkeeper = Int.random(in: 1...10) <= 2
            
            if isGoalkeeper {
                return Goals(total: 0, conceded: Int.random(in: 20...60), assists: Int.random(in: 0...1))
            } else {
                return Goals(total: Int.random(in: 0...35), conceded: 0, assists: Int.random(in: 0...20))
            }
        }
    }
    
    // MARK: - Passes
    struct Passes: Codable {
        let total, key: Int?
        
        static var brunoFernandes23: Passes {
            Passes(total: 1912, key: 116)
        }
        
        static var diogoDalot23: Passes {
            Passes(total: 1493, key: 38)
        }
        
        static var stub: Passes {
            let total = Int.random(in: 500...2500)
            return Passes(
                total: total,
                key: Int.random(in: 10...150)
            )
        }
    }
    
    // MARK: - Shots
    struct Shots: Decodable {
        let total, on: Int?
        
        static var brunoFernandes23: Shots {
            Shots(total: 68, on: 41)
        }
        
        static var diogoDalot23: Shots {
            Shots(total: 20, on: 7)
        }
        
        static var stub: Shots {
            let total = Int.random(in: 10...100)
            return Shots(
                total: total,
                on: Int.random(in: 0...total)
            )
        }
    }
    
    // MARK: - Helper Structs (League, Team)
    struct League: Codable {
        let id: Int?
        let name: String
        let country: String?
        let logo: String?
        let flag: String?
        let season: Int
        
        static func premierLeague() -> League {
            League(
                id: 39, // EPL ID correct
                name: "Premier League",
                country: "England",
                logo: "https://media.api-sports.io/football/leagues/39.png",
                flag: "https://media.api-sports.io/flags/gb-eng.svg",
                season: 2023
            )
        }
    }
    
    struct Team: Codable {
        let id: Int
        let name: String
        let logo: String
        
        static func manchesterUnited() -> Team {
            Team(id: 33, name: "Manchester United", logo: "https://media.api-sports.io/football/teams/33.png")
        }
    }
}

// MARK: - Outside DTO
struct FootballPlayerDTO: Decodable {
    let id: Int
    let name, firstname, lastname: String
    let age: Int
    let birth: BirthDTO
    let nationality: String
    let height, weight: String?
    let injured: Bool
    let photo: String
    
    struct BirthDTO: Decodable {
        let date: String
        let place: String?
        let country: String
    }
    
    static var diogoDalot: FootballPlayerDTO {
        FootballPlayerDTO(
            id: 886,
            name: "Diogo Dalot",
            firstname: "José Diogo",
            lastname: "Dalot Teixeira",
            age: 26,
            birth: BirthDTO(date: "1999-03-18", place: "Brage", country: "Portugal"),
            nationality: "Portugal",
            height: "183",
            weight: "78",
            injured: false,
            photo: "https://media.api-sports.io/football/players/886.png"
        )
    }
    
    static var jaidonSancho: FootballPlayerDTO {
        FootballPlayerDTO(
            id: 18,
            name: "J. Sancho",
            firstname: "Jadon Malik",
            lastname: "Sancho",
            age: 25,
            birth: BirthDTO(date: "2003-03-25", place: "London", country: "England"),
            nationality: "England",
            height: "180 cm",
            weight: "76 kg",
            injured: false,
            photo: "https://media.api-sports.io/football/players/18.png"
        )
    }
    
    static var brunoFernandes: FootballPlayerDTO {
        FootballPlayerDTO(
            id: 1485,
            name: "Bruno Fernandes",
            firstname: "Bruno Miguel",
            lastname: "Borges Fernandes",
            age: 31,
            birth: BirthDTO(date: "1994-09-08", place: "Maia", country: "Portugal"),
            nationality: "Portugal",
            height: "179 cm",
            weight: "66 kg",
            injured: false,
            photo: "https://media.api-sports.io/football/players/1485.png"
        )
    }
}
