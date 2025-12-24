//
//  FootballSquadResponse.swift
//  EDICC
//
//  Created by 노우영 on 12/24/25.
//

import Foundation

struct FootballSquadResponse: Decodable {
    let get: String
    let parameters: Parameters
    let errors: [String: String]
    let results: Int
    let paging: RapidPagingDTO
    let response: [Response]

    static func manchesterUnited() -> FootballSquadResponse {
        FootballSquadResponse(
            get: "players/squads",
            parameters: .stub(),
            errors: [:],
            results: 1,
            paging: .stub(),
            response: [.machesterUnited()]
        )
    }
    
    struct Response: Decodable {
        let team: TeamDTO
        let players: [FootballPlayerDTO]
        
        static func machesterUnited() -> Response {
            Response(team: .stub(), players: FootballPlayerDTO.stub())
        }
    }
    
    struct TeamDTO: Codable {
        let id: Int
        let name: String
        let logo: String
        
        static func stub() -> TeamDTO {
            TeamDTO(id: 33, name: "Manchester United", logo: "https://media.api-sports.io/football/teams/33.png")
        }
    }

    struct Parameters: Codable {
        let team: String
        
        static func stub() -> Parameters {
            Parameters(team: "manchester united")
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
    let name: String
    let age, number: Int
    let position: PositionDTO
    let photo: String
    
    static func diogoDalot() -> FootballPlayerDTO {
        FootballPlayerDTO(
            id: 886,
            name: "Diogo Dalot",
            age: 26,
            number: 2,
            position: .midfielder,
            photo: "https://media.api-sports.io/football/players/886.png"
        )
    }
    
    static func harryMaguire() -> FootballPlayerDTO {
        FootballPlayerDTO(
            id: 2935,
            name: "H. Maguire",
            age: 32,
            number: 5,
            position: .defender,
            photo: "https://media.api-sports.io/football/players/2935.png"
        )
    }
    
    static func stub() -> [FootballPlayerDTO] {
        [.diogoDalot(), .harryMaguire()]
    }
}
