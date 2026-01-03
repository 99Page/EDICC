//
//  HexagonCardModel.swift
//  EDICC
//
//  Created by 노우영 on 12/17/25.
//

import SwiftUI

@Observable
class HexagonCardModel {
    var chart: HexagonChartModel
    var selectedDataSet: HexagonDataSet?
    
    init(chart: HexagonChartModel = .mock()) {
        self.chart = chart
    }
    
    var bannedColors: Set<IdentifiableColor> {
        guard let selectedDataSet else { return [] }
        
        if selectedDataSet.id == chart.primary.id {
            return [chart.secondary.color]
        } else if selectedDataSet.id == chart.secondary.id {
            return [chart.primary.color]
        } else {
            return []
        }
    }
    
    var isPrimarySelected: Bool {
        selectedDataSet?.id == chart.primary.id
    }
}
