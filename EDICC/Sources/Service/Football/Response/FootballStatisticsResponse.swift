//
//  FootballSquadResponse.swift
//  EDICC
//
//  Created by 노우영 on 12/24/25.
//

import Foundation

struct FootballStatisticsResponse: Decodable {
    let get: String
    let errors: [[String: String]]?
    let results: Int
    let paging: RapidPagingDTO
    let response: [Response]
    
    static func manchesterUnited() -> FootballStatisticsResponse {
        FootballStatisticsResponse(
            get: "players/squads",
            errors: [[:]],
            results: 1,
            paging: .stub(),
            response: [.jaidonSancho(), .brunoFernandes()]
        )
    }
    
    struct Response: Decodable {
        let player: FootballPlayerDTO
        let statistics: [Statistic]
        
        static func jaidonSancho() -> Response {
            Response(player: FootballPlayerDTO.jaidonSancho(), statistics: [.manchesterUnited()])
        }
        
        static func brunoFernandes() -> Response {
            Response(player: FootballPlayerDTO.brunoFernandes(), statistics: [.manchesterUnited()])
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
        
        static func manchesterUnited() -> Statistic {
            Statistic(
                team: .manchesterUnited(),
                league: .premierLeague(),
                games: .stub,
                shots: .stub(),
                goals: .stub,
                passes: .stub(),
                duels: .stub(),
                dribbles: .stub(),
                fouls: .stub(),
                cards: .stub(),
                tackles: .stub
            )
        }
    }
    
    // MARK: - Tackles
    struct Tackles: Decodable {
        let total, blocks, interceptions: Int?
        
        static var stub: Tackles {
            let isDefensiveRole = Bool.random()
            
            if isDefensiveRole {
                // 🛡️ 수비형 선수: 태클, 블락, 인터셉트가 높음
                return Tackles(
                    total: Int.random(in: 40...130),       // 시즌 총 태클
                    blocks: Int.random(in: 15...50),       // 블락
                    interceptions: Int.random(in: 30...80) // 가로채기
                )
            } else {
                // 🏃 공격형 선수: 수비 지표가 상대적으로 낮음
                return Tackles(
                    total: Int.random(in: 5...35),
                    blocks: Int.random(in: 0...10),
                    interceptions: Int.random(in: 2...25)
                )
            }
        }
    }
    
    
    // MARK: - Cards
    struct Cards: Codable {
        let yellow, yellowred, red: Int?
        
        static func stub() -> Cards {
            Cards(yellow: 9, yellowred: nil, red: 0)
        }
    }
    
    // MARK: - Dribbles
    struct Dribbles: Codable {
        let attempts, success: Int?
        
        static func stub() -> Dribbles {
            Dribbles(attempts: 40, success: 19)
        }
    }
    
    // MARK: - Duels
    struct Duels: Codable {
        let total, won: Int?
        
        static func stub() -> Duels {
            Duels(total: 316, won: 136)
        }
    }
    
    // MARK: - Fouls
    struct Fouls: Codable {
        let drawn, committed: Int?
        
        static func stub() -> Fouls {
            Fouls(drawn: 28, committed: 41)
        }
    }
    
    // MARK: - Games
    struct Games: Codable {
        let appearences, lineups, minutes: Int?
        let position: String
        let rating: String?
        let captain: Bool
        
        static var stub: Games {
            let appearances = Int.random(in: 1...38)
            let lineups = Int.random(in: 15...appearances)
            
            let subAppearances = appearances - lineups
            let calculatedMinutes = (lineups * Int.random(in: 70...90)) + (subAppearances * Int.random(in: 10...30))
            
            let positions = ["Goalkeeper", "Defender", "Midfielder", "Attacker"]
            let position = positions.randomElement() ?? "Midfielder"
            
            let ratingValue = Double.random(in: 6.0...9.5)
            let ratingString = String(format: "%.6f", ratingValue)
            
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
        
        static var stub: Goals {
            let isGoalkeeper = Int.random(in: 1...10) <= 2
            
            if isGoalkeeper {
                return Goals(
                    total: 0,
                    conceded: Int.random(in: 20...60),
                    assists: Int.random(in: 0...2)
                )
            } else {
                return Goals(
                    total: Int.random(in: 0...35),
                    conceded: 0,
                    assists: Int.random(in: 0...20)   
                )
            }
        }
    }
    
    // MARK: - League
    struct League: Codable {
        let id: Int?
        let name: String
        let country: String?
        let logo: String?
        let flag: String?
        let season: Int
        
        static func premierLeague() -> League {
            League(
                id: FootballLeague.epl.id,
                name: "Premier League",
                country: "England",
                logo: "https://media.api-sports.io/football/leagues/39.png",
                flag: "https://media.api-sports.io/flags/gb-eng.svg",
                season: 2023
            )
        }
    }
    
    // MARK: - Passes
    struct Passes: Codable {
        let total, key: Int?
        
        static func stub() -> Passes {
            Passes(total: 1912, key: 116)
        }
    }
    
    
    // MARK: - Shots
    struct Shots: Decodable {
        let total, on: Int?
        
        static func stub() -> Shots {
            Shots(
                total: 68,
                on: 41
            )
        }
    }
    
    // MARK: - Team
    struct Team: Codable {
        let id: Int
        let name: String
        let logo: String
        
        static func manchesterUnited() -> Team {
            Team(id: 33, name: "Manchester United", logo: "https://media.api-sports.io/football/teams/33.png")
        }
    }
}

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
    
    static func jaidonSancho() -> FootballPlayerDTO {
        FootballPlayerDTO(
            id: 18,
            name: "J. Sancho",
            firstname: "Jadon Malik",
            lastname: "Sancho",
            age: 25,
            birth: BirthDTO(
                date: "2003-03-25",
                place: "London",
                country: "England",
            ),
            nationality: "England",
            height: "180",
            weight: "76",
            injured: false,
            photo: "https://media.api-sports.io/football/players/18.png"
        )
    }
    
    static func brunoFernandes() -> FootballPlayerDTO {
        FootballPlayerDTO(
            id: 1485,
            name: "Bruno Fernandes",
            firstname: "Bruno Miguel",
            lastname: "Borges Fernandes",
            age: 31,
            birth: BirthDTO(
                date: "1994-09-08",
                place: "Maia",
                country: "Portugal",
            ),
            nationality: "Portugal",
            height: "179",
            weight: "66",
            injured: false,
            photo: "https://media.api-sports.io/football/players/1485.png"
        )
    }
}

