//
//  ColorSelectionView.swift
//  EDICC
//
//  Created by 노우영 on 12/16/25.
//

import SwiftUI

struct ColorSelectionView: View {
    
    enum ColorTheme {
        case chart
        
        var presets: [IdentifiableColor] {
            switch self {
            case .chart:
                [
                    IdentifiableColor(.creamyOrange), IdentifiableColor(.iceBlue), IdentifiableColor(.lavendar),
                    IdentifiableColor(.lemonYellow), IdentifiableColor(.pastelPink), IdentifiableColor(.softMint)
                ]
            }
        }
    }
    
    @Binding var selectedColor: Color
    
    let presets: [IdentifiableColor]
    let bannedColor: Set<IdentifiableColor>
    
    init(selectedColor: Binding<Color>, theme: ColorTheme, bannedColor: Set<IdentifiableColor> = []) {
        self._selectedColor = selectedColor
        self.presets = theme.presets.filter { !bannedColor.contains($0) }
        self.bannedColor = bannedColor
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(presets) { color in
                    Circle()
                        .fill(color.value)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: selectedColor == color.value ? 3 : 0)
                        )
                        .onTapGesture {
                            selectedColor = color.value
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var color: Color = .red
    
    ColorSelectionView(
        selectedColor: $color,
        theme: .chart,
        bannedColor: [] // Pass an empty set for preview
    )
}
