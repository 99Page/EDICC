//
//  TurtlePath.swift
//  EDICC
//
//  Created by 노우영 on 12/12/25.
//

import Foundation

import UIKit

class TurtlePath {
    
    let path = UIBezierPath()
    private var currentPoint: CGPoint
    
    // 12시: - pi / 2
    // 3시: 0
    private var heading: CGFloat
    
    init(startPoint: CGPoint, startHeading: CGFloat = -.pi / 2) {
        self.currentPoint = startPoint
        self.heading = startHeading
        self.path.move(to: startPoint)
    }
    
    func turn(angle: CGFloat) {
        heading += angle
    }
    
    func move(_ length: CGFloat) {
        // 이동할 새로운 좌표 계산
        let nextX = currentPoint.x + length * cos(heading)
        let nextY = currentPoint.y + length * sin(heading)
        let nextPoint = CGPoint(x: nextX, y: nextY)
        
        path.move(to: nextPoint)
        currentPoint = nextPoint
    }
    
    func drawLine(_ length: CGFloat) {
        // 이동할 새로운 좌표 계산
        let nextX = currentPoint.x + length * cos(heading)
        let nextY = currentPoint.y + length * sin(heading)
        let nextPoint = CGPoint(x: nextX, y: nextY)
        
        // 경로 추가 및 위치 업데이트
        path.addLine(to: nextPoint)
        currentPoint = nextPoint
    }
    
    func drawCircle(angle: CGFloat, radius: CGFloat) {
        // iOS 좌표계(Y축이 아래로) 기준 시계방향 회전(Turn Right)을 위한 중심점 계산
        let centerAngle = heading + .pi / 2
        let centerX = currentPoint.x + radius * cos(centerAngle)
        let centerY = currentPoint.y + radius * sin(centerAngle)
        let center = CGPoint(x: centerX, y: centerY)
        
        // UIBezierPath의 addArc를 위한 시작 각도와 끝 각도 계산
        // 원의 중심에서 현재 포인트(시작점)를 바라보는 각도
        let startAngle = centerAngle - .pi
        let endAngle = startAngle + angle
        
        path.addArc(withCenter: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true) // iOS 좌표계상 각도 증가는 시계방향
        
        // 위치 및 방향 업데이트
        // 끝점은 원의 중심에서 endAngle 방향으로 반지름만큼 떨어진 곳
        let endX = centerX + radius * cos(endAngle)
        let endY = centerY + radius * sin(endAngle)
        
        currentPoint = CGPoint(x: endX, y: endY)
        heading += angle // 바라보는 방향도 회전한 만큼 변경됨
    }
}
