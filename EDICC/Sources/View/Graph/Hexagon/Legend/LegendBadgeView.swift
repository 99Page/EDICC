//
//  ChartLegendView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct ChartLegendView<SheetItem: HexagonMaker, SheetContent: View>: View {
    
    @Binding var primary: HexagonDataSet
    @Binding var secondary: HexagonDataSet
    
    @Binding var selectedItem: SheetItem?
    
    var onLegendSelected: (HexagonDataSet) -> Void
    @ViewBuilder let sheetContent: (SheetItem) -> SheetContent
    
    @State private var isPrimarySelected: Bool = true
    
    var body: some View {
        HStack(spacing: 20) {
            legendBadgeView(
                dataSet: primary,
                isTargetPrimary: true
            )
            
            divider
            
            legendBadgeView(
                dataSet: secondary,
                isTargetPrimary: false
            )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .sheet(item: $selectedItem) { item in
            legendSheet(vm: item)
        }
    }
}

// MARK: - Subviews & Helpers
private extension ChartLegendView {
    @ViewBuilder
    func legendBadgeView(dataSet: HexagonDataSet, isTargetPrimary: Bool) -> some View {
        LegendBadgeView(
            color: isTargetPrimary ? $primary.color.value : $secondary.color.value,
            title: dataSet.label
        )
        .contentShape(Rectangle())
        .onTapGesture {
            isPrimarySelected = isTargetPrimary
            onLegendSelected(dataSet)
        }
    }
    
    /// 중앙 구분선
    var divider: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 1, height: 12)
    }
    
    /// 시트 내부 컨텐츠 생성 로직
    @ViewBuilder
    func legendSheet(vm: SheetItem) -> some View {
        // 복잡한 삼항 연산자를 변수로 분리
        let targetColorBinding = isPrimarySelected ? $primary.color.value : $secondary.color.value
        let bannedColors: Set<IdentifiableColor> = isPrimarySelected ? [secondary.color] : [primary.color]
        
        LegendSelectionView(
            color: targetColorBinding,
            bannedColor: bannedColors
        ) {
            sheetContent(vm)
        }
        .presentationDragIndicator(.visible)
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
