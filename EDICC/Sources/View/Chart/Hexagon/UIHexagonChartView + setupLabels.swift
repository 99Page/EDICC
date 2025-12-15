//
//  HexagonChartView + setupLabels.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import UIKit
import SnapKit

extension UIHexagonChartView {
    
    private var labelOffset: CGFloat { 10 }
    
    // MARK: - Label Setup
    
    func setupLabels() {
        for text in model.axisLabels {
            let label = UILabel()
            label.text = text
            label.textColor = .black
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.numberOfLines = 2
            label.textAlignment = .center
            addSubview(label)
            axisLabelViews.append(label)
        }
    }
    
    func updateLabels() {
        for (index, text) in model.axisLabels.enumerated() {
            guard index < axisLabelViews.count else { return }
            axisLabelViews[index].text = text
        }
    }
    
    // MARK: - Layout Update
    func updateLabelConstraints() {
        guard let outerHexagon, !outerHexagon.vertexes.isEmpty,
              !axisLabelViews.isEmpty else { return }
        
        let centerPoint = outerHexagon.center
        
        for (index, label) in axisLabelViews.enumerated() {
            guard index < outerHexagon.vertexes.count else { break }
            let targetPoint = outerHexagon.convert(outerHexagon.vertexes[index], to: self)
            layoutLabel(label, at: targetPoint, center: centerPoint)
        }
    }
    
    private func layoutLabel(_ label: UILabel, at targetPoint: CGPoint, center centerPoint: CGPoint) {
        let tolerance: CGFloat = 5.0
        let xDistance = abs(targetPoint.x - centerPoint.x)
        
        label.snp.remakeConstraints { make in
            make.width.equalTo(60)
            
            let isOnVerticalAxis = xDistance <= tolerance
            
            if isOnVerticalAxis {
                configureVerticalLabel(make: make, label: label, target: targetPoint, center: centerPoint)
            } else {
                configureHorizontalLabel(make: make, label: label, target: targetPoint, center: centerPoint)
            }
        }
    }
    
    private func configureVerticalLabel(make: ConstraintMaker, label: UILabel, target: CGPoint, center: CGPoint) {
        make.centerX.equalTo(self.snp.leading).offset(target.x)
        label.textAlignment = .center
        
        if target.y < center.y { // 도형 기준 12시
            make.bottom.equalTo(self.snp.top).offset(target.y - labelOffset)
        } else { // 도형 기준 6시
            make.top.equalTo(self.snp.top).offset(target.y + labelOffset)
        }
    }
    
    private func configureHorizontalLabel(make: ConstraintMaker, label: UILabel, target: CGPoint, center: CGPoint) {
        make.centerY.equalTo(self.snp.top).offset(target.y)
        
        if target.x > center.x { // 도형 기준 오른쪽
            make.leading.equalTo(self.snp.leading).offset(target.x + labelOffset)
            label.textAlignment = .left
        } else { // 도형 기준 왼쪽
            make.trailing.equalTo(self.snp.leading).offset(target.x - labelOffset)
            label.textAlignment = .right
        }
    }
}
