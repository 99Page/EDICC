//
//  HexagonChartRepresentableView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct HexagonChartView: UIViewRepresentable {
    
    let data: HexagonChartModel
    
    func makeUIView(context: Context) -> UIHexagonChartView {
        return UIHexagonChartView(data: data)
    }

    func updateUIView(_ uiView: UIHexagonChartView, context: Context) {

    }
}
