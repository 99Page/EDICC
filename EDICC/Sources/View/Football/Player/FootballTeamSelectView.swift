//
//  FootballTeamSelectView.swift
//  EDICC
//
//  Created by 노우영 on 12/20/25.
//

import SwiftUI

@Observable
class FootballTeamSelectViewModel: Identifiable, HexagonUpdatable {
    
    let id = UUID()
    var model = FootballTeamSelectModel()
    var squadVM: FootballSquadViewModel?
    
    var hexagonTarget: HexagonDataSet
    var hexagonModel: HexagonCardModel
    
    private var footballService: FootballService
    
    init(
        hexagonTarget: HexagonDataSet,
        hexagonModel: HexagonCardModel,
        footballService: FootballService = .live
    ) {
        self.hexagonTarget = hexagonTarget
        self.hexagonModel = hexagonModel
        self.footballService = footballService
    }
    
    func tapResetButton() {
        model.selectedTeam = nil
        model.selectedSeason = nil
    }
    
    func teamCardTapped(_ team: EPLTeam) {
        if model.selectedTeam == team {
            model.selectedTeam = nil
        } else {
            model.selectedTeam = team
        }
    }
    
    func seasonTapped(_ season: Int) {
        guard let team = model.selectedTeam else { return }
        model.selectedSeason = season
        
        let model = FootballSquadModel(targetSeason: season, team: team)
        
        squadVM = FootballSquadViewModel(
            model: model,
            footballService: .live
        ) { [weak self] in
            self?.onPlayerSelected($0)
        }
    }
    
    private func onPlayerSelected(_ player: FootballPlayer) {
        let newHexagon = HexagonDataSet(
            label: player.label,
            color: hexagonTarget.color,
            points: player.hexagonPoints(standard: FootballPlayer.self)
        )
        
        updateHexagon(new: newHexagon)
    }
}

@Observable
class FootballTeamSelectModel {
    var selectedTeam: EPLTeam? = nil
    var selectedSeason: Int? = nil
    
    var availableSeasons: [Int] = [2023, 2022, 2021]
    
    var isSeansonTeamSelected: Bool {
        selectedTeam != nil && selectedSeason != nil
    }
    
}


struct FootballTeamSelectView: View {
    
    @Namespace private var animation
    let vm: FootballTeamSelectViewModel
    
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
            if !vm.model.isSeansonTeamSelected {
                selectView
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
                            vm.tapResetButton()
                        }
                        
                        Spacer()
                    }
                    
                    FootballSquadView(vm: squadVM)
                }
            }
        }
        .padding(.top, vm.model.isSeansonTeamSelected ? 0 : 20)
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
    @Previewable @State var cardModel = HexagonCardModel(chart: HexagonChartModel())
    
    ScrollView {
        FootballTeamSelectView(
            vm: FootballTeamSelectViewModel(
                hexagonTarget: .mockAverage(),
                hexagonModel: cardModel,
                footballService: .preview
            ) 
        )
        .padding(.horizontal)
    }
}

