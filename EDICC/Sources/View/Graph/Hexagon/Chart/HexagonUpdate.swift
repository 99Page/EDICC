//
//  HexagonUpdate.swift
//  EDICC
//
//  Created by 노우영 on 12/29/25.
//

import Foundation

protocol HexagonMaker {
    var hexagonTarget: HexagonDataSet { get }
    func makeHexagon() -> HexagonDataSet
}
