//
//  File.swift
//  EDICC
//
//  Created by 노우영 on 12/11/25.
//

import Foundation
import UIKit
import SnapKit

class HexagonChartView: UIView {
    
    var hexagonViews = [HexagonView]()
    let hexagonIterations = 3
    let data: ChartData
    
    init(data: ChartData) {
        self.data = data
        super.init(frame: .zero)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor(resource: .hexagonBackground)
    }
    
    func makeConstraints() {
        for i in 1...hexagonIterations {
            let hexagonView = HexagonView()
            hexagonViews.append(hexagonView)
            addSubview(hexagonView)
            let mutiplier = Double(i) / Double(hexagonIterations)
            hexagonView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.width.height.equalToSuperview().multipliedBy(mutiplier)
            }
        }
    }
    
    struct DataSet {
        let label: String?       // 데이터 세트 이름 (예: "Player A")
        let values: [CGFloat]    // 축 값 (0.0 ~ 1.0)
    }

    // 2. 차트 전체 데이터 구조 (축 레이블과 데이터 세트 배열 포함)
    struct ChartData {
        let axisLabels: [String]    // 6개 축 이름
        let dataSets: [DataSet]     // 비교할 데이터 세트 배열 (최소 2개)
    }
}

#Preview {
    let dataSet1 = HexagonChartView.DataSet(
        label: nil,
        values: [0.5, 0.3, 0.7, 0.5, 0.7, 0.1]
    )
    
    let dataSet2 = HexagonChartView.DataSet(
        label: nil,
        values: [0.2, 0.5, 0.65, 0.9, 0.8, 0.4]
    )
    
    let chart = HexagonChartView.ChartData(
        axisLabels: ["A", "B", "C", "D", "E", "F"],
        dataSets: [dataSet1, dataSet2]
    )
    
    HexagonChartView(data: chart)
}
