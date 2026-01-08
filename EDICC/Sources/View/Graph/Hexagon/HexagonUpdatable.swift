//
//  LegendUpdatable.swift
//  EDICC
//
//  Created by 노우영 on 12/29/25.
//

import Foundation

protocol HexagonUpdatable: AnyObject, Identifiable {
    var hexagonTarget: HexagonDataSet { get set }
    var hexagonModel: HexagonCardModel { get set }
    func updateHexagon(new: HexagonDataSet)
}

extension HexagonUpdatable {
    func updateHexagon(new: HexagonDataSet) {
        let old = hexagonTarget
        hexagonModel.chart.updateDataSet(old: old, new: new)
        hexagonTarget = new
    }
}
