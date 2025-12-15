//
//  LegendSelectionView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct LegendSelectionView: View {
    
    @Binding var color: Color
    
    var body: some View {
        ScrollView {
            ColorSelectionView(selectedColor: $color, theme: .chart)
        }
    }
}

#Preview {
    
    @Previewable @State var color = Color.red
    LegendSelectionView(color: $color)
}
