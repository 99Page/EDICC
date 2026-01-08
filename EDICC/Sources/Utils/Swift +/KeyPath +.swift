//
//  KeyPath +.swift
//  EDICC
//
//  Created by 노우영 on 12/30/25.
//

import Foundation

extension KeyPath {
    /// KeyPath의 프로퍼티 이름을 추출하여 UI 표시용 라벨(Title Case)로 변환합니다.
    ///
    /// Swift의 리플렉션(Mirroring) 기능을 이용하여 KeyPath의 문자열 경로를 파싱합니다.
    ///
    /// **변환 예시:**
    /// ```swift
    /// \Stats.attack.goals.label       // -> "Goals"
    /// \Stats.general.rating.label     // -> "Rating"
    /// \Stats.defense.duelsWon.label   // -> "DuelsWon" (주의: 띄어쓰기는 안 됨)
    /// ```
    ///
    /// - Note: 변수명이 곧 라벨이 되므로, `duelsWon` 같은 카멜케이스 변수는 "DuelsWon"으로 변환됩니다.
    var label: String {
        let stringPath = String(reflecting: self)
        
        guard let component = stringPath.components(separatedBy: ".").last else {
            return "Unknown"
        }
        
        return component.prefix(1).capitalized + component.dropFirst()
    }
}
