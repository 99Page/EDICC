//
//  FootballPosition.swift
//  EDICC
//
//  Created by 노우영 on 12/26/25.
//

import Foundation

enum FootballPosition: String, CaseIterable {
    case all = "ALL"
    case fw = "FW"
    case mf = "MF"
    case df = "DF"
    case gk = "GK"
    
    init?(from games: FootballStatisticsResponse.Games) {
        switch games.position.lowercased() {
        case "defender":
            self = .df
        case "midfielder":
            self = .mf
        case "attacker":
            self = .fw
        case "goalkeeper":
            self = .gk
        default:
            return nil
        }
    }
}
