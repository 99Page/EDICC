//
//  HexagonBackgroundView.swift
//  EDICC
//
//  Created by 노우영 on 12/11/25.
//

import Foundation
import UIKit

class HexagonView: UIView {
    
    public var fillColor: UIColor = .clear {
        didSet { shapeLayer.fillColor = fillColor.cgColor }
    }
    
    var vertexes: [CGPoint] = []
    
    public var strokeColor: UIColor = UIColor(resource: .hexagonStroke) {
        didSet { shapeLayer.strokeColor = strokeColor.cgColor }
    }
    
    public var lineWidth: CGFloat = 2.5 {
        didSet {
            shapeLayer.lineWidth = lineWidth
            setNeedsLayout() // 선 두께가 바뀌면 레이아웃 다시 계산
        }
    }
    
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
        backgroundColor = .clear
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = .round // 모서리 깨짐 방지
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // lineWidth를 조정할 때, 도형의 바깥쪽으로 선분들 확장하기 위해
        // 두 단계로 나눴습니다.
        updateVerticies()
        visualizeHexagon()
    }
    
    private func updateVerticies() {
        createFlatTopHexagonPath(offset: 0)
    }
    
    private func visualizeHexagon() {
        let outerOffset = lineWidth / 2.0
        let visualPath = createFlatTopHexagonPath(offset: outerOffset)
        
        shapeLayer.frame = bounds
        shapeLayer.path = visualPath.cgPath
    }
    
    /// 육각형 경로를 생성합니다.
    /// - Parameter offset: 경로를 바깥쪽으로 확장할 거리 (기본값 0)
    @discardableResult
    func createFlatTopHexagonPath(offset: CGFloat = 0) -> UIBezierPath {
        
        // 정육각형 기하학 보정:
        // 변을 수직으로 'offset'만큼 밀어내려면, 중심에서 꼭짓점까지의 거리(반지름)는
        // offset * (2 / sqrt(3)) 만큼 늘어나야 합니다.
        let expansion = offset * (2.0 / sqrt(3.0))
        
        // 기본 반지름 + 확장된 길이
        let sideLength = (min(bounds.width, bounds.height) / 2.0)
        
        // 그리기용 반지름 (확장 적용)
        let drawRadius = sideLength + expansion
        
        // 모서리 둥글기도 비례해서 커져야 자연스럽습니다.
        // offset이 0일 때(데이터용)는 기본값, 확장될 때는 그만큼 둥글기도 더 줍니다.
        let baseCornerRadius = sideLength / 10
        let drawCornerRadius = baseCornerRadius + offset
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let turtle = TurtlePath(center: center)
        
        // --- Turtle Drawing Logic ---
        turtle.turn(angle: .pi / 3)
        turtle.move(drawRadius) // 확장된 반지름 사용
        turtle.mark()
        turtle.turn(angle: .pi / 3)
        
        for _ in 0..<5 {
            turtle.turn(angle: .pi / 3)
            turtle.move(drawRadius) // 확장된 반지름 사용
            turtle.mark()
        }
        
        turtle.connectMarkedPoints(cornerRadius: drawCornerRadius)
        
        // ⭐️ 중요: offset이 0일 때만(데이터 계산용일 때만) vertexes를 업데이트합니다.
        if offset == 0 {
            vertexes = turtle.points
        }
        
        return turtle.path
    }
}

#Preview {
    HexagonView()
}
