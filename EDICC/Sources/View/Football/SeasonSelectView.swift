//
//  FootballSeasonView.swift
//  EDICC
//
//  Created by 노우영 on 12/18/25.
//

import SwiftUI

struct SeasonSelectView: View {
    
    let selecedTeam: EPLTeam
    let seasons: [Int]
    var seasonTapped: (Int) -> Void
    
    let seasonColumns = [
        GridItem(.adaptive(minimum: 80), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: seasonColumns, spacing: 12) {
            ForEach(seasons, id: \.self) { season in
                SeasonChip(season: season, color: selecedTeam.color)
                    .onTapGesture {
                        withAnimation {
                            seasonTapped(season)
                        }
                    }
            }
        }
        .padding(.top, 16)
    }
}

struct SeasonChip: View {
    let season: Int
    let color: Color
    
    var body: some View {
        Text("\(String(season).suffix(2))/\(String(season + 1).suffix(2))")
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
    }
}
