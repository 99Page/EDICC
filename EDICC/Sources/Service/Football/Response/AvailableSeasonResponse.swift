//
//  AvailableSeasonResponse.swift
//  EDICC
//
//  Created by 노우영 on 12/20/25.
//

import Foundation

struct AvailableSeasonResponse: Decodable {
    let get: String
    let parameters: Parameters
    let errors: [String]
    let results: Int
    let paging: Paging
    var response: [Int] // 무료 버전에는 접근 제한이 있습니다. 
    
    struct Paging: Decodable {
        let current, total: Int
    }

    struct Parameters: Codable {
        let team: String
    }
}
