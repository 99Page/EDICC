//
//  File.swift
//  EDICC
//
//  Created by 노우영 on 12/11/25.
//

import Foundation
import UIKit

class HexagonChartView: UIView {
    var hexagonViews = [HexagonView]()
    
    init() {
        super.init(frame: .zero)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        for i in 0..<5 {
            let hexagonView = HexagonView()
            addSubview(hexagonView)
        }
    }
}
