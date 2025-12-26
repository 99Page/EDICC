//
//  RapidPagingDTO.swift
//  EDICC
//
//  Created by 노우영 on 12/24/25.
//

import Foundation

struct RapidPagingDTO: Decodable {
    let current, total: Int
    
    static func stub() -> RapidPagingDTO {
        RapidPagingDTO(current: 1, total: 1)
    }
}
