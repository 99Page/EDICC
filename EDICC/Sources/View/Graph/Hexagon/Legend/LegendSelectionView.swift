//
//  LegendSelectionView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct LegendSelectionView<LegendView: View>: View {
    
    @Binding var color: Color
    
    let bannedColor: Set<IdentifiableColor>
    
    let legendView: () -> LegendView
    
    var body: some View {
        ScrollView {
            VStack {
                ColorSelectionView(
                    selectedColor: $color,
                    theme: .chart,
                    bannedColor: bannedColor
                )
                
                legendView()
            }
            .padding(.all)
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    
    @Previewable @State var color = Color.red
    
    LegendSelectionView(color: $color, bannedColor: []) { EmptyView() }
}
