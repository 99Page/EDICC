//
//  HexagonUpdate.swift
//  EDICC
//
//  Created by 노우영 on 12/29/25.
//

import Foundation

protocol HexagonMaker: AnyObject, Identifiable {
    var hexagonTarget: HexagonDataSet { get set }
    var legendChanged: (_ old: HexagonDataSet, _ new: HexagonDataSet) -> Void { get set }
    func updateHexagon(new: HexagonDataSet)
}

extension HexagonMaker {
    func updateHexagon(new: HexagonDataSet) {
        let old = hexagonTarget
        legendChanged(old, new)
        hexagonTarget = new
    }
}
