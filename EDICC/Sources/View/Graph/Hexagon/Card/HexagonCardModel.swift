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
    
    init() {
        chart = HexagonChartModel.mock()
    }
    
    var unselectedColorSet: Set<IdentifiableColor> {
        guard let selectedDataSet else { return [] }
        
        if selectedDataSet == chart.primary {
            return [chart.secondary.color]
        } else {
            return [chart.primary.color]
        }
    }
}
