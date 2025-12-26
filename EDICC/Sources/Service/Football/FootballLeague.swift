//
//  LeagueID.swift
//  EDICC
//
//  Created by 노우영 on 12/26/25.
//

import Foundation

enum FootballLeague {
    case epl
    
    // https://dashboard.api-football.com/soccer/ids
    var id: Int {
        switch self {
        case .epl: return 39
        }
    }
}
