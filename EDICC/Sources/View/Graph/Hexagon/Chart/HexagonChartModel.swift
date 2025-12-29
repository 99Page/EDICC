//
//  HexagonChartModel.swift
//  EDICC
//
//  Created by 노우영 on 12/17/25.
//

import Foundation

@Observable
class HexagonChartModel {
    var dataSets: [HexagonDataSet]
    
    var axisLabels: [String] {
        return dataSets.first?.points.map { $0.label } ?? []
    }
    
    init(dataSets: [HexagonDataSet]) {
        self.dataSets = dataSets
    }
}

extension HexagonChartModel {
    static func mock() -> HexagonChartModel {
        HexagonChartModel(dataSets: [.mockPlayer() ,.mockAverage()])
    }
}

struct HexagonDataPoint: Identifiable, Equatable {
    let label: String
    var value: CGFloat
    
    // Identifiable 준수 (라벨을 ID로 사용)
    var id: String { label }
    
    static func mockStiker() -> [HexagonDataPoint] {
        return [
            HexagonDataPoint(label: "PAC", value: 0.92), // 속도
            HexagonDataPoint(label: "SHO", value: 0.89), // 슈팅
            HexagonDataPoint(label: "PAS", value: 0.81), // 패스
            HexagonDataPoint(label: "DRI", value: 0.86), // 드리블
            HexagonDataPoint(label: "DEF", value: 0.35), // 수비
            HexagonDataPoint(label: "PHY", value: 0.65)  // 피지컬
        ]
    }
    
    static func mockMidfielder() -> [HexagonDataPoint] {
        return [
            HexagonDataPoint(label: "PAC", value: 0.75),
            HexagonDataPoint(label: "SHO", value: 0.70),
            HexagonDataPoint(label: "PAS", value: 0.88),
            HexagonDataPoint(label: "DRI", value: 0.82),
            HexagonDataPoint(label: "DEF", value: 0.65),
            HexagonDataPoint(label: "PHY", value: 0.78)
        ]
    }
}

struct HexagonDataSet: Identifiable, Equatable {
    let id = UUID()
    let label: String
    var color: IdentifiableColor
    var points: [HexagonDataPoint]
}

extension HexagonDataSet {
    static func mockPlayer() -> HexagonDataSet {
        return HexagonDataSet(
            label: "Son (23/24)",
            color: IdentifiableColor(.creamyOrange),
            points: HexagonDataPoint.mockStiker()
        )
    }
    
    static func mockAverage() -> HexagonDataSet {
        return HexagonDataSet(
            label: "League Avg",
            color: IdentifiableColor(.softMint),
            points: HexagonDataPoint.mockMidfielder()
        )
    }
}
