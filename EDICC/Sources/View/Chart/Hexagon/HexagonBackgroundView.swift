//
//  HexagonBackgroundView.swift
//  EDICC
//
//  Created by 노우영 on 12/11/25.
//

import Foundation
import UIKit

class HexagonView: UIView {
    
    // 육각형의 색상을 설정할 수 있도록 public 변수 정의
    public var fillColor: UIColor = .clear {
        didSet {
            // 색상 변경 시 레이어를 업데이트
            shapeLayer.fillColor = fillColor.cgColor
        }
    }
    
    // 육각형의 선 색상을 설정
    public var strokeColor: UIColor = UIColor(hex: "3A336B") {
        didSet {
            shapeLayer.strokeColor = strokeColor.cgColor
        }
    }
    
    // 육각형의 선 굵기를 설정
    public var lineWidth: CGFloat = 2.0 {
        didSet {
            shapeLayer.lineWidth = lineWidth
        }
    }
    
    // 모양을 그리는 CAShapeLayer
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // 배경을 투명하게 설정
        backgroundColor = .clear
        
        // 레이어 설정
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        // 뷰의 레이어에 추가
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 뷰의 크기가 변경될 때마다 경로를 다시 계산하고 설정
        shapeLayer.frame = bounds
        shapeLayer.path = createFlatTopHexagonPath().cgPath
    }
    
    // MARK: - 사용자 요청: 12시 방향이 선분인 육각형 경로
    public func createFlatTopHexagonPath() -> UIBezierPath {
        let sideLength = min(bounds.width, bounds.height) / 2.0
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let path = UIBezierPath()
        var points: [CGPoint] = []
        
        let startAngle: CGFloat = 0
        let angleStep: CGFloat = .pi / 3.0 // 60도 간격
        
        for i in 0..<6 {
            let angle = startAngle + CGFloat(i) * angleStep
            
            let x = center.x + sideLength * cos(angle)
            let y = center.y - sideLength * sin(angle)
            
            points.append(CGPoint(x: x, y: y))
        }
        
        if let firstPoint = points.first {
            path.move(to: firstPoint)
            for i in 1..<points.count {
                path.addLine(to: points[i])
            }
            path.close()
        }
        
        return path
    }
}

#Preview {
    HexagonView()
}
