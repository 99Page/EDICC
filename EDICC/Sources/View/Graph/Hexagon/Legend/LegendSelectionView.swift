//
//  LegendSelectionView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct LegendSelectionView<LegendView: View>: View {
    
    @State private var currentDetent: PresentationDetent = .medium
    @Binding var color: Color
    
    let bannedColor: Set<IdentifiableColor>
    
    let legendView: () -> LegendView
    
    var body: some View {
        ScrollView {
            VStack {
                if currentDetent != .large {
                    ColorSelectionView(
                        selectedColor: $color,
                        theme: .chart,
                        bannedColor: bannedColor
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                legendView()
            }
            .padding(.all)
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .large], selection: $currentDetent)
        .animation(.spring, value: currentDetent)
    }
}

#Preview {
    
    @Previewable @State var color = Color.red
    
    LegendSelectionView(color: $color, bannedColor: []) { EmptyView() }
}
