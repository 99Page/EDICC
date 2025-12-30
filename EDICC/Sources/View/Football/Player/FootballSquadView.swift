//
//  FootballPlayerSelectView.swift
//  EDICC
//
//  Created by 노우영 on 12/24/25.
//

import SwiftUI

@Observable
class FootballSquadViewModel {
    
    var model: FootballSquadModel
    var onPlayerTapped: (_ player: FootballPlayer) -> Void
    
    private let footballService: FootballService
    
    init(
        model: FootballSquadModel,
        footballService: FootballService = .live,
        playerTapped: @escaping (FootballPlayer) -> Void
    ) {
        self.model = model
        self.footballService = footballService
        self.onPlayerTapped = playerTapped
    }
    
    func onAppear() {
        guard model.players.isEmpty else { return }

        Task {
            do {
                let response = try await footballService.fetchStatistics(model.targetSeason, model.team.id)
                model.players = response.response.map { FootballPlayer(dto: $0) }
            } catch {
                debugPrint("error: \(error)")
            }
        }
    }
    
    func tapPlayer(_ player: FootballPlayer) {
        onPlayerTapped(player)
    }
}

@Observable
class FootballSquadModel {
    let targetSeason: Int
    var team: EPLTeam
    var positionFilter: FootballPosition = .all
    var players: [FootballPlayer] = []
    
    init(targetSeason: Int, team: EPLTeam) {
        self.targetSeason = targetSeason
        self.team = team
    }
}


struct FootballSquadView: View {
    
    let vm: FootballSquadViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            headerView
                .padding(.top, 10)
            
            playerList
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    var playerList: some View {
        LazyVStack(spacing: 12) {
            ForEach(vm.model.players) { player in
                Button {
                    vm.onPlayerTapped(player)
                } label: {
                    PlayerRowCard(player: player)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
    }
    
    var headerView: some View {
        HStack {
            Text("Squad List")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .layoutPriority(1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(FootballPosition.allCases, id: \.self) { position in
                        PositionFilterButton(
                            position: position.rawValue,
                            isSelected: vm.model.positionFilter == position,
                            color: vm.model.team.color
                        ) {
                            withAnimation(.spring()) {
                                vm.model.positionFilter = position
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 하위 컴포넌트: 필터 버튼
struct PositionFilterButton: View {
    let position: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(position)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(
                    Capsule()
                        .fill(isSelected ? color : Color.white)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )
        }
    }
}

// MARK: - 하위 컴포넌트: 선수 카드 (Row)
struct PlayerRowCard: View {
    let player: FootballPlayer
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: player.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()// 이미지가 꽉 차게
            } placeholder: {
                // 이미지가 없을 때나 로딩 중일 때 중앙에 아이콘 표시
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
    var model = FootballSquadModel(targetSeason: 2021, team: .liverpool)
    let viewModel = FootballSquadViewModel(
        model: model,
        footballService: .preview
    ) { _ in }
    
    FootballSquadView(vm: viewModel)
}
