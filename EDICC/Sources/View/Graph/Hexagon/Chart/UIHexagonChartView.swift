//
//  File.swift
//  EDICC
//
//  Created by 노우영 on 12/11/25.
//

import UIKit
import SnapKit


class UIHexagonChartView: UIView {
    
    let model: HexagonChartModel
    
    var hexagonViews = [HexagonView]()
    
    private var primaryPolygonLayer = CAShapeLayer()
    private var secondaryPolygonLayer = CAShapeLayer()
    
    private var lastPrimaryId: UUID?
    private var lastSecondaryId: UUID?
    
    private let hexagonIterations = 3
    private let chartInset = CGFloat(40)
    
    var axisLabelViews: [UILabel] = []
    private var isInitialAnimationPlayed = false
    
    init(data: HexagonChartModel) {
        self.model = data
        super.init(frame: .zero)
        setupLabels()
        setupGrid()
        setupDataLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var polygonLayers: [CAShapeLayer] {
        [primaryPolygonLayer, secondaryPolygonLayer]
    }
    
    var outerHexagon: HexagonView? { hexagonViews.last }
    
    // MARK: - Setup Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateDataPolygon()
        updateLabels()
    }
    
    
    /// 배경 육각형 그리드 설정
    private func setupGrid() {
        for i in 1...hexagonIterations {
            let hexagonView = HexagonView()
            // 터치 이벤트가 데이터 레이어까지 전달되도록 설정 (필요시)
            hexagonView.isUserInteractionEnabled = false
            
            hexagonViews.append(hexagonView)
            addSubview(hexagonView)
            
            let multiplier = Double(i) / Double(hexagonIterations)
            
            hexagonView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalToSuperview().inset(40).multipliedBy(multiplier)
            }
        }
    }
    
    private func setupDataLayers() {
        // 기존 레이어 제거 (재설정 시 안전장치)
        polygonLayers.forEach { $0.removeFromSuperlayer() }
        
        primaryPolygonLayer = CAShapeLayer()
        secondaryPolygonLayer = CAShapeLayer()
        
        layer.addSublayer(secondaryPolygonLayer)
        layer.addSublayer(primaryPolygonLayer)
    }
    
    private func updateDataPolygon() {
        guard let outerHexagon, model.hasPoints else { return }
        
        outerHexagon.layoutIfNeeded()
        
        // 모든 폴리곤 레이어의 프레임 업데이트 (회전/리사이징 대응)
        polygonLayers.forEach { $0.frame = bounds }
        
        let convertedVertexes = outerHexagon.vertexes.map { point in
            return outerHexagon.convert(point, to: self)
        }
        
        let currentPrimaryId = model.primary.id
        let currentSecondaryId = model.secondary.id
        
        
        if !isInitialAnimationPlayed {
            animateAllPolygons(center: outerHexagon.center, vertexes: convertedVertexes)
            
            isInitialAnimationPlayed = true
            lastPrimaryId = currentPrimaryId
            lastSecondaryId = currentSecondaryId
            
        } else {
            let isPrimaryChanged = currentPrimaryId != lastPrimaryId
            let isSecondaryChanged = currentSecondaryId != lastSecondaryId
            
            if isPrimaryChanged || isSecondaryChanged {
                updatePrimaryPolygon(center: outerHexagon.center, vertexes: convertedVertexes)
                updateSecondaryPolygon(center: outerHexagon.center, vertexes: convertedVertexes)
            } else {
                // 화면 리사이징 대응 (디바이스 회전 등)
                updatePathsWithoutAnimation(
                    center: outerHexagon.center,
                    vertexes: convertedVertexes
                )
            }
        }
        
        updatePolygonColor()
    }
    
    private func updateSecondaryPolygon(center: CGPoint, vertexes: [CGPoint]) {
        guard model.secondary.id != lastSecondaryId else { return }
        
        expandDataPolygon(
            layer: secondaryPolygonLayer,
            center: center,
            vertexes: vertexes,
            values: model.secondary.points.map { CGFloat($0.normalizedValue) },
            beginTime: CACurrentMediaTime()
        )
        
        lastSecondaryId = model.secondary.id
    }
    
    private func updatePrimaryPolygon(center: CGPoint, vertexes: [CGPoint]) {
        guard model.primary.id != lastPrimaryId else { return }
        
        expandDataPolygon(
            layer: primaryPolygonLayer,
            center: center,
            vertexes: vertexes,
            values: model.primary.points.map { CGFloat($0.normalizedValue) },
            beginTime: CACurrentMediaTime()
        )
        
        lastPrimaryId = model.primary.id
    }
    
    private func updateLayerPath(layer: CAShapeLayer, center: CGPoint, vertexes: [CGPoint], values: [CGFloat]) {
        let path = RadarPolygon(
            center: center,
            vertexes: vertexes,
            factor: values
        ).path().cgPath
        layer.path = path
    }
    
    private func updatePolygonColor() {
        let primaryColor = UIColor(model.primary.color.value)
        polygonLayers[0].fillColor = primaryColor.withAlphaComponent(0.4).cgColor
        
        let secondaryColor = UIColor(model.secondary.color.value)
        polygonLayers[1].fillColor = secondaryColor.withAlphaComponent(0.4).cgColor
    }
    
    /// 모든 데이터 폴리곤을 순차적으로 애니메이션
    private func animateAllPolygons(center: CGPoint, vertexes: [CGPoint]) {
        let currentTime = CACurrentMediaTime()
        
        expandDataPolygon(
            layer: primaryPolygonLayer,
            center: center,
            vertexes: vertexes,
            values: model.primary.points.map { CGFloat($0.normalizedValue) },
            beginTime: currentTime
        )
        
        expandDataPolygon(
            layer: secondaryPolygonLayer,
            center: center,
            vertexes: vertexes,
            values: model.secondary.points.map { CGFloat($0.normalizedValue) },
            beginTime: currentTime + 0.2
        )
    }
    
    /// 화면 회전 등을 위해 애니메이션 없이 즉시 경로 업데이트
    private func updatePathsWithoutAnimation(center: CGPoint, vertexes: [CGPoint]) {
        let primaryPath = RadarPolygon(
            center: center,
            vertexes: vertexes,
            factor: model.primary.points.map { CGFloat($0.normalizedValue)}
        ).path().cgPath
        
        primaryPolygonLayer.path = primaryPath
        
        let secondaryPath = RadarPolygon(
            center: center,
            vertexes: vertexes,
            factor: model.secondary.points.map { CGFloat($0.normalizedValue)}
        ).path().cgPath
        
        secondaryPolygonLayer.path = secondaryPath
    }
    
    /// 개별 레이어 확장 애니메이션 로직
    private func expandDataPolygon(layer: CAShapeLayer, center: CGPoint, vertexes: [CGPoint], values: [CGFloat], beginTime: CFTimeInterval) {
        
        // 1. 최종 경로
        let finalPath = RadarPolygon(
            center: center,
            vertexes: vertexes,
            factor: values
        ).path().cgPath
        
        // 2. 시작 경로 (모든 값이 0)
        let zeroValues = Array(repeating: CGFloat(0), count: values.count)
        let startPath = RadarPolygon(
            center: center,
            vertexes: vertexes,
            factor: zeroValues
        ).path().cgPath
        
        // 3. 애니메이션 설정
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath
        animation.toValue = finalPath
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut) // 부드러운 감속
        
        // ⭐️ 핵심: 시작 시간 지연 (순차 애니메이션)
        animation.beginTime = beginTime
        animation.fillMode = .backwards // 대기 시간 동안 startPath 상태 유지
        
        layer.add(animation, forKey: "pathMorphing")
        layer.path = finalPath
    }
}

#Preview {
    UIHexagonChartView(data: .mock())
}
