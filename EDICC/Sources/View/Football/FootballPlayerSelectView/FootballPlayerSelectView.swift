//
//  FootballPlayerSelectView.swift
//  EDICC
//
//  Created by 노우영 on 12/24/25.
//

import SwiftUI

@MainActor
class FootballSquadViewModel {
    var model = FootballSquadModel()
    
    private let footballService: FootballService
    
    var onPlayerSelected: (Player) -> Void
    
    init(
        footballService: FootballService = .live,
        onPlayerSelected: @escaping (Player) -> Void
    ) {
        self.footballService = footballService
        self.onPlayerSelected = onPlayerSelected
    }
    
    func onAppear() {
        guard model.players.isEmpty else { return }
        
        Task {
            
        }
    }
    
    func playerSelected(_ player: Player) {
        onPlayerSelected(player)
    }
}

@Observable
class FootballSquadModel {
    var team: EPLTeam = .machesterUnited
    var positionFilter: PlayerPosition = .all
    var players: [Player] = Player.dummies
}


struct FootballSquadView: View {
    
    let vm: FootballSquadViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Squad List")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(PlayerPosition.allCases, id: \.self) { position in
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
            
            .padding(.top, 10)
            .padding(.horizontal, 24)
            
            // 2. 선수 리스트
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(vm.model.players) { player in
                        PlayerRowCard(player: player)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40) // 하단 여백
            }
        }
        .background(Color(uiColor: .systemGroupedBackground)) // 배경색 약간 회색
        .onAppear {
            
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
    let player: Player
    
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
            .frame(width: 48, height: 48) // 터치하기 좋게 크기 약간 키움 (44 -> 48)
            // ⭐️ 1. 배경색: 연한 회색 (시스템 컬러 사용 추천)
            .background(Color(uiColor: .systemGray6))
            // ⭐️ 2. 모양: 원(Circle) 대신 둥근 사각형(RoundedRectangle) 적용
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            // 3. 이름 및 포지션
            VStack(alignment: .leading, spacing: 2) {
                Text("\(player.formattedNumber) \(player.name)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(player.position.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            // 4. 국적 또는 상세 화살표
            Text(player.nationality) // 국적 이모지
                .font(.title3)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        // 카드 그림자
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}


enum PlayerPosition: String, CaseIterable {
    case all = "ALL"
    case fw = "FW"
    case mf = "MF"
    case df = "DF"
    case gk = "GK"
}

struct Player: Identifiable {
    let id = UUID()
    let name: String
    let number: Int
    let position: PlayerPosition
    let nationality: String // 국적 (이모지 or 이미지 URL)
    let imageURL: String?
    
    var formattedNumber: String {
        return String(format: "%02d", number)
    }
}

extension Player {
    static let dummies = [
        Player(name: "Bruno Fernandes", number: 8, position: .mf, nationality: "🇵🇹", imageURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p141746.png"),
        Player(name: "Marcus Rashford", number: 10, position: .fw, nationality: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", imageURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p176297.png"),
        Player(name: "Harry Maguire", number: 5, position: .df, nationality: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", imageURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p95658.png"),
        Player(name: "André Onana", number: 24, position: .gk, nationality: "🇨🇲", imageURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p202641.png"),
        Player(name: "Casemiro", number: 18, position: .mf, nationality: "🇧🇷", imageURL: "https://resources.premierleague.com/premierleague/photos/players/250x250/p61366.png")
    ]
}

#Preview {
    FootballSquadView(vm: FootballSquadViewModel(footballService: .preview, onPlayerSelected: { _ in
        
    }))
}
