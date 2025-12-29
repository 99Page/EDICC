//
//  ChartLegendView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct ChartLegendView<VM: Identifiable, LegendView: View>: View {
    @Binding var legendVM: VM?
    
    @Binding var primary: HexagonDataSet
    @Binding var secondary: HexagonDataSet
    
    @State private var isPrimaryColorSelected: Bool = true
    
    let legendView: (VM) -> LegendView
    
    var legendSelected: (HexagonDataSet) -> Void
    
    
    var body: some View {
        HStack(spacing: 20) {
            LegendBadgeView(color: $primary.color.value, title: primary.label)
                .onTapGesture {
                    isPrimaryColorSelected = true
                    legendSelected(primary)
                }
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 12)
            
            LegendBadgeView(color: $secondary.color.value, title: secondary.label)
                .onTapGesture {
                    isPrimaryColorSelected = false
                    legendSelected(secondary)
                }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.black.opacity(0.05))
        .cornerRadius(12)
        .sheet(item: $legendVM) { vm in
            LegendSelectionView(
                color: isPrimaryColorSelected ? $primary.color.value : $secondary.color.value,
                bannedColor: isPrimaryColorSelected ? [secondary.color] : [primary.color]
            ) { legendView(vm) }
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
