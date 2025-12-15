//
//  Turtle.swift
//  EDICC
//
//  Created by 노우영 on 12/15/25.
//

import UIKit
import CoreGraphics

class TurtlePath {
    
    let path = UIBezierPath()
    
    var points: [CGPoint] = [] // mark()로 기록된 지점들
    
    private var currentPoint: CGPoint
    private var heading: CGFloat
    let center: CGPoint
    
    init(center: CGPoint, startHeading: CGFloat = -.pi / 2) {
        self.center = center
        self.currentPoint = center
        self.heading = startHeading
        self.path.move(to: center)
    }
    
    func turn(angle: CGFloat) {
        heading += angle
    }
    
    func mark() {
        points.append(currentPoint)
    }
    
    func move(_ length: CGFloat) {
        let nextX = currentPoint.x + length * cos(heading)
        let nextY = currentPoint.y + length * sin(heading)
        let nextPoint = CGPoint(x: nextX, y: nextY)
        
        // 경로에 선을 긋지 않고 위치만 이동
        path.move(to: nextPoint)
        currentPoint = nextPoint
    }
    
    /// mark()로 기록된 지점들을 연결하여 폴리곤을 완성합니다.
    func connectMarkedPoints(cornerRadius: CGFloat = 0) {
        // 점이 2개 미만이면 선을 이을 수 없음
        guard points.count > 1 else { return }
        
        // 코너 반경이 있고, 점이 3개 이상이어야 둥근 모서리 구현 가능 (삼각형 이상)
        if cornerRadius > 0 && points.count >= 3 {
            path.append(makeRoundedPolygonPath(radius: cornerRadius))
        } else {
            // cornerRadius가 0이거나 점이 2개뿐인 경우 -> 직선 연결
            path.append(makePolygonPath())
        }
    }
    
    private func makePolygonPath() -> UIBezierPath {
        let connectionPath = UIBezierPath()
        connectionPath.move(to: points[0])
        
        for i in 1..<points.count {
            connectionPath.addLine(to: points[i])
        }
        
        connectionPath.close()
        return connectionPath
    }
    
    /// 주어진 점들을 연결하여 둥근 모서리를 가진 다각형 경로를 생성합니다.
    private func makeRoundedPolygonPath(radius: CGFloat) -> UIBezierPath {
        let cgPath = CGMutablePath()
        
        guard let lastPoint = points.last, let firstPoint = points.first, points.count >= 3 else {
            return UIBezierPath()
        }
        
        let startPoint = CGPoint(x: (lastPoint.x + firstPoint.x) / 2, y: (lastPoint.y + firstPoint.y) / 2)
        cgPath.move(to: startPoint)
        
        for i in 0..<points.count {
            let currentPoint = points[i]
            let nextPoint = points[(i + 1) % points.count]
            
            cgPath.addArc(
                tangent1End: currentPoint,
                tangent2End: nextPoint,
                radius: radius
            )
        }
        
        cgPath.closeSubpath()
        adjustVertices(cornerRadius: radius)
        return UIBezierPath(cgPath: cgPath)
    }
    
    private func adjustVertices(cornerRadius: CGFloat) {
        // 코너가 없거나 점이 부족하면 원본 그대로 반환
        guard cornerRadius > 0, points.count >= 3 else { return }
        
        var adjustedPoints: [CGPoint] = []
        
        for i in 0..<points.count {
            let prev = points[(i - 1 + points.count) % points.count]
            let curr = points[i]
            let next = points[(i + 1) % points.count]
            
            // 1. 벡터 계산 (현재 점을 기준으로 이웃 점들 방향)
            let v1 = prev - curr
            let v2 = next - curr
            
            // 2. 각 벡터의 길이
            let l1 = sqrt(v1.x * v1.x + v1.y * v1.y)
            let l2 = sqrt(v2.x * v2.x + v2.y * v2.y)
            
            // 3. 내적(Dot Product)을 이용한 사잇각(Internal Angle) 계산
            // v1 . v2 = |v1||v2|cos(theta)
            let dotProduct = v1.x * v2.x + v1.y * v2.y
            let angle = acos(dotProduct / (l1 * l2)) // 라디안 단위의 전체 내각
            
            // 4. 반각 (Half Angle)
            let halfAngle = angle / 2.0
            
            // 5. 깎여나가는 길이(Offset) 계산
            // 공식: Offset = r * (1/sin(halfAngle) - 1)
            // sin(halfAngle)이 0에 가까우면(직선) 계산 불가하므로 방어 코드 필요
            guard sin(halfAngle) > 0.001 else {
                adjustedPoints.append(curr)
                continue
            }
            
            let offset = cornerRadius * (1.0 / sin(halfAngle) - 1.0)
            
            // 6. 좌표 이동 (Move Towards Center)
            // 레이더 차트이므로, 점을 '중심(Center)' 방향으로 offset만큼 당깁니다.
            let distToCenter = curr.distance(to: center)
            
            if distToCenter > 0 {
                let ratio = (distToCenter - offset) / distToCenter
                // 중심에서부터의 거리를 비율로 줄임
                let newX = center.x + (curr.x - center.x) * ratio
                let newY = center.y + (curr.y - center.y) * ratio
                adjustedPoints.append(CGPoint(x: newX, y: newY))
            } else {
                adjustedPoints.append(curr)
            }
        }
        
        points = adjustedPoints
    }
}

private extension CGPoint {
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    // 두 점 사이의 거리
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - x, 2) + pow(point.y - y, 2))
    }
}
