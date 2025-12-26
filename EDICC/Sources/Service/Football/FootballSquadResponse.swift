//
//  FootballSquadResponse.swift
//  EDICC
//
//  Created by 노우영 on 12/24/25.
//

import Foundation

struct FootballSquadResponse: Decodable {
    let get: String
    let errors: [[String: String]]?
    let results: Int
    let paging: RapidPagingDTO
    let response: [Response]
    
    static func manchesterUnited() -> FootballSquadResponse {
        FootballSquadResponse(
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
        
        var eplStatistic: Statistic? {
            statistics.first { $0.league.id == FootballLeague.epl.id }
        }
        
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
        
        static func manchesterUnited() -> Statistic {
            Statistic(
                team: .manchesterUnited(),
                league: .premierLeague(),
                games: .stub(),
                shots: .stub(),
                goals: .stub(),
                passes: .stub(),
                duels: .stub(),
                dribbles: .stub(),
                fouls: .stub(),
                cards: .stub()
            )
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
        
        static func stub() -> Games {
            Games(
                appearences: 35,
                lineups: 35,
                minutes: 3119,
                position: "Midfielder",
                rating: "7.780000",
                captain: false
            )
        }
    }

    // MARK: - Goals
    struct Goals: Codable {
        let total, conceded, assists: Int?
        
        static func stub() -> Goals {
            Goals(total: 8, conceded: 0, assists: 8)
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
            Team(id: 33, name: "Mancherster United", logo: "https://media.api-sports.io/football/teams/33.png")
        }
    }
}

enum PositionDTO: String, Codable {
    case attacker = "Attacker"
    case defender = "Defender"
    case goalkeeper = "Goalkeeper"
    case midfielder = "Midfielder"
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

