//
//  EPLTeam.swift
//  EDICC
//
//  Created by 노우영 on 12/20/25.
//

import SwiftUI

enum EPLTeam: CaseIterable, Identifiable {
    case machesterUnited
    case tottenhamHotspur
    case liverpool
    
    
    // https://dashboard.api-football.com/soccer/ids/teams
    var id: Int {
        switch self {
        case .machesterUnited: 33
        case .tottenhamHotspur: 47
        case .liverpool: 40
        }
    }
    
    var name: String {
        switch self {
        case .machesterUnited: "맨체스터 유나이티드"
        case .tottenhamHotspur: "토트넘"
        case .liverpool: "리버풀"
        }
    }
    
    var color: Color {
        switch self {
        case .machesterUnited: Color(.footballRed)
        case .tottenhamHotspur: Color(.footballBlue)
        case .liverpool: Color(.footballRed)
        }
    }
}
