//
//  FootballTeamSelectView.swift
//  EDICC
//
//  Created by 노우영 on 12/20/25.
//

import SwiftUI

@MainActor
class FootballTeamSelectViewModel {
    var model = FootballTeamSelectModel()
    var squadVM: FootballSquadViewModel?
    
    private var footballService: FootballService
    
    init(footballService: FootballService = .live) {
        self.footballService = footballService
    }
    
    func downArrowTapped() {
        model.selectedTeam = nil
        model.selectedSeason = nil
        model.availableSeasons.removeAll()
    }
    
    func teamCardTapped(_ team: EPLTeam) {
        if model.selectedTeam == team {
            model.selectedTeam = nil
            model.availableSeasons.removeAll()
        } else {
            let needsSeasonUpdate = model.selectedTeam != team
            
            model.selectedTeam = team
            
            Task {
                if needsSeasonUpdate {
                    let response = try await footballService.fetchAvailableSeason(team.id)
                    model.availableSeasons = response.response
                }
            }
        }
    }
    
    func seasonTapped(_ season: Int) {
        guard let team = model.selectedTeam else { return }
        model.selectedSeason = season
        
        let model = FootballSquadModel(targetSeason: season, team: team)
        
        squadVM = FootballSquadViewModel(
            model: model,
            footballService: footballService,
            onPlayerSelected: { [weak self] player in
                self?.handlePlayerSelected(player)
            })
    }
    
    private func handlePlayerSelected(_ player: FootballPlayer) {
        
    }
}

@Observable
class FootballTeamSelectModel {
    var selectedTeam: EPLTeam? = nil
    var selectedSeason: Int? = nil
    
    var availableSeasons: [Int] = []
    
    var isSeansomTeamSelected: Bool {
        selectedTeam != nil && selectedSeason != nil
    }
    
}


struct FootballTeamSelectView: View {
    
    @Namespace private var animation
    @State private var vm: FootballTeamSelectViewModel
    
    let teamColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    let teams: [[EPLTeam]] = EPLTeam.allCases.chunked(into: 2)
    
    init(vm: FootballTeamSelectViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if !vm.model.isSeansomTeamSelected {
                selectView
                    .matchedGeometryEffect(id: "morph", in: animation)
            }
            
            if let selectedTeam = vm.model.selectedTeam,
               let selectedSeason = vm.model.selectedSeason,
               let squadVM = vm.squadVM {
                VStack {
                    HStack {
                        FootballSelectionSummaryView(
                            team: selectedTeam,
                            season: selectedSeason
                        ) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                vm.downArrowTapped()
                            }
                        }
                        
                        Spacer()
                    }
                    
                    FootballSquadView(vm: squadVM)
                }
                .matchedGeometryEffect(id: "morph", in: animation)
            }
        }
        .padding(.top, vm.model.isSeansomTeamSelected ? 0 : 20)
    }
    
    var selectView: some View {
        VStack(alignment: .leading, spacing: 24) {
            introduction()
            
            LazyVGrid(columns: teamColumns, spacing: 16) {
                ForEach(teams, id: \.self) { chunk in
                    Section {
                        ForEach(chunk) { team in
                            teamCard(team)
                        }
                    } footer: {
                        if let selected = vm.model.selectedTeam, chunk.contains(selected) {
                            SeasonSelectView(
                                selecedTeam: selected,
                                seasons: vm.model.availableSeasons
                            ) { season in
                                vm.seasonTapped(season)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
        }
    }
    
    func teamCard(_ team: EPLTeam) -> some View {
        TeamGridCard(
            team: team,
            isSelected: vm.model.selectedTeam == team
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                vm.teamCardTapped(team)
            }
        }
    }
    
    func introduction() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Team")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            Text("팀을 선택해주세요")
                .font(.system(size: 28, weight: .bold, design: .rounded))
        }
        .padding(.horizontal, 24)
    }
}


// MARK: - Subview: 팀 카드
struct TeamGridCard: View {
    let team: EPLTeam
    let isSelected: Bool
    
    var url: URL? {
        URL(string: "https://media.api-sports.io/football/teams/\(team.id).png")
    }
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                
            } placeholder: {
                Image(systemName: "soccerball")
                    .font(.title)
                    .foregroundColor(.black.opacity(0.7))
            }
            .frame(width: 70, height: 70)
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(team.color)
                        .background(Circle().fill(.white))
                        .offset(x: 4, y: -4)
                }
            }
            
            // 팀 이름
            Text(team.name)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(isSelected ? .black : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(isSelected ? team.color : Color.clear, lineWidth: 3)
        )
        .shadow(
            color: isSelected ? Color.blue.opacity(0.1) : Color.black.opacity(0.03),
            radius: isSelected ? 10 : 5,
            x: 0,
            y: 4
        )
        .scaleEffect(isSelected ? 0.98 : 1.0)
    }
}

// MARK: - Data Model
struct TeamData: Identifiable {
    let id: Int
    let name: String
    let color: Color
    let icon: String
}

// Preview animation 문제
// Team -> Season -> 재선택 -> 동일 팀 선택 시 시즌 화면이 이상한 곳에서부터 시작되는 문제가 있으나
// 프리뷰에서만 발생 -2024. 12. 24
#Preview {
    ScrollView {
        FootballTeamSelectView(
            vm: FootballTeamSelectViewModel(footballService: .preview)
        )
        .padding(.horizontal)
    }
}
