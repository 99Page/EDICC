//
//  PlayerCard.swift
//  EDICC
//
//  Created by 노우영 on 1/5/26.
//

import SwiftUI

struct PlayerRowCard: View {
    let player: FootballPlayer
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: player.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "person.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(width: 48, height: 48)
            .background(Color(uiColor: .systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Text("\(player.country.flag) \(player.name)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            if let position = player.position {
                Text(position.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    PlayerRowCard(player: .init(dto: .brunoFernandes23))
}
