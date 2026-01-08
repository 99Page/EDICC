//
//  DataPolygon.swift
//  EDICC
//
//  Created by 노우영 on 12/15/25.
//

import UIKit

class RadarPolygon {
    let center: CGPoint
    let vertexes: [CGPoint]  // 레이더 차트의 외곽(최대치) 좌표들
    let factor: [CGFloat]    // 각 항목의 비율 (0.0 ~ 1.0)
    
    init(center: CGPoint, vertexes: [CGPoint], factor: [CGFloat]) {
        self.center = center
        self.vertexes = vertexes
        self.factor = factor
    }
    
    /// 팩터값과 코너 반지름이 적용된 UIBezierPath를 반환합니다.
    /// - Parameter cornerRadius: 모서리 둥글기 (기본값: 0)
    func path() -> UIBezierPath {
        // 1. 비율(factor)이 적용된 실제 좌표 계산
        let points = calculateDataPoints()
        
        // 2. 좌표들을 연결하여 경로 생성
        return createPath(from: points)
    }
    
    // MARK: - Private Methods
    
    /// 중심점, 외곽 좌표, 팩터를 이용하여 실제 점의 위치를 계산합니다.
    /// 공식: P = Center + (Vertex - Center) * Factor
    private func calculateDataPoints() -> [CGPoint] {
        var points: [CGPoint] = []
        
        // 안전을 위해 두 배열 중 적은 개수만큼만 반복
        let count = min(vertexes.count, factor.count)
        
        for i in 0..<count {
            let vertex = vertexes[i]
            let value = factor[i]
            
            // 벡터 연산: 중심에서 꼭짓점 방향으로 비율만큼 이동
            let x = center.x + (vertex.x - center.x) * value
            let y = center.y + (vertex.y - center.y) * value
            
            points.append(CGPoint(x: x, y: y))
        }
        
        return points
    }
    
    /// 점들을 연결하여 닫힌 경로를 만듭니다. (cornerRadius 적용)
    private func createPath(from points: [CGPoint]) -> UIBezierPath {
        // 점이 3개 미만이면 면을 만들 수 없음 (빈 경로 반환)
        guard points.count >= 3 else { return UIBezierPath() }
        
        let path = UIBezierPath()
        
        path.move(to: points[0])
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        
        path.close()
        return path
    }
}
