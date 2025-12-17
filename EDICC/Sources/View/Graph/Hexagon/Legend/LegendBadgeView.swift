//
//  ChartLegendView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct ChartLegendView<LegendView: View>: View {
    @Binding var primaryColor: IdentifiableColor
    let primaryTitle: String
    
    @Binding var secondaryColor: IdentifiableColor
    let secondaryTitle: String
    
    @State private var isLegendSelectionViewPresented = false
    @State private var isPrimaryColorSelected: Bool = true
    
    let legendView: () -> LegendView
    
    
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
        .background(Color.black.opacity(0.05))
        .cornerRadius(12)
        .sheet(isPresented: $isLegendSelectionViewPresented) {
            LegendSelectionView(
                color: isPrimaryColorSelected ? $primaryColor.color : $secondaryColor.color,
                bannedColor: isPrimaryColorSelected ? [secondaryColor] : [primaryColor]
            ) { legendView() }
        }
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

#Preview {
    
    @Previewable @State var c1 = IdentifiableColor(.creamyOrange)
    @Previewable @State var c2 = IdentifiableColor(.lavendar)
    
    ChartLegendView(
        primaryColor: $c1,
        primaryTitle: "c1",
        secondaryColor: $c2,
        secondaryTitle: "c2"
    ) {
        EmptyView()
    }
    .background(
        Color.black
    )
}
