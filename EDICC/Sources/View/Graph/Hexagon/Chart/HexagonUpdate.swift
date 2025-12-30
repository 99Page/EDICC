//
//  HexagonUpdate.swift
//  EDICC
//
//  Created by 노우영 on 12/29/25.
//

import Foundation

protocol HexagonMaker: Identifiable {
    var hexagonTarget: HexagonDataSet { get }
    var legendChanged: (_ old: HexagonDataSet, _ new: HexagonDataSet) -> Void { get set }
    func makeHexagon() -> HexagonDataSet
}
