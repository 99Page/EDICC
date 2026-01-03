//
//  HexagonChartModel.swift
//  EDICC
//
//  Created by 노우영 on 12/17/25.
//

import Foundation

@Observable
class HexagonChartModel {
    var primary: HexagonDataSet
    var secondary: HexagonDataSet
    
    var dataSets: [HexagonDataSet] {
        [primary, secondary]
    }
    
    var hasPoints: Bool {
        !primary.points.isEmpty && !secondary.points.isEmpty
    }
    
    var axisLabels: [String] {
        return primary.points.map { $0.label }
    }
    
    init(primary: HexagonDataSet, secondary: HexagonDataSet) {
        self.primary = primary
        self.secondary = secondary
    }
    
    func updateDataSet(old: HexagonDataSet, new: HexagonDataSet) {
        if primary.id == old.id {
            primary = new
        } else if secondary.id == old.id {
            secondary = new
        }
    }
}

extension HexagonChartModel {
    static func mock() -> HexagonChartModel {
        HexagonChartModel(primary: .mockPlayer(), secondary: .mockAverage())
    }
}

struct HexagonDataPoint: Identifiable, Equatable {
    
    var id: String { label }
    let label: String
    let rawValue: Double
    var range: ClosedRange<Double>
    
    init(label: String, rawValue: Double, range: ClosedRange<Double>) {
        self.label = label
        self.rawValue = rawValue
        self.range = range
    }
    
    init(label: String, rawValue: Double, value: AxisDefinable.Type) {
        self.label = label
        self.rawValue = rawValue
        self.range = value.range(for: label)
    }
    
    var normalizedValue: Double {
        let min = range.lowerBound
        let max = range.upperBound
        
        guard max > min else { return 0.0 }
        let ratio = (rawValue - min) / (max - min)
        return Swift.max(0.0, Swift.min(ratio, 1.0))
    }
    
    static func mockStiker() -> [HexagonDataPoint] {
        let range: ClosedRange<Double> = 0...1
        return [
            HexagonDataPoint(label: "PAC", rawValue: 0.92, range: range),
            HexagonDataPoint(label: "SHO", rawValue: 0.89, range: range),
            HexagonDataPoint(label: "PAS", rawValue: 0.81, range: range),
            HexagonDataPoint(label: "DRI", rawValue: 0.86, range: range),
            HexagonDataPoint(label: "DEF", rawValue: 0.35, range: range),
            HexagonDataPoint(label: "PHY", rawValue: 0.65, range: range)
        ]
    }
    
    static func mockMidfielder() -> [HexagonDataPoint] {
        let range: ClosedRange<Double> = 0...1
        return [
            HexagonDataPoint(label: "PAC", rawValue: 0.75, range: range),
            HexagonDataPoint(label: "SHO", rawValue: 0.70, range: range),
            HexagonDataPoint(label: "PAS", rawValue: 0.88, range: range),
            HexagonDataPoint(label: "DRI", rawValue: 0.82, range: range),
            HexagonDataPoint(label: "DEF", rawValue: 0.65, range: range),
            HexagonDataPoint(label: "PHY", rawValue: 0.78, range: range)
        ]
    }
}

struct HexagonDataSet: Identifiable, Equatable {
    let id: UUID
    let label: String
    var color: IdentifiableColor
    var points: [HexagonDataPoint]
    
    init(
        id: UUID = UUID(), // 기본값은 생성하지만, 복사 시에는 기존 ID를 넣을 수 있음
        label: String,
        color: IdentifiableColor,
        points: [HexagonDataPoint]
    ) {
        self.id = id
        self.label = label
        self.color = color
        self.points = points
    }
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
