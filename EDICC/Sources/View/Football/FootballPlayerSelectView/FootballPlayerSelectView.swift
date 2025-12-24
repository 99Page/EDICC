//
//  FootballPlayerSelectView.swift
//  EDICC
//
//  Created by 노우영 on 12/24/25.
//

import SwiftUI

@MainActor
class FootballSquadViewModel {
    var model: FootballSquadModel
    
    private let footballService: FootballService
    
    var onPlayerSelected: (FootballPlayer) -> Void
    
    init(
        model: FootballSquadModel,
        footballService: FootballService = .live,
        onPlayerSelected: @escaping (FootballPlayer) -> Void
    ) {
        self.model = model
        self.footballService = footballService
        self.onPlayerSelected = onPlayerSelected
    }
    
    func onAppear() {
        guard model.players.isEmpty else { return }

        
        Task {
            let response = try await footballService.fetchSquad(model.targetSeason, model.team.id)
            model.players = response.response.first?.players.map { FootballPlayer(dto: $0) } ?? []
        }
    }
    
    func playerSelected(_ player: FootballPlayer) {
        onPlayerSelected(player)
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
                .padding(.horizontal, 24)
            
            playerList
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .onAppear {
            vm.onAppear()
        }
    }
    
    var playerList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(vm.model.players) { player in
                    Button {
                        vm.playerSelected(player)
                    } label: {
                        PlayerRowCard(player: player)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40) // 하단 여백
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
            
            Text("\(player.formattedNumber) \(player.name)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(player.position.rawValue)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(4)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}


enum FootballPosition: String, CaseIterable {
    case all = "ALL"
    case fw = "FW"
    case mf = "MF"
    case df = "DF"
    case gk = "GK"
    
    init(from dto: PositionDTO) {
        switch dto {
        case .attacker:
            self = .fw
        case .midfielder:
            self = .mf
        case .defender:
            self = .df
        case .goalkeeper:
            self = .gk
        }
    }
}

struct FootballPlayer: Identifiable {
    let id = UUID()
    let name: String
    let number: Int
    let position: FootballPosition
    let imageURL: String?
    
    var formattedNumber: String {
        return String(format: "%02d", number)
    }
    
    init(name: String, number: Int, position: FootballPosition, imageURL: String?) {
        self.name = name
        self.number = number
        self.position = position
        self.imageURL = imageURL
    }
    
    init(dto: FootballPlayerDTO) {
        self.name = dto.name
        self.number = dto.number
        self.position = .init(from: dto.position)
        self.imageURL = dto.photo
    }
}

#Preview {
    var model = FootballSquadModel(targetSeason: 2021, team: .liverpool)
    let viewModel = FootballSquadViewModel(model: model, footballService: .preview) { _ in }
    
    FootballSquadView(vm: viewModel)
}
