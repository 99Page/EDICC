//
//  ChartLegendView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct ChartLegendView: View {
    // 튜플 형태로 데이터 받기 (비교군 A, 비교군 B)
    
    @Binding var primaryColor: IdentifiableColor
    let primaryTitle: String
    
    @Binding var secondaryColor: IdentifiableColor
    let secondaryTitle: String
    
    @State private var isLegendSelectionViewPresented = false
    @State private var isPrimaryColorSelected: Bool = true
    
    
    var body: some View {
        HStack(spacing: 20) {
            LegendBadgeView(color: $primaryColor.color, title: primaryTitle)
                .onTapGesture {
                    isPrimaryColorSelected = true
                    isLegendSelectionViewPresented = true
                }
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 12)
            
            LegendBadgeView(color: $secondaryColor.color, title: secondaryTitle)
                .onTapGesture {
                    isPrimaryColorSelected = false
                    isLegendSelectionViewPresented = true
                }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .sheet(isPresented: $isLegendSelectionViewPresented) {
            LegendSelectionView(
                color: isPrimaryColorSelected ? $primaryColor.color : $secondaryColor.color
            )
            .padding(.all)
            .presentationDragIndicator(.visible)
            .presentationDetents([.medium])
        }
    }
}

struct LegendBadgeView: View {
    
    @Binding var color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 6) {
            // 색상 표시 (원형)
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            // 텍스트
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.9)) // 다크 모드 가독성
                .lineLimit(1)
        }
    }
}

#Preview {
    
    @Previewable @State var c1 = IdentifiableColor(.creamyOrange)
    @Previewable @State var c2 = IdentifiableColor(.lavendar)
    
    ChartLegendView(
        primaryColor: $c1,
        primaryTitle: "c1",
        secondaryColor: $c2,
        secondaryTitle: "c2"
    )
    .background(
        Color.black
    )
}
