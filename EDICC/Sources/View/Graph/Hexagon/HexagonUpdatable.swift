//
//  LegendUpdatable.swift
//  EDICC
//
//  Created by 노우영 on 12/29/25.
//

import Foundation

protocol HexagonUpdatable: AnyObject, Identifiable {
    var hexagonTarget: HexagonDataSet { get set }
    var onLegendChanged: (_ old: HexagonDataSet, _ new: HexagonDataSet) -> Void { get set }
    func updateHexagon(new: HexagonDataSet)
}

extension HexagonUpdatable {
    func updateHexagon(new: HexagonDataSet) {
        let old = hexagonTarget
        onLegendChanged(old, new)
        hexagonTarget = new
    }
}
