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
    public var lineWidth: CGFloat = 3.0 {
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
    
    public func createFlatTopHexagonPath() -> UIBezierPath {
        let sideLength = min(bounds.width, bounds.height) / 2.0
        let radius: CGFloat = sideLength / 10
        let adjustedSideLenght = sideLength - radius
        
        let center = CGPoint(x: bounds.midX - (radius / 2), y: bounds.midY)
        
        let turtle = TurtlePath(startPoint: center)
        
        turtle.turn(angle: .pi / 6)
        turtle.move(sideLength)
        turtle.turn(angle: .pi / 3)
        
        for _ in 0..<6 {
            turtle.drawCircle(angle: .pi / 3, radius: radius)
            turtle.drawLine(adjustedSideLenght)
        }
        
        return turtle.path
    }
}

#Preview {
    HexagonView()
}
