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
    
    let theme: ColorTheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(theme.presets) { color in
                    Circle()
                        .fill(color.color)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: selectedColor == color.color ? 3 : 0)
                        )
                        .onTapGesture {
                            selectedColor = color.color
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var color: Color = .red
    
    ColorSelectionView(selectedColor: $color, theme: .chart)
}
