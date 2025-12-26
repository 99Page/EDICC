//
//  FootballService.swift
//  EDICC
//
//  Created by 노우영 on 12/20/25.
//

import Foundation

struct FootballService {
    var fetchAvailableSeason: (_ teamID: Int) async throws -> AvailableSeasonResponse
    var fetchStatistics: (_ season: Int, _ teamID: Int) async throws -> FootballSquadResponse
}

extension FootballService {
    
    static let live = FootballService(
        fetchAvailableSeason: { teamID in
            let url = "https://v3.football.api-sports.io/teams/seasons"
            
            var result = try await GPD.build(url)
                .method(.get)
                .parameters(["team": teamID])
                .headers(APIConstants.rapidAPIHeader)
                .decoding(AvailableSeasonResponse.self)
                .request()
            
            result.response = result.response.filter { $0 == 2021 || $0 == 2022 || $0 == 2023 }
            
            return result
        }, fetchStatistics: { season, teamID in
            let url = "https://v3.football.api-sports.io/players?team=\(teamID)&season=\(season)"
            
            let response = try await GPD.build(url)
                .method(.get)
                .headers(APIConstants.rapidAPIHeader)
                .decoding(FootballSquadResponse.self)
                .request()
            
            return response
        }
    )
    
    static let preview = FootballService { _ in
        AvailableSeasonResponse(get: "", parameters: .init(team: "Liverpool"), errors: [], results: 0, paging: .init(current: 0, total: 0), response: [2020, 2021, 2022])
    } fetchStatistics: { _, _ in
            .manchesterUnited()
    }
}
