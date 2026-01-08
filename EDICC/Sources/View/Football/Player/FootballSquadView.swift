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
    
    func tapPlayer(_ player: FootballPlayer) {
        onPlayerTapped(player)
    }
    
    func paging() async {
        do {
            guard model.hasMoreToFetch else { return }
            
            let param = FootballService.StatisticsParameters(
                season: model.targetSeason,
                teamID: model.team.id,
                page: model.fetchPage
            )
            
            let response = try await footballService.fetchStatistics(param)
            
            let players = response.response.map { FootballPlayer(dto: $0) }
            
            model.fetchPage += 1
            model.hasMoreToFetch = response.paging.current < response.paging.total
            
            Task { @MainActor in
                model.append(players)
                model.updateLastPlayer()
            }
        } catch let error as RapidAPIError {
            // 요금제로 인한 접근 불가 시 별도 처리 x
            guard case let .serverMessage(dictionary) = error, dictionary["plan"] == nil else { return }
            model.showFetchFailAlert()
        } catch {
            model.showFetchFailAlert()
        }
    }
}

@Observable
class FootballSquadModel {
    private(set) var players: [FootballPlayer] = {
        var result: [FootballPlayer] = []
        let count = 5
        for index in 1...count {
            let randomId = Int.random(in: 0...Int.max)
            var player = FootballPlayer(id: randomId, isPlaceholder: true, dto: .brunoFernandes23)
            player.isLastItem = index == count
            result.append(player)
        }
        return result
    }()
    
    let targetSeason: Int
    var team: EPLTeam
    
    var alertMessage = "선수 정보를 가져올 수 없어요"
    var isFetchAlertPresented = false
    var lastPlayerIndex: Int? = nil
    
    var fetchPage = 1
    var hasMoreToFetch = true
    
    init(targetSeason: Int, team: EPLTeam) {
        self.targetSeason = targetSeason
        self.team = team
    }
    
    func append(_ newPlayers: [FootballPlayer]) {
        if players.first?.isPlaceholder ?? false { players.removeAll() } // 처음 아이템이 플레이스홀더면 나머지도 전부 플레이스홀더로 취급
        players.append(contentsOf: newPlayers)
    }
    
    func showFetchFailAlert(_ message: String = "선수 정보를 가져올 수 없어요") {
        isFetchAlertPresented = true
        alertMessage = message
    }
    
    func updateLastPlayer() {
        if let lastPlayerIndex {
            players[lastPlayerIndex].isLastItem = false
        }
        
        let newLastIndex = players.count - 1
        
        lastPlayerIndex = newLastIndex
        
        if let lastPlayerIndex {
            players[lastPlayerIndex].isLastItem = true
        }
    }
}

struct FootballSquadView: View {
    
    @Bindable var vm: FootballSquadViewModel
    let spacing: CGFloat = 12
    
    var body: some View {
        LazyVStack(spacing: spacing) {
            ForEach(vm.model.players) { player in
                Button {
                    vm.onPlayerTapped(player)
                } label: {
                    PlayerRowCard(player: player)
                }
                .redacted(reason: player.isPlaceholder ? [.placeholder] : [])
                .onPagingTrigger(isLastItem: player.isLastItem) {
                    await vm.paging()
                }
            }
        }
        .alert(vm.model.alertMessage, isPresented: $vm.model.isFetchAlertPresented) { }
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


#Preview("success") {
    let model = FootballSquadModel(targetSeason: 2021, team: .liverpool)
    let viewModel = FootballSquadViewModel(
        model: model,
        footballService: .preview
    ) { _ in }

    ScrollView {
        FootballSquadView(vm: viewModel)
    }
}

#Preview("fail") {
    let model = FootballSquadModel(targetSeason: 2021, team: .liverpool)
    let viewModel = FootballSquadViewModel(
        model: model,
        footballService: .failure
    ) { _ in }

    ScrollView {
        FootballSquadView(vm: viewModel)
    }
}
