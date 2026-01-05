//
//  RapidError.swift
//  EDICC
//
//  Created by 노우영 on 1/4/26.
//

import Foundation

/// https://dashboard.api-football.com 에서 제공하는 에러를 처리하는 타입
///
/// 에러가 없는 경우 빈 배열이 오고, 에러이 있는 경우 key, value가 오는 형태
///
/// ```
///  "errors": [] // 성공 시
///
///  "errors": {
///      "plan": "Free plans are limited to a maximum value of 3 for the Page parameter"
///   }
///  ```
///
enum RapidAPIError: Decodable, Error {
    case empty
    case list([String: String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // Dictionary로 디코딩 된다면 에러 발생하는 상황
        if let dict = try? container.decode([String: String].self) {
            throw RapidAPIError.list(dict)
        }
        
        if let array = try? container.decode([String].self), array.isEmpty {
            self = .empty
            return
        }
        
        throw DecodingError.typeMismatch(
            RapidAPIError.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected dictionary or empty array")
        )
    }
}
