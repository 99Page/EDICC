//
//  ValueStandardizable.swift
//  EDICC
//
//  Created by 노우영 on 12/30/25.
//

import Foundation

protocol AxisDefinable {
    static var defaultRange: [String: ClosedRange<Double>] { get }
    static var customRange: [String: ClosedRange<Double>] { get set }
    static func range(for key: String) -> ClosedRange<Double>
    var label: String { get }
}

extension AxisDefinable {
    /// KeyPath를 사용하여 딕셔너리 아이템(Key, Value)을 생성하는 헬퍼
    /// 사용법: pair(\.rating, 0...10)
    static func pair<Root, V>(
        _ keyPath: KeyPath<Root, V>,
        _ range: ClosedRange<Double>
    ) -> (String, ClosedRange<Double>) {
        // 1. KeyPath에서 라벨 추출 ("rating")
        // 2. 소문자로 변환 (getter와 통일성을 위해)
        let key = keyPath.label.lowercased()
        return (key, range)
    }
    
    static func range(for key: String) -> ClosedRange<Double> {
        if let userValue = customRange[key.lowercased()] { return userValue }
        if let defaultValue = defaultRange[key.lowercased()] { return defaultValue }
        
#if DEBUG
        fatalError("🚨 '\(key)' 키에 대한 범위가 없습니다. defaultRange에 추가해주세요.")
#else
        // ⭐️ 배포 버전: 죽이면 안 되니까 안전빵 값 리턴 (혹은 로그 전송)
        return 0.0...100.0
#endif
    }
}
