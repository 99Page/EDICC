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
    
    init(selectedColor: Binding<Color>, theme: ColorTheme, bannedColor: Set<IdentifiableColor> = []) {
        self._selectedColor = selectedColor
        self.presets = theme.presets.filter { !bannedColor.contains($0) }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(presets) { color in
                    colorCircle(for: color)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func colorCircle(for color: IdentifiableColor) -> some View {
        let isSelected = selectedColor == color.value
        
        Circle()
            .fill(color.value)
            .frame(width: 20, height: 20)
            .overlay {
                if isSelected {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                }
            }
            .onTapGesture {
                selectedColor = color.value
            }
            .padding(4)
            .contentShape(Circle())
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
