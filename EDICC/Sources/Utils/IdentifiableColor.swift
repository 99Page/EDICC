//
//  IdentifiableColor.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

/// ``SwiftUI.Color``를 `Identifiable` 및 `Hashable` 프로토콜을 준수하도록 래핑한 구조체입니다.
///
/// - Warning: `ForEach`와 같이 고유한 ID를 요구하는 뷰 빌더에서 사용할 때,
/// 배열 내에 동일한 색상이 중복되어 포함되면 **ID 충돌 경고**가 발생합니다.
struct IdentifiableColor: Identifiable, Hashable {
    var id: Color { value }
    var value: Color
}

extension IdentifiableColor {
    init(_ resource: ColorResource) {
        self.value = Color(resource)
    }
}
