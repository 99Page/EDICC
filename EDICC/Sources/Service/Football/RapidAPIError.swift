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
enum RapidAPIError: Decodable {
    case empty              // [] 인 경우 (성공)
    case list([String: String]) // {...} 인 경우 (실패)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // 1. 딕셔너리(에러 메시지)로 시도
        if let dict = try? container.decode([String: String].self) {
            self = .list(dict)
            return
        }
        
        // 2. 배열(빈 배열)로 시도
        if let array = try? container.decode([String].self), array.isEmpty {
            self = .empty
            return
        }
        
        // 3. 둘 다 아니면 에러 처리 (혹은 .empty로 퉁치기)
        throw DecodingError.typeMismatch(
            RapidAPIError.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected dictionary or empty array")
        )
    }
}
