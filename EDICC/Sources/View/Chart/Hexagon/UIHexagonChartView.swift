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
    
    // MARK: - UI Components
    var hexagonViews = [HexagonView]()
    private var polygonLayers = [CAShapeLayer]()
    
    // MARK: - Properties
    private let hexagonIterations = 3
    private let chartInset = CGFloat(40)
    
    // 애니메이션 중복 실행 방지 플래그
    var axisLabelViews: [UILabel] = []
    private var isInitialAnimationPlayed = false
    
    // MARK: - Initialization
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
    
    var outerHexagon: HexagonView? { hexagonViews.last }
    
    // MARK: - Setup Methods
    
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
    
    /// 데이터셋 개수에 맞춰 폴리곤 레이어 미리 생성
    private func setupDataLayers() {
        // 기존 레이어 제거 (재설정 시 안전장치)
        polygonLayers.forEach { $0.removeFromSuperlayer() }
        polygonLayers.removeAll()
        
        for _ in model.dataSets.enumerated() {
            let radarPolygon = CAShapeLayer()
            layer.addSublayer(radarPolygon)
            polygonLayers.append(radarPolygon)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLabels()
        updateDataPolygon()
        updateLabelConstraints()
    }
    
    private func updateDataPolygon() {
        
        
        guard let outerHexagon, !model.dataSets.isEmpty else { return }
        
        outerHexagon.layoutIfNeeded()
        
        // 모든 폴리곤 레이어의 프레임 업데이트 (회전/리사이징 대응)
        polygonLayers.forEach { $0.frame = bounds }
        
        let convertedVertexes = outerHexagon.vertexes.map { point in
            return outerHexagon.convert(point, to: self)
        }
        
        // 애니메이션은 화면에 처음 그려질 때 딱 한 번만 실행
        if !isInitialAnimationPlayed {
            animateAllPolygons(center: outerHexagon.center, vertexes: convertedVertexes)
            isInitialAnimationPlayed = true
        } else {
            // 애니메이션 이후에는 최종 경로로 고정 (화면 회전 대응)
            updatePathsWithoutAnimation(center: outerHexagon.center, vertexes: outerHexagon.vertexes)
        }
        
        updatePolygonColor()
    }
    
    private func updatePolygonColor() {
        for (index, polygonLayer) in polygonLayers.enumerated() {
            guard index < model.dataSets.count else { break }
            let color = UIColor(model.dataSets[index].color.color)
            polygonLayer.fillColor = color.withAlphaComponent(0.4).cgColor
        }
    }
    
    /// 모든 데이터 폴리곤을 순차적으로 애니메이션
    private func animateAllPolygons(center: CGPoint, vertexes: [CGPoint]) {
        let currentTime = CACurrentMediaTime()
        
        for (index, dataSet) in model.dataSets.enumerated() {
            // 안전장치: 레이어가 데이터보다 적을 경우 대비
            guard index < polygonLayers.count else { break }
            
            let layer = polygonLayers[index]
            
            // 0.2초 간격으로 순차 실행 (DispatchQueue 대신 beginTime 사용)
            let delay = Double(index) * 0.2
            
            expandDataPolygon(
                layer: layer,
                center: center,
                vertexes: vertexes,
                values: dataSet.values,
                beginTime: currentTime + delay
            )
        }
    }
    
    /// 화면 회전 등을 위해 애니메이션 없이 즉시 경로 업데이트
    private func updatePathsWithoutAnimation(center: CGPoint, vertexes: [CGPoint]) {
        for (index, dataSet) in model.dataSets.enumerated() {
            guard index < polygonLayers.count else { break }
            
            let finalPath = RadarPolygon(
                center: center,
                vertexes: vertexes,
                factor: dataSet.values
            ).path().cgPath
            
            polygonLayers[index].path = finalPath
        }
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

struct HexagonDataSet {
    let label: String?
    var color: IdentifiableColor
    let values: [CGFloat]
}

@Observable
class HexagonChartModel {
    var axisLabels: [String]
    var dataSets: [HexagonDataSet]
    
    init(axisLabels: [String], dataSets: [HexagonDataSet]) {
        self.axisLabels = axisLabels
        self.dataSets = dataSets
    }
}

#Preview {
    let dataSet1 = HexagonDataSet(
        label: nil,
        color: IdentifiableColor(.creamyOrange),
        values: [1, 0.666, 0.7, 0.5, 0.7, 0.1]
    )
    
    let dataSet2 = HexagonDataSet(
        label: nil,
        color: IdentifiableColor(.pastelPink),
        values: [0.2, 0.5, 0.65, 0.9, 0.8, 0.4]
    )
    
    let chart = HexagonChartModel(
        axisLabels: ["ACK", "DMG", "C", "D", "E", "F"],
        dataSets: [dataSet1, dataSet2]
    )
    
    UIHexagonChartView(data: chart)
}
