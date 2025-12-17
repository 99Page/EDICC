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
    var response: [Int]
    
    struct Paging: Decodable {
        let current, total: Int
    }

    struct Parameters: Codable {
        let team: String
    }
}
