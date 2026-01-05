//
//  FootballService.swift
//  EDICC
//
//  Created by 노우영 on 12/20/25.
//

import Foundation

struct FootballService {
    var fetchAvailableSeason: (_ teamID: Int) async throws -> AvailableSeasonResponse
    var fetchStatistics: (_ param: StatisticsParameters) async throws -> FootballStatisticsResponse
    
    struct StatisticsParameters {
        let season: Int
        let teamID: Int
        let page: Int
    }
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
            
        }, fetchStatistics: { param in
            let url = "https://v3.football.api-sports.io/players"
            
            let response = try await GPD.build(url)
                .method(.get)
                .parameters([
                    "team": param.teamID,
                    "season": param.season,
                    "page": param.page
                ])
                .headers(APIConstants.rapidAPIHeader)
                .decoding(FootballStatisticsResponse.self)
                .request()
            
            return response
        }
    )
    
    static let preview = FootballService { _ in
        AvailableSeasonResponse(
            get: "teams/seasons",
            parameters: .init(team: "Liverpool"),
            errors: [],
            results: 3,
            paging: .init(current: 1, total: 1),
            response: [2022, 2023, 2024]
        )
    } fetchStatistics: { _ in
            .manchesterUnitedRand()
    }
    
    static let failure = FootballService { _ in
        throw RapidAPIError.list([:])
    } fetchStatistics: { _ in
        throw RapidAPIError.list([:])
    }
}
