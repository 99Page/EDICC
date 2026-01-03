//
//  ChartLegendView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct ChartLegendView: View {
    
    @Binding var primary: HexagonDataSet
    @Binding var secondary: HexagonDataSet
    
    var onLegendSelected: (HexagonDataSet) -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            legendBadgeView(
                dataSet: primary,
                color: $primary.color.value
            )
            
            divider
            
            legendBadgeView(
                dataSet: secondary,
                color: $secondary.color.value
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Subviews & Helpers
private extension ChartLegendView {
    @ViewBuilder
    func legendBadgeView(dataSet: HexagonDataSet, color: Binding<Color>) -> some View {
        LegendBadgeView(
            color: color,
            title: dataSet.label
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onLegendSelected(dataSet)
        }
    }
    
    /// 중앙 구분선
    var divider: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 1, height: 12)
    }
}

struct LegendBadgeView: View {
    
    @Binding var color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black.opacity(0.8))
                .lineLimit(1)
        }
    }
}
