//
//  FootballService.swift
//  EDICC
//
//  Created by 노우영 on 12/20/25.
//

import Foundation

struct FootballService {
    var fetchAvailableSeason: (_ teamID: Int) async throws -> AvailableSeasonResponse
    var fetchStatistics: (_ season: Int, _ teamID: Int) async throws -> FootballStatisticsResponse
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
            
            // API 제한에 맞춰 21, 22, 23년만 필터링
            let allowedSeasons = [2021, 2022, 2023]
            
            result.response = result.response
                .filter { allowedSeasons.contains($0) } // 허용된 시즌만 남김
                .sorted(by: >) // 2023 -> 2022 -> 2021 (최신순 정렬)
            
            return result
            
        }, fetchStatistics: { season, teamID in
            let url = "https://v3.football.api-sports.io/players"
            
            let response = try await GPD.build(url)
                .method(.get)
                .parameters([
                    "team": teamID,
                    "season": season,
                    "page": 1 // 명시적으로 1페이지 요청
                ])
                .headers(APIConstants.rapidAPIHeader)
                .decoding(FootballStatisticsResponse.self)
                .request()
            
            return response
        }
    )
    
    // Preview Mock Data
    static let preview = FootballService { _ in
        AvailableSeasonResponse(
            get: "teams/seasons",
            parameters: .init(team: "Liverpool"),
            errors: [],
            results: 3,
            paging: .init(current: 1, total: 1),
            response: [2022, 2023, 2024]
        )
    } fetchStatistics: { _, _ in
            .manchesterUnited()
    }
}
