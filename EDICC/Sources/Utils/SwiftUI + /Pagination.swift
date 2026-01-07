//
//  PaginationTrigger.swift
//  EDICC
//
//  Created by 노우영 on 1/5/26.
//

import SwiftUI

struct PaginationTrigger: ViewModifier {
    
    @State private var isLoading = false
    @State private var isCoolingDown = false
    
    let isLastItem: Bool
    let delay: Double
    let action: () async -> Void
    
    func body(content: Content) -> some View {
        content
            .task { // .task { } 뷰가 사라지면 자동으로 Cancel
                defer { // Task가 cancel 되는 상황에서도 실행 필요
                    isCoolingDown = false
                    isLoading = false
                }
                
                guard isLastItem, !isLoading, !isCoolingDown else { return }
                
                isCoolingDown = true
                isLoading = true
                
                await action()
                isLoading = false
                
                try? await Task.sleep(for: .seconds(delay))
            }
    }
}

extension View {
    /// - Parameters:
    ///   - delay: 트리거가 발동되기 전 대기 시간 (기본값 1초)
    func onPagingTrigger(
        isLastItem: Bool,
        delay: Double = 1, // ⭐️ 기본값 설정
        action: @escaping () async -> Void
    ) -> some View {
        modifier(PaginationTrigger(
            isLastItem: isLastItem,
            delay: delay,
            action: action
        ))
    }
}
